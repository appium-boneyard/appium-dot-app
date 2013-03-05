//
//  AppiumAppleScriptSupport.h
//  Appium
//
//  Created by Dan Cuellar on 3/4/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface NSApplication (AppiumAppleScriptSupport)

@property (readonly) NSNumber *s_IsServerRunning;
@property NSString *s_IPAddress;
@property NSNumber *s_Port;

@end
