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
@property NSString *s_AndroidActivity;
@property NSNumber *s_AndroidDeviceReadyTimeout;
@property NSString *s_AndroidKeyAlias;
@property NSString *s_AndroidKeyPassword;
@property NSString *s_AndroidKeystorePassword;
@property NSString *s_AndroidKeystorePath;
@property NSString *s_AndroidPackage;
@property NSString *s_AndroidWaitActivity;
@property NSString *s_AppPath;
@property NSString *s_AVD;
@property NSNumber *s_BreakOnNodeAppStart;
@property NSString *s_BundleID;
@property NSNumber *s_CheckForUpdates;
@property NSString *s_CustomAndroidSDKPath;
@property NSNumber *s_DeveloperMode;
@property NSString *s_ExternalAppiumPackagePath;
@property NSString *s_ExternalNodeJSBinaryPath;
@property NSString *s_IPAddress;
@property (readonly) NSNumber *s_IsServerListening;
@property (readonly) NSNumber *s_IsServerRunning;
@property NSNumber *s_KeepArtifacts;
@property NSNumber *s_KillProcessesUsingPort;
@property NSString *s_LogFile;
@property (readonly)NSString *s_LogText;
@property NSString *s_LogWebhook;
@property NSNumber *s_NodeDebugPort;
@property (readonly)NSString *s_NodePath;
@property NSNumber *s_OverrideExistingSessions;
@property NSString *s_RobotAddress;
@property NSNumber *s_RobotPort;
@property NSNumber *s_SelendroidPort;
@property NSString *s_SeleniumGridConfigFile;
@property NSNumber *s_Port;
@property NSNumber *s_PrelaunchApp;
@property NSNumber *s_ResetApplicationState;
@property NSString *s_UDID;
@property NSNumber *s_UseAndroidActivity;
@property NSNumber *s_UseAndroidDeviceReadyTimeout;
@property NSNumber *s_UseAndroidFullReset;
@property NSNumber *s_UseAndroidKeystore;
@property NSNumber *s_UseAndroidPackage;
@property NSNumber *s_UseAndroidWaitActivity;
@property NSNumber *s_UseAppPath;
@property NSNumber *s_UseAVD;
@property NSNumber *s_UseBundleID;
@property NSNumber *s_UseCustomAndroidSDKPath;
@property NSNumber *s_UseCustomSelendroidPort;
@property NSNumber *s_UseExternalAppiumPackage;
@property NSNumber *s_UseExternalNodeJSBinary;
@property NSNumber *s_UseLogFile;
@property NSNumber *s_UseLogWebhook;
@property NSNumber *s_UseMobileSafari;
@property NSNumber *s_UseNativeInstrumentsLibrary;
@property NSNumber *s_UseNodeDebugger;
@property NSNumber *s_UseQuietLogging;
@property NSNumber *s_UseRemoteServer;
@property NSNumber *s_UseRobot;
@property NSNumber *s_UseSeleniumGridConfigFile;
@property NSNumber *s_UseUDID;

@property (readonly) AppiumInspectorWindowController* s_InspectorWindow;

#pragma mark - Methods
-(void) s_ClearLog: (NSScriptCommand*)command;
-(void) s_ForceiOSDevice:(NSScriptCommand*)command;
-(void) s_ForceiOSOrientation:(NSScriptCommand*)command;
-(NSNumber*) s_StartServer: (NSScriptCommand*)command;
-(NSNumber*) s_StopServer: (NSScriptCommand*)command;
-(void) s_UsePlatform: (NSScriptCommand*)command;

@end
