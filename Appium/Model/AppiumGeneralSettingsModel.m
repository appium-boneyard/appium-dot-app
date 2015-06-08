//
//  AppiumGeneralSettingsModel.m
//  Appium
//
//  Created by Dan Cuellar on 5/13/14.
//  Copyright (c) 2014 Appium. All rights reserved.
//

#import "AppiumGeneralSettingsModel.h"
#import "AppiumPreferencesFile.h"
#import "AppiumAppDelegate.h"
#import "AppiumModel.h"

@class AppiumAppDelegate;
@class AppiumModel;

@implementation AppiumGeneralSettingsModel

-(NSScriptObjectSpecifier*) objectSpecifier
{
	NSScriptClassDescription *containerClassDesc = (NSScriptClassDescription *)
    [NSScriptClassDescription classDescriptionForClass:[NSApp class]];
	return [[NSNameSpecifier alloc]
			initWithContainerClassDescription:containerClassDesc
			containerSpecifier:nil key:@"general"
			name:@"general settings"];
}

-(NSArray*)allLogLevels {
	return @[@"default",@"debug"];
}

-(BOOL) bypassPermissionsCheck { return [DEFAULTS boolForKey:APPIUM_PLIST_BYPASS_PERMISSIONS_CHECKS]; }
-(void) setBypassPermissionsCheck:(BOOL)bypassPermissionsCheck { [DEFAULTS setBool:bypassPermissionsCheck forKey:APPIUM_PLIST_BYPASS_PERMISSIONS_CHECKS]; }

-(NSString*) callbackAddress { return [DEFAULTS stringForKey:APPIUM_PLIST_CALLBACK_ADDRESS]; }
-(void) setCallbackAddress:(NSString *)callbackAddress { [DEFAULTS setValue:callbackAddress forKey:APPIUM_PLIST_CALLBACK_ADDRESS]; }

-(NSNumber*) callbackPort { return [NSNumber numberWithInt:[[DEFAULTS stringForKey:APPIUM_PLIST_CALLBACK_PORT] intValue]]; }
-(void) setCallbackPort:(NSNumber *)callbackPort { [[NSUserDefaults standardUserDefaults] setValue:callbackPort forKey:APPIUM_PLIST_CALLBACK_PORT]; }

-(BOOL) checkForUpdates { return [DEFAULTS boolForKey:APPIUM_PLIST_CHECK_FOR_UPDATES]; }
-(void) setCheckForUpdates:(BOOL)checkForUpdates { [DEFAULTS setBool:checkForUpdates forKey:APPIUM_PLIST_CHECK_FOR_UPDATES]; }

-(NSNumber*) commandTimeout { return [NSNumber numberWithInt:[[DEFAULTS stringForKey:APPIUM_PLIST_NEW_COMMAND_TIMEOUT] intValue]]; }
-(void) setCommandTimeout:(NSNumber *)commandTimeout { [[NSUserDefaults standardUserDefaults] setValue:commandTimeout forKey:APPIUM_PLIST_NEW_COMMAND_TIMEOUT]; }

-(NSArray*) environmentVariables {
	NSArray *envArray = [DEFAULTS arrayForKey:APPIUM_PLIST_ENVIRONMENT_VARIABLES];
	if (envArray == nil) {
		[self setEnvironmentVariables:@[]];
		return [DEFAULTS arrayForKey:APPIUM_PLIST_ENVIRONMENT_VARIABLES];
	} else {
		return envArray;
	}
}
-(void) setEnvironmentVariables:(NSArray *)environmentVariables { [DEFAULTS setValue:environmentVariables forKey:APPIUM_PLIST_ENVIRONMENT_VARIABLES]; }

-(BOOL) killProcessesUsingPort { return [DEFAULTS boolForKey:APPIUM_PLIST_KILL_PROCESSES_USING_PORT]; }
-(void) setKillProcessesUsingPort:(BOOL)killProcessesUsingPort { [DEFAULTS setBool:killProcessesUsingPort forKey:APPIUM_PLIST_KILL_PROCESSES_USING_PORT];}

-(BOOL) logColors { return [DEFAULTS boolForKey:APPIUM_PLIST_LOG_COLORS]; }
-(void) setLogColors:(BOOL)logColors { [DEFAULTS setBool:logColors forKey:APPIUM_PLIST_LOG_COLORS]; }

