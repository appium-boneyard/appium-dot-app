//
//  AppiumCodeMakerRubyPlugin.m
//  Appium
//
//  Created by Dan Cuellar on 4/11/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerRubyPlugin.h"
#import "AppiumCodeMakerActions.h"

@implementation AppiumCodeMakerRubyPlugin

-(id) initWithCodeMaker:(AppiumCodeMaker*)codeMaker
{
	self = [super init];
    if (self) {
        [self setCodeMaker:codeMaker];
    }
    return self;
}

#pragma mark - AppiumCodeMakerPlugin Implementation
-(NSString*) name { return @"Ruby"; }

-(NSString*) preCodeBoilerplateAndroid
{
    return [NSString stringWithFormat:@"require 'rubygems'\n\
require 'selenium-webdriver'\
\n\
capabilities = {\n\
\tdevice' => 'Android',\n\
\t'browserName' => '',\n\
\t'platform' => 'Mac',\n\
\t'version' => '4.2',\n\
\t'app' => '%@'\n\
\t'app-package' => '%@'\n\
\t'app-activity' => '%@'\n\
}\n\
\n\
server_url = \"http://%@:%@/wd/hub\"\n\
\n\
wd = Selenium::WebDriver.for(:remote, :desired_capabilities => capabilities, :url => server_url)\n", self.model.appPath, self.model.androidPackage, self.model.androidActivity, self.model.ipAddress, self.model.port];
}

-(NSString*) preCodeBoilerplateiOS
{
    return [NSString stringWithFormat:@"require 'rubygems'\n\
require 'selenium-webdriver'\
\n\
capabilities = {\n\
\t'browserName' => 'iOS',\n\
\t'platform' => 'Mac',\n\
\t'version' => '6.1',\n\
\t'app' => '%@'\n\
}\n\
\n\
server_url = \"http://%@:%@/wd/hub\"\n\
\n\
@wd = Selenium::WebDriver.for(:remote, :desired_capabilities => capabilities, :url => server_url)\n", self.model.appPath, self.model.ipAddress, self.model.port];
}

-(NSString*) postCodeBoilerplate
{
    return @"wd.quit\n";
}

-(NSString*) acceptAlert {return [self commentWithString:APPIUM_CODE_MAKER_PLUGIN_METHOD_NYI_STRING];}

-(NSString*) dismissAlert {return [self commentWithString:APPIUM_CODE_MAKER_PLUGIN_METHOD_NYI_STRING];}

-(NSString*) comment:(AppiumCodeMakerActionComment*)action
{
	return [self commentWithString:action.comment];
}

-(NSString*) commentWithString:(NSString*)comment
{
	return [NSString stringWithFormat:@"# %@\n", comment];
}

-(NSString*) executeScript:(AppiumCodeMakerActionExecuteScript*)action
{
    return [NSString stringWithFormat:@"@wd.execute_script \"%@\"\n", [self escapeString:action.script]];
}

-(NSString*) preciseTap:(AppiumCodeMakerActionPreciseTap*)action
{
    NSDictionary *args = [((NSArray*)[action.params objectForKey:@"args"]) objectAtIndex:0];
    return [NSString stringWithFormat:@"@wd.execute_script 'mobile: tap', \
:tapCount => %@, \
:touchCount => %@, \
:duration => %@, \
:x => %@, \
:y => %@\n",
            [args objectForKey:@"tapCount"], [args objectForKey:@"touchCount"], [args objectForKey:@"duration"], [args objectForKey:@"x"], [args objectForKey:@"y"]];
}

-(NSString*) sendKeys:(AppiumCodeMakerActionSendKeys*)action
{
	return [NSString stringWithFormat:@"%@.send_keys \"%@\"\n", [self locatorString:action.locator], [self escapeString:action.keys]];
}

-(NSString*) swipe:(AppiumCodeMakerActionSwipe*)action
{
    NSDictionary *args = [((NSArray*)[action.params objectForKey:@"args"]) objectAtIndex:0];
    return [NSString stringWithFormat:@"@wd.execute_script 'mobile: swipe', \
:touchCount => %@, \
:startX => %@, \
:startY => %@, \
:endX => %@, \
:endY => %@, \
:duration => %@\n",
            [args objectForKey:@"touchCount"], [args objectForKey:@"startX"], [args objectForKey:@"startY"], [args objectForKey:@"endX"], [args objectForKey:@"endY"], [args objectForKey:@"duration"]];
}

-(NSString*) tap:(AppiumCodeMakerActionTap*)action
{
	return [NSString stringWithFormat:@"%@.click\n", [self locatorString:action.locator]];
}

#pragma mark - Helper Methods
-(NSString*) escapeString:(NSString *)string
{
    return [string stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
}

-(NSString*) locatorString:(AppiumCodeMakerLocator*)locator
{
	AppiumCodeMakerLocator *newLocator = [self.codeMaker.useXPathOnly boolValue] ? [[AppiumCodeMakerLocator alloc] initWithLocatorType:APPIUM_CODE_MAKER_LOCATOR_TYPE_XPATH locatorString:locator.xPath xPath:locator.xPath] : [locator copy];
	
	switch(newLocator.locatorType)
	{
		case APPIUM_CODE_MAKER_LOCATOR_TYPE_NAME:
			return [NSString stringWithFormat:@"wd.find_element(:name, \"%@\")", [self escapeString:newLocator.locatorString]];
		case APPIUM_CODE_MAKER_LOCATOR_TYPE_XPATH:
			return [NSString stringWithFormat:@"wd.find_element(:xpath, \"%@\")", [self escapeString:newLocator.locatorString]];
		default: return nil;
	}
}

@end
