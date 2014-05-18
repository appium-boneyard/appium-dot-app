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
require 'appium_lib'\
\n\
capabilities = {\n\
\t'appium-version': '1.0',\n\
\tplatformName: '%@',\n\
\tplatformVersion: '%@',\n\
\tdeviceName: '%@',\n\
\tapp: '%@',\n\
\t:'appPackage' => '%@',\n\
\t:'appActivity' => '%@'\n\
}\n\
\n\
server_url = \"http://%@:%@/wd/hub\"\n\
\n\
Appium::Driver.new(caps: capabilities).start_driver\n\
Appium.promote_appium_methods Object\n\
\n ", self.model.android.platformName, self.model.android.platformVersionNumber, self.model.android.deviceName, self.model.android.appPath, self.model.android.package, self.model.android.activity, self.model.general.serverAddress, self.model.general.serverPort];
}

-(NSString*) preCodeBoilerplateiOS
{
    return [NSString stringWithFormat:@"require 'rubygems'\n\
require 'appium_lib'\
\n\
capabilities = {\n\
\t'appium-version': '1.0',\n\
\tplatformName: 'iOS',\n\
\tplatformVersion: '%@',\n\
\tdeviceName: '%@',\n\
\tapp: '%@'\n\
}\n\
\n\
server_url = \"http://%@:%@/wd/hub\"\n\
\n\
Appium::Driver.new(caps: capabilities).start_driver\n\
Appium.promote_appium_methods Object\n\
\n", self.model.iOS.platformVersion, self.model.iOS.deviceName, self.model.iOS.appPath, self.model.general.serverAddress, self.model.general.serverPort];
}

-(NSString*) postCodeBoilerplate
{
    return @"driver_quit\n";
}

-(NSString*) acceptAlert
{
	return @"alert_accept\n";
}

-(NSString*) dismissAlert
{
	return @"alert_dismiss\n";
}

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
    return [NSString stringWithFormat:@"execute_script \"%@\"\n", [self escapeString:action.script]];
}

-(NSString*) preciseTap:(AppiumCodeMakerActionPreciseTap*)action
{
    NSDictionary *args = [((NSArray*)[action.params objectForKey:@"args"]) objectAtIndex:0];
    return [NSString stringWithFormat:@"Appium::TouchAction.new \
:x => %@, \
:y => %@, \
:fingers => %@, \
:tapCount => %@, \
:duration => %@\n",
            [args objectForKey:@"x"], [args objectForKey:@"y"], [args objectForKey:@"touchCount"],
				[args objectForKey:@"tapCount"], [args objectForKey:@"duration"]];
}

-(NSString*) sendKeys:(AppiumCodeMakerActionSendKeys*)action
{
	return [NSString stringWithFormat:@"%@.send_keys \"%@\"\n", [self locatorString:action.locator], [self escapeString:action.keys]];
}

-(NSString*) shake:(AppiumCodeMakerActionShake*)action
{
    return [NSString stringWithFormat:@"shake\n"];
}

-(NSString*) swipe:(AppiumCodeMakerActionSwipe*)action
{
    NSDictionary *args = [((NSArray*)[action.params objectForKey:@"args"]) objectAtIndex:0];
    return [NSString stringWithFormat:@"swipe \
:start_x => %@, \
:start_x => %@, \
:end_x => %@, \
:end_y => %@, \
:touchCount => %@, \
:duration => %@\n",
            [args objectForKey:@"startX"], [args objectForKey:@"startY"], [args objectForKey:@"endX"],
				[args objectForKey:@"endY"], [args objectForKey:@"touchCount"], [args objectForKey:@"duration"]];
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
			return [NSString stringWithFormat:@"find_element(:name, \"%@\")", [self escapeString:newLocator.locatorString]];
		case APPIUM_CODE_MAKER_LOCATOR_TYPE_XPATH:
			return [NSString stringWithFormat:@"find_element(:xpath, \"%@\")", [self escapeString:newLocator.locatorString]];
		default: return nil;
	}
}

@end