-(NSString*) logFile { return [DEFAULTS stringForKey:APPIUM_PLIST_LOG_FILE]; }
-(void) setLogFile:(NSString *)logFile { [DEFAULTS setValue:logFile forKey:APPIUM_PLIST_LOG_FILE]; }

-(NSString*) logLevel { return [DEFAULTS stringForKey:APPIUM_PLIST_LOG_LEVEL]; }
-(void) setLogLevel:(NSString *)logLevel { [DEFAULTS setValue:logLevel forKey:APPIUM_PLIST_LOG_LEVEL]; }

-(BOOL) logTimestamps { return [DEFAULTS boolForKey:APPIUM_PLIST_LOG_TIMESTAMPS]; }
-(void) setLogTimestamps:(BOOL)logTimestamps { [DEFAULTS setBool:logTimestamps forKey:APPIUM_PLIST_LOG_TIMESTAMPS]; }

-(NSString*) logWebHook { return [DEFAULTS stringForKey:APPIUM_PLIST_LOG_WEBHOOK]; }
-(void) setLogWebHook:(NSString *)logWebHook { [DEFAULTS setValue:logWebHook forKey:APPIUM_PLIST_LOG_WEBHOOK]; }

-(BOOL) forceScrollLog { return [DEFAULTS boolForKey:APPIUM_PLIST_LOG_FORCE_SCROLL]; }
-(void) setForceScrollLog:(BOOL)forceScrollLog { [DEFAULTS setBool:forceScrollLog forKey:APPIUM_PLIST_LOG_FORCE_SCROLL]; }

- (NSNumber *)maxLogLength { return [NSNumber numberWithInteger:[DEFAULTS integerForKey:APPIUM_PLIST_MAXIMUM_LOG_LENGTH]]; }
- (void)setMaxLogLength:(NSNumber *)maxLogLength { [DEFAULTS setInteger:[maxLogLength integerValue] forKey:APPIUM_PLIST_MAXIMUM_LOG_LENGTH]; }

-(BOOL) overrideExistingSessions { return [DEFAULTS boolForKey:APPIUM_PLIST_OVERRIDE_EXISTING_SESSIONS]; }
-(void) setOverrideExistingSessions:(BOOL)overrideExistingSessions { [DEFAULTS setBool:overrideExistingSessions forKey:APPIUM_PLIST_OVERRIDE_EXISTING_SESSIONS]; }

-(BOOL) prelaunchApp { return [DEFAULTS boolForKey:APPIUM_PLIST_PRELAUNCH_APPLICATION]; }
-(void) setPrelaunchApp:(BOOL)preLaunchApp { [DEFAULTS setBool:preLaunchApp forKey:APPIUM_PLIST_PRELAUNCH_APPLICATION]; }

-(NSString*) seleniumGridConfigFile { return [DEFAULTS stringForKey:APPIUM_PLIST_SELENIUM_GRID_CONFIG_FILE]; }
-(void) setSeleniumGridConfigFile:(NSString *)seleniumGridConfigFile { [DEFAULTS setValue:seleniumGridConfigFile forKey:APPIUM_PLIST_SELENIUM_GRID_CONFIG_FILE]; }

-(NSString*) serverAddress { return [DEFAULTS stringForKey:APPIUM_PLIST_SERVER_ADDRESS]; }
-(void) setServerAddress:(NSString *)serverAddress { [DEFAULTS setValue:serverAddress forKey:APPIUM_PLIST_SERVER_ADDRESS]; }

-(NSNumber*) serverPort { return [NSNumber numberWithInt:[[DEFAULTS stringForKey:APPIUM_PLIST_SERVER_PORT] intValue]]; }
-(void) setServerPort:(NSNumber *)serverPort { [[NSUserDefaults standardUserDefaults] setValue:serverPort forKey:APPIUM_PLIST_SERVER_PORT]; }

-(NSString*) tempFolderPath { return [DEFAULTS stringForKey:APPIUM_PLIST_TEMP_FOLDER_PATH]; }
-(void) setTempFolderPath:(NSString *)tempFolderPath { [DEFAULTS setValue:tempFolderPath forKey:APPIUM_PLIST_TEMP_FOLDER_PATH]; }

