//
//  AppiumGeneralSettingsModel.h
//  Appium
//
//  Created by Dan Cuellar on 5/13/14.
//  Copyright (c) 2014 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppiumGeneralSettingsModel : NSObject

@property (readonly) NSArray* allLogLevels;
@property BOOL bypassPermissionsCheck;
@property NSString *callbackAddress;
@property NSNumber *callbackPort;
@property BOOL checkForUpdates;
@property NSNumber *commandTimeout;
@property NSArray *environmentVariables;
@property BOOL killProcessesUsingPort;
@property BOOL logColors;
@property NSString *logFile;
@property NSString *logLevel;
@property BOOL logTimestamps;
@property NSString *logWebHook;
@property BOOL forceScrollLog;
@property NSNumber *maxLogLength;
@property BOOL overrideExistingSessions;
@property BOOL prelaunchApp;
@property NSString *seleniumGridConfigFile;
@property NSString *serverAddress;
@property NSNumber *serverPort;
@property NSString *tempFolderPath;
@property BOOL useAdditionalLogSpacing;
@property BOOL useCallbackAddress;
@property BOOL useCallbackPort;
@property BOOL useLocalTimezone;
@property BOOL useLogFile;
@property BOOL useLogWebHook;
@property BOOL useCommandTimeout;
@property BOOL useRemoteServer;
@property BOOL useStrictCapabilities;
@property BOOL useSeleniumGridConfigFile;
@property BOOL useTempFolderPath;

@end
