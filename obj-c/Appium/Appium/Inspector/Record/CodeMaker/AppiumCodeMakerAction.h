//
//  AppiumCodeMakerAction.h
//  Appium
//
//  Created by Dan Cuellar on 4/10/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum appiumCodeMakerActionTypes
{
	APPIUM_CODE_MAKER_ACTION_ALERT_ACCEPT,
	APPIUM_CODE_MAKER_ACTION_ALERT_DISMISS,
	APPIUM_CODE_MAKER_ACTION_COMMENT,
	APPIUM_CODE_MAKER_ACTION_SEND_KEYS,
	APPIUM_CODE_MAKER_ACTION_SWIPE,
	APPIUM_CODE_MAKER_ACTION_TAP


} AppiumCodeMakerActionType;

typedef void(^AppiumCodeMakerActionBlock)(void);

@interface AppiumCodeMakerAction : NSObject

@property AppiumCodeMakerActionType actionType;
@property NSArray *params;
@property (copy) AppiumCodeMakerActionBlock block;

-(id) initWithActionType:(AppiumCodeMakerActionType)actionType params:(NSArray*)params block:(AppiumCodeMakerActionBlock)block;

@end