-(BOOL) useAdditionalLogSpacing { return [DEFAULTS boolForKey:APPIUM_PLIST_USE_ADDITIONAL_LOG_SPACING]; }
-(void) setUseAdditionalLogSpacing:(BOOL)useAdditionalLogSpacing { [DEFAULTS setBool:useAdditionalLogSpacing forKey:APPIUM_PLIST_USE_ADDITIONAL_LOG_SPACING]; }

-(BOOL) useCallbackAddress { return [DEFAULTS boolForKey:APPIUM_PLIST_USE_CALLBACK_ADDRESS]; }
-(void) setUseCallbackAddress:(BOOL)useCallbackAddress { [DEFAULTS setBool:useCallbackAddress forKey:APPIUM_PLIST_USE_CALLBACK_ADDRESS]; }

-(BOOL) useCallbackPort { return [DEFAULTS boolForKey:APPIUM_PLIST_USE_CALLBACK_PORT]; }
-(void) setUseCallbackPort:(BOOL)useCallbackPort { [DEFAULTS setBool:useCallbackPort forKey:APPIUM_PLIST_USE_CALLBACK_PORT]; }

-(BOOL) useCommandTimeout { return [DEFAULTS boolForKey:APPIUM_PLIST_USE_NEW_COMMAND_TIMEOUT]; }
-(void) setUseCommandTimeout:(BOOL)useCommandTimeout { [DEFAULTS setBool:useCommandTimeout forKey:APPIUM_PLIST_USE_NEW_COMMAND_TIMEOUT]; }

-(BOOL) useLocalTimezone { return [DEFAULTS boolForKey:APPIUM_PLIST_USE_LOCAL_TIMEZONE]; }
-(void) setUseLocalTimezone:(BOOL)useLocalTimezone { [DEFAULTS setBool:useLocalTimezone forKey:APPIUM_PLIST_USE_LOCAL_TIMEZONE]; }

-(BOOL) useLogFile { return [DEFAULTS boolForKey:APPIUM_PLIST_USE_LOG_FILE]; }
-(void) setUseLogFile:(BOOL)useLogFile { [DEFAULTS setBool:useLogFile forKey:APPIUM_PLIST_USE_LOG_FILE]; }

-(BOOL) useLogWebHook { return [DEFAULTS boolForKey:APPIUM_PLIST_USE_LOG_WEBHOOK]; }
-(void) setUseLogWebHook:(BOOL)useLogWebHook { [DEFAULTS setBool:useLogWebHook forKey:APPIUM_PLIST_USE_LOG_WEBHOOK]; }

-(BOOL) useRemoteServer { return [DEFAULTS boolForKey:APPIUM_PLIST_USE_REMOTE_SERVER]; }
-(void) setUseRemoteServer:(BOOL)useRemoteServer
{
	[DEFAULTS setBool:useRemoteServer forKey:APPIUM_PLIST_USE_REMOTE_SERVER];
	if (useRemoteServer)
	{
		[((AppiumModel*)((AppiumAppDelegate*)[NSApplication sharedApplication].delegate).model) killServer];
	}
	[((AppiumModel*)((AppiumAppDelegate*)[NSApplication sharedApplication].delegate).model) setIsServerListening:useRemoteServer];
}

-(BOOL) useSeleniumGridConfigFile { return [DEFAULTS boolForKey:APPIUM_PLIST_USE_SELENIUM_GRID_CONFIG_FILE]; }
-(void) setUseSeleniumGridConfigFile:(BOOL)useSeleniumGridConfigFile { [DEFAULTS setBool:useSeleniumGridConfigFile forKey:APPIUM_PLIST_USE_SELENIUM_GRID_CONFIG_FILE]; }

-(BOOL) useStrictCapabilities { return [DEFAULTS boolForKey:APPIUM_PLIST_USE_STRICT_CAPABILITIES]; }
-(void) setUseStrictCapabilities:(BOOL)useStrictCapabilities { [DEFAULTS setBool:useStrictCapabilities forKey:APPIUM_PLIST_USE_STRICT_CAPABILITIES]; }

@end
