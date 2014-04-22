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
@property NSString *s_AndroidAppPath;
@property NSString *s_AndroidAutomationName;
@property NSNumber *s_AndroidBootstrapPort;
@property NSString *s_AndroidCoverageClass;
@property NSNumber *s_AndroidDeviceReadyTimeout;
@property NSString *s_AndroidKeyAlias;
@property NSString *s_AndroidKeyPassword;
@property NSString *s_AndroidKeystorePassword;
@property NSString *s_AndroidKeystorePath;
@property NSString *s_AndroidPackage;
@property NSString *s_AndroidPlatformName;
@property NSString *s_AndroidPlatformVersion;
@property NSString *s_AndroidWaitActivity;
@property NSString *s_AndroidWaitPackage;
@property NSString *s_AVD;
@property NSString *s_AVDArguments;
@property NSNumber *s_BackendRetries;
@property NSNumber *s_BreakOnNodeAppStart;
@property NSString *s_BundleID;
@property NSNumber *s_CheckForUpdates;
@property NSString *s_CustomAndroidSDKPath;
@property NSString *s_CustomTraceTemplatePath;
@property NSString *s_CustomFlags;
@property NSNumber *s_DeveloperMode;
@property NSString *s_ExternalAppiumPackagePath;
@property NSString *s_ExternalNodeJSBinaryPath;
@property NSNumber *s_ForceKillInstruments;
@property NSString *s_Language;
@property NSString *s_Locale;
@property NSNumber *s_InstrumentsLaunchTimeout;
@property NSString *s_iOSAppPath;
@property NSString *s_iOSPlatformVersion;
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
@property NSNumber *s_ShowiOSSimulatorLog;
@property NSString *s_UDID;
@property NSNumber *s_UseAndroidActivity;
@property NSNumber *s_UseAndroidBootstrapPort;
@property NSNumber *s_UseAndroidBrowser;
@property NSNumber *s_UseAndroidCoverageClass;
@property NSNumber *s_UseAndroidDeviceReadyTimeout;
@property NSNumber *s_UseAndroidFullReset;
@property NSNumber *s_UseAndroidKeystore;
@property NSNumber *s_UseAndroidNoReset;
@property NSNumber *s_UseAndroidPackage;
@property NSNumber *s_UseAndroidWaitActivity;
@property NSNumber *s_UseAppPath;
@property NSNumber *s_UseAVD;
@property NSNumber *s_UseAVDArguments;
@property NSNumber *s_UseBackendRetries;
@property NSNumber *s_UseBundleID;
@property NSNumber *s_UseCustomAndroidSDKPath;
@property NSNumber *s_UseCustomTraceTemplatePath;
@property NSNumber *s_UseCustomFlags;
@property NSNumber *s_UseCustomSelendroidPort;
@property NSNumber *s_UseExternalAppiumPackage;
@property NSNumber *s_UseExternalNodeJSBinary;
@property NSNumber *s_UseInstrumentsLaunchTimeout;
@property NSNumber *s_UseiOSFullReset;
@property NSNumber *s_UseiOSNoReset;
@property NSNumber *s_UseLanguage;
@property NSNumber *s_UseLocale;
@property NSNumber *s_UseLogColors;
@property NSNumber *s_UseLogFile;
@property NSNumber *s_UseLogTimestamps;
@property NSNumber *s_UseLogWebhook;
@property NSNumber *s_UseMobileSafari;
@property NSNumber *s_UseNativeInstrumentsLibrary;
@property NSNumber *s_UseNodeDebugger;
@property NSNumber *s_UseQuietLogging;
@property NSNumber *s_UseRemoteServer;
@property NSNumber *s_UseRobot;
@property NSNumber *s_UseSeleniumGridConfigFile;
@property NSNumber *s_UseUDID;
@property NSString *s_XcodePath;

@property (readonly) AppiumInspectorWindowController* s_InspectorWindow;

#pragma mark - Methods
-(void) s_ClearLog: (NSScriptCommand*)command;
-(void) s_ForceiOSDevice:(NSScriptCommand*)command;
-(void) s_ForceiOSOrientation:(NSScriptCommand*)command;
-(NSNumber*) s_StartServer: (NSScriptCommand*)command;
-(NSNumber*) s_StopServer: (NSScriptCommand*)command;
-(void) s_UsePlatform: (NSScriptCommand*)command;

@end
