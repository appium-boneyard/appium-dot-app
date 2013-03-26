//
//  AppiumAppleScriptSupport.h
//  Appium
//
//  Created by Dan Cuellar on 3/4/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "AppiumModel.h"

@interface NSApplication (AppiumAppleScriptSupport)

#pragma mark - Properties

@property NSString *s_AndroidActivity;
@property NSString *s_AndroidPackage;
@property NSString *s_AppPath;
@property NSString *s_BundleID;
@property NSNumber *s_CheckForUpdates;
@property NSString *s_IPAddress;
@property (readonly) NSNumber *s_IsServerRunning;
@property NSNumber *s_KeepArtifacts;
@property (readonly)NSString *s_LogText;
@property (readonly)NSString *s_NodePath;
@property NSNumber *s_Port;
@property NSNumber *s_PrelaunchApp;
@property NSNumber *s_ResetApplicationState;
@property NSString *s_UDID;
@property NSNumber *s_UseAndroidActivity;
@property NSNumber *s_UseAndroidPackage;
@property NSNumber *s_UseAppPath;
@property NSNumber *s_UseBundleID;
@property NSNumber *s_UseInstrumentsWithoutDelay;
@property NSNumber *s_UseMobileSafari;
@property NSNumber *s_UseUDID;
@property NSNumber *s_UseWarp;

#pragma mark - Functions
-(void) s_ClearLog: (NSScriptCommand*)command;
-(void) s_ForceiOSDevice:(NSScriptCommand*)command;
-(NSNumber*) s_StartServer: (NSScriptCommand*)command;
-(NSNumber*) s_StopServer: (NSScriptCommand*)command;
-(void) s_UsePlatform: (NSScriptCommand*)command;

@end
