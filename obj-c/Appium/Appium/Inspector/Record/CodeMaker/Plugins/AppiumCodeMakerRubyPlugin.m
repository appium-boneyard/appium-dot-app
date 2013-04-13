//
//  AppiumCodeMakerRubyPlugin.m
//  Appium
//
//  Created by Dan Cuellar on 4/11/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerRubyPlugin.h"

@implementation AppiumCodeMakerRubyPlugin

-(id) initWithCodeMaker:(AppiumCodeMaker*)codeMaker
{
	self = [super init];
    if (self) {
        [self setCodeMaker:codeMaker];
    }
    return self;
}

-(NSString*) name { return @"Ruby"; }

-(NSString*) preCodeBoilerplate
{
    return
@"require 'rubygems'\n\
require 'selenium-webdriver'\
\n\
wd = Selenium::WebDriver.for :firefox\n\n";
}

-(NSString*) postCodeBoilerplate
{
    return @"wd.quit\n";
}

-(NSString*) renderAction:(AppiumCodeMakerAction*)action
{
	switch(action.actionType)
	{
		//case APPIUM_CODE_MAKER_ACTION_ALERT_ACCEPT:
		//	return [self acceptAlert];
		//case APPIUM_CODE_MAKER_ACTION_ALERT_DISMISS:
		//	return [self dismissAlert];
		case APPIUM_CODE_MAKER_ACTION_COMMENT:
			return [self comment:[action.params objectAtIndex:0]];
		case APPIUM_CODE_MAKER_ACTION_SEND_KEYS:
			return [self sendKeys:[action.params objectAtIndex:0] locator:[action.params objectAtIndex:1]];
		case APPIUM_CODE_MAKER_ACTION_TAP:
			return [self tap:[action.params objectAtIndex:0]];
		default:
			return [self comment:@"Action cannot currently be transcribed by Appium Recorder"];
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
			return [NSString stringWithFormat:@"wd.find_element(:name, \"%@\")", [self escapeString:newLocator.locatorString]];
		case APPIUM_CODE_MAKER_LOCATOR_TYPE_XPATH:
			return [NSString stringWithFormat:@"wd.find_element(:xpath, \"%@\")", [self escapeString:newLocator.locatorString]];
		default: return nil;
	}
}

-(NSString*) comment:(NSString*)comment
{
	return [NSString stringWithFormat:@"# %@\n", comment];
}

-(NSString*) sendKeys:(NSString*)keys locator:(AppiumCodeMakerLocator*)locator
{
	return [NSString stringWithFormat:@"%@.send_keys \"%@\"\n", [self locatorString:locator], [self escapeString:keys]];
}

-(NSString*) tap:(AppiumCodeMakerLocator*)locator
{
	return [NSString stringWithFormat:@"%@.click\n", [self locatorString:locator]];
}


@end
