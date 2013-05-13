//
//  AppiumCodeMakerAction.h
//  Appium
//
//  Created by Dan Cuellar on 4/10/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Selenium/SERemoteWebDriver.h>

typedef enum appiumCodeMakerActionTypes
{
	APPIUM_CODE_MAKER_ACTION_ALERT_ACCEPT,
	APPIUM_CODE_MAKER_ACTION_ALERT_DISMISS,
	APPIUM_CODE_MAKER_ACTION_COMMENT,
    APPIUM_CODE_MAKER_ACTION_EXECUTE_SCRIPT,
	APPIUM_CODE_MAKER_ACTION_PRECISE_TAP,
    APPIUM_CODE_MAKER_ACTION_SCROLL_TO,
	APPIUM_CODE_MAKER_ACTION_SEND_KEYS,
	APPIUM_CODE_MAKER_ACTION_SHAKE,
	APPIUM_CODE_MAKER_ACTION_SWIPE,
	APPIUM_CODE_MAKER_ACTION_TAP


} AppiumCodeMakerActionType;

typedef void(^AppiumCodeMakerActionBlock)(SERemoteWebDriver*);

@interface AppiumCodeMakerAction : NSObject<NSCopying, NSCoding>

@property AppiumCodeMakerActionType actionType;
@property (readonly) NSMutableDictionary *params;
@property (readonly) AppiumCodeMakerActionBlock block;

@end
