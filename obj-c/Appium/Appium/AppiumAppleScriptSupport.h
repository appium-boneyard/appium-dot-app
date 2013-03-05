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
@property NSString *s_AppPath;
@property NSNumber *s_UseAppPath;
@property (readonly)NSString *s_LogText;

- (NSNumber*) s_StartServer: (NSScriptCommand*)command;
- (NSNumber*) s_StopServer: (NSScriptCommand*)command;
@end
