//
//  AppiumPreferencesWindowController.h
//  Appium
//
//  Created by Dan Cuellar on 3/12/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppiumModel.h"

@interface AppiumPreferencesWindowController : NSWindowController

@property (readonly) AppiumModel *model;

@end
