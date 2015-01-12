//
//  AppiumAppleScriptSupport.h
//  Appium
//
//  Created by Dan Cuellar on 3/4/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "AppiumModel.h"
#import "AppiumInspectorWindowController.h"

@class AppiumModel;
@class AppiumInspectorWindowController;

@interface NSApplication (AppiumAppleScriptSupport)

#pragma mark - Properties
@property (readonly) AppiumAndroidSettingsModel *s_Android;
@property (readonly) AppiumDeveloperSettingsModel *s_Developer;
@property (readonly) AppiumGeneralSettingsModel *s_General;
@property (readonly) AppiumiOSSettingsModel *s_iOS;
@property (readonly) AppiumRobotSettingsModel *s_Robot;

@property (readonly) AppiumInspectorWindowController* s_InspectorWindow;
@property (readonly) NSString *s_LogText;
@property (readonly) NSString *s_Platform;
@property (readonly) BOOL s_IsServerRunning;
@property (readonly) BOOL s_IsServerListening;

#pragma mark - Methods
-(void) s_AddEnvironmentVariable: (NSScriptCommand*)command;
-(void) s_ClearEnvironmentVariables: (NSScriptCommand*)command;
-(void) s_ClearLog: (NSScriptCommand*)command;
-(NSNumber*) s_StartServer: (NSScriptCommand*)command;
-(NSNumber*) s_StopServer: (NSScriptCommand*)command;
-(void) s_UsePlatform: (NSScriptCommand*)command;
-(void) s_ResetPreferences: (NSScriptCommand*)command;

@end
