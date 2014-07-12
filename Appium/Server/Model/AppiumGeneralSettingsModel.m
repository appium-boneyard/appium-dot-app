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

-(BOOL) checkForUpdates { return [DEFAULTS boolForKey:APPIUM_PLIST_CHECK_FOR_UPDATES]; }
-(void) setCheckForUpdates:(BOOL)checkForUpdates { [DEFAULTS setBool:checkForUpdates forKey:APPIUM_PLIST_CHECK_FOR_UPDATES]; }

-(NSNumber*) commandTimeout { return [NSNumber numberWithInt:[[DEFAULTS stringForKey:APPIUM_PLIST_NEW_COMMAND_TIMEOUT] intValue]]; }
-(void) setCommandTimeout:(NSNumber *)commandTimeout { [[NSUserDefaults standardUserDefaults] setValue:commandTimeout forKey:APPIUM_PLIST_NEW_COMMAND_TIMEOUT]; }

-(BOOL) killProcessesUsingPort { return [DEFAULTS boolForKey:APPIUM_PLIST_KILL_PROCESSES_USING_PORT]; }
-(void) setKillProcessesUsingPort:(BOOL)killProcessesUsingPort { [DEFAULTS setBool:killProcessesUsingPort forKey:APPIUM_PLIST_KILL_PROCESSES_USING_PORT];}

-(BOOL) logColors { return [DEFAULTS boolForKey:APPIUM_PLIST_LOG_COLORS]; }
-(void) setLogColors:(BOOL)logColors { [DEFAULTS setBool:logColors forKey:APPIUM_PLIST_LOG_COLORS]; }

-(NSString*) logFile { return [DEFAULTS stringForKey:APPIUM_PLIST_LOG_FILE]; }
-(void) setLogFile:(NSString *)logFile { [DEFAULTS setValue:logFile forKey:APPIUM_PLIST_LOG_FILE]; }

-(BOOL) logTimestamps { return [DEFAULTS boolForKey:APPIUM_PLIST_LOG_TIMESTAMPS]; }
-(void) setLogTimestamps:(BOOL)logTimestamps { [DEFAULTS setBool:logTimestamps forKey:APPIUM_PLIST_LOG_TIMESTAMPS]; }

-(NSString*) logWebHook { return [DEFAULTS stringForKey:APPIUM_PLIST_LOG_WEBHOOK]; }
-(void) setLogWebHook:(NSString *)logWebHook { [DEFAULTS setValue:logWebHook forKey:APPIUM_PLIST_LOG_WEBHOOK]; }

-(BOOL) forceScrollLog { return [DEFAULTS boolForKey:APPIUM_PLIST_LOG_FORCE_SCROLL]; }
-(void) setForceScrollLog:(BOOL)forceScrollLog { [DEFAULTS setBool:forceScrollLog forKey:APPIUM_PLIST_LOG_FORCE_SCROLL]; }

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

-(BOOL) useCommandTimeout { return [DEFAULTS boolForKey:APPIUM_PLIST_USE_NEW_COMMAND_TIMEOUT]; }
-(void) setUseCommandTimeout:(BOOL)useCommandTimeout { [DEFAULTS setBool:useCommandTimeout forKey:APPIUM_PLIST_USE_NEW_COMMAND_TIMEOUT]; }

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

-(BOOL) useQuietLogging { return [DEFAULTS boolForKey:APPIUM_PLIST_USE_QUIET_LOGGING]; }
-(void) setUseQuietLogging:(BOOL)useQuietLogging { [DEFAULTS setBool:useQuietLogging forKey:APPIUM_PLIST_USE_QUIET_LOGGING]; }

-(BOOL) useSeleniumGridConfigFile { return [DEFAULTS boolForKey:APPIUM_PLIST_USE_SELENIUM_GRID_CONFIG_FILE]; }
-(void) setUseSeleniumGridConfigFile:(BOOL)useSeleniumGridConfigFile { [DEFAULTS setBool:useSeleniumGridConfigFile forKey:APPIUM_PLIST_USE_SELENIUM_GRID_CONFIG_FILE]; }

-(BOOL) useLocalTimezone { return [DEFAULTS boolForKey:APPIUM_PLIST_USE_LOCAL_TIMEZONE]; }
-(void) setUseLocalTimezone:(BOOL)useLocalTimezone { [DEFAULTS setBool:useLocalTimezone forKey:APPIUM_PLIST_USE_LOCAL_TIMEZONE]; }

@end
