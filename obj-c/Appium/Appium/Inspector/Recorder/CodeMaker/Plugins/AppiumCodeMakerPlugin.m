//
//  AppiumCodeMakerPlugin.m
//  Appium
//
//  Created by Dan Cuellar on 4/15/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerPlugin.h"
#import "AppiumGlobals.h"

@implementation AppiumCodeMakerPlugin

-(id) initWithCodeMaker:(AppiumCodeMaker *)codeMaker
{
	APPIUM_ABSTRACT_CLASS_ERROR
}

#pragma mark - Instance Methods
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
			return [self commentWithString:APPIUM_CODE_MAKER_PLUGIN_METHOD_NYI_STRING];
	}
}

#pragma mark - Abstract Methods
-(NSString*) acceptAlert { APPIUM_ABSTRACT_CLASS_ERROR }
-(NSString*) comment:(AppiumCodeMakerActionComment*)action { APPIUM_ABSTRACT_CLASS_ERROR }
-(NSString*) commentWithString:(NSString *)comment { APPIUM_ABSTRACT_CLASS_ERROR }
-(NSString*) dismissAlert { APPIUM_ABSTRACT_CLASS_ERROR }
-(NSString*) sendKeys:(AppiumCodeMakerActionSendKeys*)action { APPIUM_ABSTRACT_CLASS_ERROR }
-(NSString*) tap:(AppiumCodeMakerActionTap*)action { APPIUM_ABSTRACT_CLASS_ERROR }

@end
