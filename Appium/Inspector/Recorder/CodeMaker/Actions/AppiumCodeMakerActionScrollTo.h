//
//  AppiumCodeMakerActionScrollTo.h
//  Appium
//
//  Created by Dan Cuellar on 5/12/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerAction.h"
#import "AppiumCodeMakerLocator.h"

@class AppiumCodeMakerAction;
@class AppiumCodeMakerLocator;

@interface AppiumCodeMakerActionScrollTo : AppiumCodeMakerAction

-(id) initWithLocator:(AppiumCodeMakerLocator*)locator;

@property (readonly) AppiumCodeMakerLocator* locator;

@end
