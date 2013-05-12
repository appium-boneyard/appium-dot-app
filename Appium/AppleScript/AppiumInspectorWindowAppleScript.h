//
//  AppiumInspectorWindowAppleScript.h
//  Appium
//
//  Created by Dan Cuellar on 5/10/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumInspectorWindowController.h"

@class AppiumInspectorWindowController;

@interface AppiumInspectorWindowController (AppleScriptSupport)

@property (readonly) NSString *s_Details;

@end
