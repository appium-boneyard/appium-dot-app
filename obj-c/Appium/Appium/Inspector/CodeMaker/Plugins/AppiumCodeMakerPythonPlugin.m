//
//  AppiumCodeMakerPythonPlugin.m
//  Appium
//
//  Created by Dan Cuellar on 4/11/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerPythonPlugin.h"

@implementation AppiumCodeMakerPythonPlugin

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

-(NSString*) escapeString:(NSString *)string
{
    return [string stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
}

-(NSString*) locatorString:(AppiumCodeMakerLocator*)locator
{
	switch(locator.locatorType)
	{
		case APPIUM_CODE_MAKER_LOCATOR_TYPE_NAME:
			return [NSString stringWithFormat:@"wd.find_elements_by_name(\"%@\")", [self escapeString:locator.locatorString]];
		case APPIUM_CODE_MAKER_LOCATOR_TYPE_XPATH:
			return [NSString stringWithFormat:@"wd.find_elements_by_xpath(\"%@\")", [self escapeString:locator.locatorString]];
		default: return nil;
	}
}

-(NSString*) renderAction:(AppiumCodeMakerAction*)action
{
	switch(action.actionType)
	{
		case APPIUM_CODE_MAKER_ACTION_COMMENT:
			return [self comment:[action.params objectAtIndex:0]];
		case APPIUM_CODE_MAKER_ACTION_SEND_KEYS:
			return [self sendKeys:[action.params objectAtIndex:0] locator:[action.params objectAtIndex:1]];
		case APPIUM_CODE_MAKER_ACTION_TAP:
			return [self tap:[action.params objectAtIndex:0]];
		default:
			return nil;
	}
}

-(NSString*) comment:(NSString*)comment
{
	return [NSString stringWithFormat:@"\t# %@\n", comment];
}

-(NSString*) sendKeys:(NSString*)keys locator:(AppiumCodeMakerLocator*)locator
{
	return [NSString stringWithFormat:@"\t%@.send_keys(\"%@\")\n", [self locatorString:locator], [self escapeString:keys]];
}

-(NSString*) tap:(AppiumCodeMakerLocator*)locator
{
	return [NSString stringWithFormat:@"\t%@.click()\n", [self locatorString:locator]];
}

@end
