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
	APPIUM_CODE_MAKER_ACTION_COMMENT,
	APPIUM_CODE_MAKER_ACTION_TAP,
	APPIUM_CODE_MAKER_ACTION_SEND_KEYS

} AppiumCodeMakerActionType;

@interface AppiumCodeMakerAction : NSObject

@property AppiumCodeMakerActionType actionType;
@property NSArray *params;

-(id) initWithActionType:(AppiumCodeMakerActionType)actionType params:(NSArray*)params;

@end
