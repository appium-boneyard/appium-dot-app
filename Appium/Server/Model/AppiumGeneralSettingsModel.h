//
//  AppiumGeneralSettingsModel.h
//  Appium
//
//  Created by Dan Cuellar on 5/13/14.
//  Copyright (c) 2014 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppiumGeneralSettingsModel : NSObject

@property NSString *callbackAddress;
@property NSNumber *callbackPort;
@property BOOL checkForUpdates;
@property NSNumber *commandTimeout;
@property NSString *environmentVariables;
@property BOOL killProcessesUsingPort;
@property BOOL logColors;
@property NSString *logFile;
@property BOOL logTimestamps;
@property NSString *logWebHook;
@property BOOL forceScrollLog;
@property NSNumber *maxLogLength;
@property BOOL overrideExistingSessions;
@property BOOL prelaunchApp;
@property NSString *seleniumGridConfigFile;
@property NSString *serverAddress;
@property NSNumber *serverPort;
@property BOOL useLogFile;
@property BOOL useLogWebHook;
@property BOOL useCommandTimeout;
@property BOOL useQuietLogging;
@property BOOL useRemoteServer;
@property BOOL useSeleniumGridConfigFile;
@property BOOL useLocalTimezone;
@property BOOL useCallbackAddress;
@property BOOL useCallbackPort;

@end
