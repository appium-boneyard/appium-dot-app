//
//  AppiumCodeMakerPlugin.m
//  Appium
//
//  Created by Dan Cuellar on 4/15/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerPlugin.h"

@implementation AppiumCodeMakerPlugin

-(id) initWithCodeMaker:(AppiumCodeMaker *)codeMaker
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

+(NSString*) renderAction:(AppiumCodeMakerAction*)action withPlugin:(id<AppiumCodeMakerPlugin>)plugin;
{
	switch(action.actionType)
	{
		case APPIUM_CODE_MAKER_ACTION_ALERT_ACCEPT:
			return [plugin acceptAlert];
		case APPIUM_CODE_MAKER_ACTION_ALERT_DISMISS:
			return [plugin dismissAlert];
		case APPIUM_CODE_MAKER_ACTION_COMMENT:
			return [plugin comment:(AppiumCodeMakerActionComment*)action];
		case APPIUM_CODE_MAKER_ACTION_SEND_KEYS:
			return [plugin sendKeys:(AppiumCodeMakerActionSendKeys*)action];
		case APPIUM_CODE_MAKER_ACTION_TAP:
			return [plugin tap:(AppiumCodeMakerActionTap*)action];
		default:
			return [plugin commentWithString:APPIUM_CODE_MAKER_PLUGIN_METHOD_NYI_STRING];
	}
}

@end
