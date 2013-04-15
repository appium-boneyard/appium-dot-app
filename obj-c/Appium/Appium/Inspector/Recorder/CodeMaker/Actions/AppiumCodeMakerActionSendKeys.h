//
//  AppiumCodeMakerSendKeysAction.h
//  Appium
//
//  Created by Dan Cuellar on 4/14/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerAction.h"
#import "AppiumCodeMakerLocator.h"

@class AppiumCodeMakerAction;
@class AppiumCodeMakerLocator;

@interface AppiumCodeMakerActionSendKeys : AppiumCodeMakerAction

-(id) initWithLocator:(AppiumCodeMakerLocator*)locator keys:(NSString*)keys;

@property (readonly) AppiumCodeMakerLocator* locator;
@property (readonly) NSString* keys;

@end
