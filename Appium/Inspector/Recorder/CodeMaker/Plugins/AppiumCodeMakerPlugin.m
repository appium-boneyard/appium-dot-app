//
//  AppiumCodeMakerPlugin.m
//  Appium
//
//  Created by Dan Cuellar on 4/15/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerPlugin.h"

#import "AppiumAppDelegate.h"
#import "AppiumGlobals.h"

@implementation AppiumCodeMakerPlugin

-(id) initWithCodeMaker:(AppiumCodeMaker *)codeMaker
{
	APPIUM_ABSTRACT_CLASS_ERROR
}

#pragma mark - Instance Methods
-(AppiumModel*) model
{
    return [(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] model];
}

-(NSString*) preCodeBoilerplate
{
    return (self.model.platform == AppiumiOSPlatform) ? self.preCodeBoilerplateiOS : self.preCodeBoilerplateAndroid;
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
        case APPIUM_CODE_MAKER_ACTION_EXECUTE_SCRIPT:
            return [self executeScript:(AppiumCodeMakerActionExecuteScript*)action];
        case APPIUM_CODE_MAKER_ACTION_PRECISE_TAP:
            return [self preciseTap:(AppiumCodeMakerActionPreciseTap*)action];
		case APPIUM_CODE_MAKER_ACTION_SCROLL_TO:
			return [self scrollTo:(AppiumCodeMakerActionScrollTo *)action];
		case APPIUM_CODE_MAKER_ACTION_SEND_KEYS:
			return [self sendKeys:(AppiumCodeMakerActionSendKeys*)action];
		case APPIUM_CODE_MAKER_ACTION_SHAKE:
			return [self shake:(AppiumCodeMakerActionShake*)action];
        case APPIUM_CODE_MAKER_ACTION_SWIPE:
			return [self swipe:(AppiumCodeMakerActionSwipe*)action];
		case APPIUM_CODE_MAKER_ACTION_TAP:
			return [self tap:(AppiumCodeMakerActionTap*)action];
		default:
			return [self commentWithString:APPIUM_CODE_MAKER_PLUGIN_METHOD_NYI_STRING];
	}
}

#pragma mark - Abstract Methods

- (NSString *)fileExtension
{
	return nil;
}

-(NSString*) preCodeBoilerplateAndroid { APPIUM_ABSTRACT_CLASS_ERROR }

-(NSString*) preCodeBoilerplateiOS { APPIUM_ABSTRACT_CLASS_ERROR }

-(NSString*) acceptAlert
{
    return [self commentWithString:APPIUM_CODE_MAKER_PLUGIN_METHOD_NYI_STRING];
}

-(NSString*) comment:(AppiumCodeMakerActionComment*)action { APPIUM_ABSTRACT_CLASS_ERROR }

-(NSString*) commentWithString:(NSString *)comment { APPIUM_ABSTRACT_CLASS_ERROR }

-(NSString*) dismissAlert
{
    return [self commentWithString:APPIUM_CODE_MAKER_PLUGIN_METHOD_NYI_STRING];
}

-(NSString*) executeScript:(AppiumCodeMakerActionExecuteScript*)action
{
    return [self commentWithString:APPIUM_CODE_MAKER_PLUGIN_METHOD_NYI_STRING];
}

-(NSString*) preciseTap:(AppiumCodeMakerActionPreciseTap *)action
{
    return [self commentWithString:APPIUM_CODE_MAKER_PLUGIN_METHOD_NYI_STRING];
}

-(NSString *)scrollTo:(AppiumCodeMakerActionScrollTo *)action
{
	return [self commentWithString:APPIUM_CODE_MAKER_PLUGIN_METHOD_NYI_STRING];
}

-(NSString*) sendKeys:(AppiumCodeMakerActionSendKeys*)action
{
    return [self commentWithString:APPIUM_CODE_MAKER_PLUGIN_METHOD_NYI_STRING];
}

-(NSString*) shake:(AppiumCodeMakerActionShake*)action
{
    return [self commentWithString:APPIUM_CODE_MAKER_PLUGIN_METHOD_NYI_STRING];
}

-(NSString*) swipe:(AppiumCodeMakerActionSwipe*)action
{
    return [self commentWithString:APPIUM_CODE_MAKER_PLUGIN_METHOD_NYI_STRING];
}

-(NSString*) tap:(AppiumCodeMakerActionTap*)action
{
    return [self commentWithString:APPIUM_CODE_MAKER_PLUGIN_METHOD_NYI_STRING];
}

@end
