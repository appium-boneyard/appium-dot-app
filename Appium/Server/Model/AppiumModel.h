//
//  AppiumModel.h
//  Appium
//
//  Created by Dan Cuellar on 3/12/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppiumAndroidSettingsModel.h"
#import "AppiumiOSSettingsModel.h"
#import "SocketIO.h"

typedef enum platformTypes
{
	Platform_iOS,
	Platform_Android
} Platform;

@class SocketIO;

@interface AppiumModel : NSObject<SocketIODelegate>

@property NSTask *serverTask;

@property AppiumAndroidSettingsModel *android;
@property AppiumiOSSettingsModel *iOS;

@property BOOL breakOnNodeApplicationStart;
@property BOOL checkForUpdates;
@property NSNumber *commandTimeout;
@property NSString *customFlags;
@property BOOL developerMode;
@property SocketIO *doctorSocket;
@property BOOL doctorSocketIsConnected;
@property NSString *externalAppiumPackagePath;
@property NSString *externalNodeJSBinaryPath;
@property BOOL isAndroid;
@property BOOL isIOS;
@property BOOL isServerRunning;
@property BOOL isServerListening;
@property BOOL killProcessesUsingPort;
@property BOOL logColors;
@property NSString *logFile;
@property BOOL logTimestamps;
@property NSString *logWebHook;
@property NSNumber *newCommandTimeout;
@property NSNumber *nodeJSDebugPort;
@property BOOL overrideExistingSessions;
@property Platform platform;
@property BOOL prelaunchApp;
@property NSString *robotAddress;
@property NSNumber *robotPort;
@property NSString *seleniumGridConfigFile;
@property NSString *serverAddress;
@property NSNumber *serverPort;
@property BOOL useCustomFlags;
@property BOOL useExternalAppiumPackage;
@property BOOL useExternalNodeJSBinary;
@property BOOL useLogFile;
@property BOOL useLogWebHook;
@property BOOL useNewCommandTimeout;
@property BOOL useNodeDebugging;
@property BOOL useQuietLogging;
@property BOOL useRemoteServer;
@property BOOL useRobot;
@property BOOL useSeleniumGridConfigFile;

-(BOOL) killServer;
-(BOOL) startServer;
-(BOOL) startDoctor;

@end
