//
//  AppiumCodeMakerPythonPlugin.m
//  Appium
//
//  Created by Dan Cuellar on 4/11/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerPythonPlugin.h"
#import "AppiumCodeMakerActions.h"

@interface AppiumCodeMakerPythonPlugin ()

@property (readonly) NSString* indentation;

@end

@implementation AppiumCodeMakerPythonPlugin

-(id) initWithCodeMaker:(AppiumCodeMaker*)codeMaker
{
	self = [super init];
    if (self) {
        [self setCodeMaker:codeMaker];
    }
    return self;
}

-(NSString*) name { return @"Python"; }

-(NSString*) preCodeBoilerplate
{
    return
@"from selenium.webdriver.firefox.webdriver import WebDriver\n\
from selenium.webdriver.common.action_chains import ActionChains\n\
import time\n\
\n\
success = True\n\
wd = WebDriver()\n\
wd.implicitly_wait(60)\n\
\n\
def is_alert_present(wd):\n\
\ttry:\n\
\t\twd.switch_to_alert().text\n\
\t\treturn True\n\
\texcept:\n\
\t\treturn False\n\
\n\
try:\n";
}

-(NSString*) postCodeBoilerplate
{
    return
@"finally:\n\
\twd.quit()\n\
\tif not success:\n\
\t\traise Exception(\"Test failed.\")\n";
}

-(NSString*) renderAction:(AppiumCodeMakerAction*)action
{
	switch(action.actionType)
	{
		case APPIUM_CODE_MAKER_ACTION_ALERT_ACCEPT:
			return [self acceptAlert];
		case APPIUM_CODE_MAKER_ACTION_ALERT_DISMISS:
			return [self dismissAlert];
		case APPIUM_CODE_MAKER_ACTION_COMMENT:
			return [self comment:(AppiumCodeMakerActionComment*)action];
		case APPIUM_CODE_MAKER_ACTION_SEND_KEYS:
			return [self sendKeys:(AppiumCodeMakerActionSendKeys*)action];
		case APPIUM_CODE_MAKER_ACTION_TAP:
			return [self tap:(AppiumCodeMakerActionTap*)action];
		default:
			return [self commentWithString:@"Action cannot currently be transcribed by Appium Recorder"];
	}
}

-(NSString*) escapeString:(NSString *)string
{
    return [string stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
}

-(NSString*) locatorString:(AppiumCodeMakerLocator*)locator
{
	AppiumCodeMakerLocator *newLocator = [_codeMaker.useXPathOnly boolValue] ? [[AppiumCodeMakerLocator alloc] initWithLocatorType:APPIUM_CODE_MAKER_LOCATOR_TYPE_XPATH locatorString:locator.xPath] : [locator copy];
	
	switch(newLocator.locatorType)
	{
		case APPIUM_CODE_MAKER_LOCATOR_TYPE_NAME:
			return [NSString stringWithFormat:@"wd.find_elements_by_name(\"%@\")", [self escapeString:newLocator.locatorString]];
		case APPIUM_CODE_MAKER_LOCATOR_TYPE_XPATH:
			return [NSString stringWithFormat:@"wd.find_elements_by_xpath(\"%@\")", [self escapeString:newLocator.locatorString]];
		default: return nil;
	}
}

-(NSString*) indentation { return [self.codeMaker.useBoilerPlate boolValue] ? @"\t" : @""; }

-(NSString*) acceptAlert
{
	return [NSString stringWithFormat:@"%@wd.switch_to_alert().accept()\n", self.indentation];
}

-(NSString*) comment:(AppiumCodeMakerActionComment*)action
{
	return [self commentWithString:action.comment];
}

-(NSString*) commentWithString:(NSString*)comment
{
	return [NSString stringWithFormat:@"%@# %@\n", self.indentation, comment];
}

-(NSString*) dismissAlert
{
	return [NSString stringWithFormat:@"%@wd.switch_to_alert().dismiss()\n", self.indentation];
}

-(NSString*) sendKeys:(AppiumCodeMakerActionSendKeys*)action
{
	return [NSString stringWithFormat:@"%@%@.send_keys(\"%@\")\n", self.indentation, [self locatorString:action.locator], [self escapeString:action.keys]];
}

-(NSString*) tap:(AppiumCodeMakerActionTap*)action
{
	return [NSString stringWithFormat:@"%@%@.click()\n", self.indentation, [self locatorString:action.locator]];
}

@end
