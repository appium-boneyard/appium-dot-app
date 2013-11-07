//
//  AppiumModel.m
//  Appium
//
//  Created by Dan Cuellar on 3/12/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumModel.h"

#import <Foundation/Foundation.h>
#import "AppiumAppDelegate.h"
#import "AppiumPreferencesFile.h"
#import "NSString+trimLeadingWhitespace.h"
#import "Utility.h"

#pragma  mark - Model

NSUserDefaults* _defaults;
BOOL _isServerRunning;
BOOL _isServerListening;

@implementation AppiumModel

- (id)init
{
    self = [super init];
    if (self) {

		// initialize settings
		NSString *filePath = [[NSBundle mainBundle] pathForResource:@"defaults" ofType:@"plist"];
		NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
		[[NSUserDefaults standardUserDefaults] registerDefaults:settingsDict];
		[[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:settingsDict];
		_defaults = [NSUserDefaults standardUserDefaults];

		// initialize members
		_isServerRunning = NO;
		_isServerListening = [self useRemoteServer];
		[self setAvailableAVDs:[NSArray new]];
        [self setAvailableActivities:[NSArray new]];

		// update keystore path to match current user
		if ([self.androidKeystorePath hasPrefix:@"/Users/me/"])
        {
			[self setAndroidKeystorePath:[self.androidKeystorePath stringByReplacingOccurrencesOfString:@"/Users/me" withString:NSHomeDirectory()]];
		}

        // asynchronous initilizations
        [self performSelectorInBackground:@selector(refreshAVDs) withObject:nil];
    }
    return self;
}

#pragma mark - Properties

-(NSString*) androidActivity { return [_defaults stringForKey:APPIUM_PLIST_ANDROID_ACTIVITY]; }
-(void) setAndroidActivity:(NSString *)androidActivity { [_defaults setValue:androidActivity forKey:APPIUM_PLIST_ANDROID_ACTIVITY]; }

-(NSNumber*) androidDeviceReadyTimeout { return [NSNumber numberWithInt:[[_defaults stringForKey:APPIUM_PLIST_ANDROID_DEVICE_READY_TIMEOUT] intValue]]; }
-(void) setAndroidDeviceReadyTimeout:(NSNumber *)androidDeviceReadyTimeout { [[NSUserDefaults standardUserDefaults] setValue:androidDeviceReadyTimeout forKey:APPIUM_PLIST_ANDROID_DEVICE_READY_TIMEOUT]; }

-(BOOL) androidFullReset { return [_defaults boolForKey:APPIUM_PLIST_ANDROID_FULL_RESET]; }
-(void) setAndroidFullReset:(BOOL)fastReset { [_defaults setBool:fastReset forKey:APPIUM_PLIST_ANDROID_FULL_RESET]; }

-(NSString*) androidKeyAlias { return [_defaults stringForKey:APPIUM_PLIST_ANDROID_KEY_ALIAS]; }
-(void) setAndroidKeyAlias:(NSString *)androidKeyAlias { [_defaults setValue:androidKeyAlias forKey:APPIUM_PLIST_ANDROID_KEY_ALIAS]; }

-(NSString*) androidKeyPassword { return [_defaults stringForKey:APPIUM_PLIST_ANDROID_KEY_PASSWORD]; }
-(void) setAndroidKeyPassword:(NSString *)androidKeyPassword { [_defaults setValue:androidKeyPassword forKey:APPIUM_PLIST_ANDROID_KEY_PASSWORD]; }

-(NSString*) androidKeystorePassword { return [_defaults stringForKey:APPIUM_PLIST_ANDROID_KEYSTORE_PASSWORD]; }
-(void) setAndroidKeystorePassword:(NSString *)androidKeystorePassword { [_defaults setValue:androidKeystorePassword forKey:APPIUM_PLIST_ANDROID_KEYSTORE_PASSWORD]; }

-(NSString*) androidKeystorePath { return [_defaults stringForKey:APPIUM_PLIST_ANDROID_KEYSTORE_PATH]; }
-(void) setAndroidKeystorePath:(NSString *)androidKeystorePath { [_defaults setValue:androidKeystorePath forKey:APPIUM_PLIST_ANDROID_KEYSTORE_PATH]; }

-(NSString*) androidPackage { return [_defaults stringForKey:APPIUM_PLIST_ANDROID_PACKAGE]; }
-(void) setAndroidPackage:(NSString *)androidPackage { [_defaults setValue:androidPackage forKey:APPIUM_PLIST_ANDROID_PACKAGE]; }

-(NSString*) androidWaitActivity { return [_defaults stringForKey:APPIUM_PLIST_ANDROID_WAIT_ACTIVITY]; }
-(void) setAndroidWaitActivity:(NSString *)androidWaitActivity { [_defaults setValue:androidWaitActivity forKey:APPIUM_PLIST_ANDROID_WAIT_ACTIVITY]; }

-(NSString*) appPath { return [_defaults stringForKey:APPIUM_PLIST_APP_PATH];}
-(void) setAppPath:(NSString *)appPath
{
    [_defaults setValue:appPath forKey:APPIUM_PLIST_APP_PATH];
    if ([appPath hasSuffix:@"app"] || [appPath hasSuffix:@"ipa"] || [appPath hasSuffix:@"zip"])
    {
        [self setPlatform:Platform_iOS];
    }
    if ([appPath hasSuffix:@"apk"])
    {
        [self setPlatform:Platform_Android];
    }
}

-(NSString*) avd { return [_defaults stringForKey:APPIUM_PLIST_AVD]; }
-(void) setAvd:(NSString *)avd { [_defaults setValue:avd forKey:APPIUM_PLIST_AVD]; }

-(BOOL) breakOnNodeApplicationStart { return self.developerMode && self.useNodeDebugging && [_defaults boolForKey:APPIUM_PLIST_BREAK_ON_NODEJS_APP_START]; }
-(void) setBreakOnNodeApplicationStart:(BOOL)breakOnNodeApplicationStart { [_defaults setBool:breakOnNodeApplicationStart forKey:APPIUM_PLIST_BREAK_ON_NODEJS_APP_START]; }

-(NSString*) bundleID { return [_defaults stringForKey:APPIUM_PLIST_BUNDLEID]; }
-(void) setBundleID:(NSString *)bundleID { [_defaults setValue:bundleID forKey:APPIUM_PLIST_BUNDLEID]; }

-(BOOL) checkForUpdates { return [_defaults boolForKey:APPIUM_PLIST_CHECK_FOR_UPDATES]; }
-(void) setCheckForUpdates:(BOOL)checkForUpdates { [_defaults setBool:checkForUpdates forKey:APPIUM_PLIST_CHECK_FOR_UPDATES]; }

-(NSString*) customAndroidSDKPath { return [_defaults stringForKey:APPIUM_PLIST_CUSTOM_ANDROID_SDK_PATH]; }
-(void) setCustomAndroidSDKPath:(NSString *)customAndroidSDKPath { [_defaults setValue:customAndroidSDKPath forKey:APPIUM_PLIST_CUSTOM_ANDROID_SDK_PATH]; }

-(BOOL) enableAppiumInspectorWindowSupport { return [_defaults boolForKey:APPIUM_PLIST_ENABLE_APPIUM_INSPECTOR_WINDOW_SUPPORT]; }
-(void) setEnableAppiumInspectorWindowSupport:(BOOL)enableAppiumInspectorWindowSupport { [_defaults setBool:enableAppiumInspectorWindowSupport forKey:APPIUM_PLIST_ENABLE_APPIUM_INSPECTOR_WINDOW_SUPPORT]; }

-(NSString*) externalAppiumPackagePath { return [_defaults stringForKey:APPIUM_PLIST_EXTERNAL_APPIUM_PACKAGE_PATH]; }
-(void) setExternalAppiumPackagePath:(NSString *)externalAppiumPackagePath { [_defaults setValue:externalAppiumPackagePath forKey:APPIUM_PLIST_EXTERNAL_APPIUM_PACKAGE_PATH]; }

-(NSString*) externalNodeJSBinaryPath { return [_defaults stringForKey:APPIUM_PLIST_EXTERNAL_NODEJS_BINARY_PATH]; }
-(void) setExternalNodeJSBinaryPath:(NSString *)externalNodeJSBinaryPath { [_defaults setValue:externalNodeJSBinaryPath forKey:APPIUM_PLIST_EXTERNAL_NODEJS_BINARY_PATH]; }

-(BOOL) developerMode { return [_defaults boolForKey:APPIUM_PLIST_DEVELOPER_MODE]; }
-(void) setDeveloperMode:(BOOL)developerMode { [_defaults setBool:developerMode forKey:APPIUM_PLIST_DEVELOPER_MODE]; }

-(iOSAutomationDevice) deviceToForce { return [[_defaults stringForKey:APPIUM_PLIST_DEVICE] isEqualToString:APPIUM_PLIST_FORCE_DEVICE_IPAD] ? iOSAutomationDevice_iPad : iOSAutomationDevice_iPhone; }
-(void) setDeviceToForce:(iOSAutomationDevice)deviceToForce {[self setDeviceToForceString:(deviceToForce == iOSAutomationDevice_iPad ? APPIUM_PLIST_FORCE_DEVICE_IPAD : APPIUM_PLIST_FORCE_DEVICE_IPHONE)]; }
-(NSString*) deviceToForceString { return [[_defaults valueForKey:APPIUM_PLIST_DEVICE] isEqualToString:APPIUM_PLIST_FORCE_DEVICE_IPAD] ? APPIUM_PLIST_FORCE_DEVICE_IPAD : APPIUM_PLIST_FORCE_DEVICE_IPHONE ; }
-(void) setDeviceToForceString:(NSString *)deviceToForceString { [_defaults setValue:deviceToForceString forKey:APPIUM_PLIST_DEVICE]; }

-(BOOL) forceDevice { return [_defaults boolForKey:APPIUM_PLIST_FORCE_DEVICE]; }
-(void) setForceDevice:(BOOL)forceDevice { [_defaults setBool:forceDevice forKey:APPIUM_PLIST_FORCE_DEVICE]; }

-(BOOL) forceOrientation { return [_defaults boolForKey:APPIUM_PLIST_FORCE_ORIENTATION]; }
-(void) setForceOrientation:(BOOL)forceOrientation { [_defaults setBool:forceOrientation forKey:APPIUM_PLIST_FORCE_ORIENTATION]; }

-(BOOL) isAndroid { return self.platform == Platform_Android; }
-(BOOL) isIOS { return self.platform == Platform_iOS; }

-(BOOL) isServerRunning { return _isServerRunning; }
-(void) setIsServerRunning:(BOOL)isServerRunning
{
	_isServerRunning = isServerRunning;
	_isServerListening = isServerRunning ? _isServerListening : NO;
}

-(BOOL) isServerListening { return _isServerListening; }
-(void) setIsServerListening:(BOOL)isServerListening { _isServerListening = isServerListening; }

-(NSString*) ipAddress { return [_defaults stringForKey:APPIUM_PLIST_SERVER_ADDRESS]; }
-(void) setIpAddress:(NSString *)ipAddress { [_defaults setValue:ipAddress forKey:APPIUM_PLIST_SERVER_ADDRESS]; }

-(BOOL) keepArtifacts { return [_defaults boolForKey:APPIUM_PLIST_KEEP_ARTIFACTS]; }
-(void) setKeepArtifacts:(BOOL)keepArtifacts { [_defaults setBool:keepArtifacts forKey:APPIUM_PLIST_KEEP_ARTIFACTS];}

-(BOOL) killProcessesUsingPort { return [_defaults boolForKey:APPIUM_PLIST_KILL_PROCESSES_USING_PORT]; }
-(void) setKillProcessesUsingPort:(BOOL)killProcessesUsingPort { [_defaults setBool:killProcessesUsingPort forKey:APPIUM_PLIST_KILL_PROCESSES_USING_PORT];}

-(NSString*) logFile { return [_defaults stringForKey:APPIUM_PLIST_LOG_FILE]; }
-(void) setLogFile:(NSString *)logFile { [_defaults setValue:logFile forKey:APPIUM_PLIST_LOG_FILE]; }

-(NSString*) logWebHook { return [_defaults stringForKey:APPIUM_PLIST_LOG_WEBHOOK]; }
-(void) setLogWebHook:(NSString *)logWebHook { [_defaults setValue:logWebHook forKey:APPIUM_PLIST_LOG_WEBHOOK]; }

-(NSNumber*) nodeDebugPort { return [NSNumber numberWithInt:[[_defaults stringForKey:APPIUM_PLIST_NODEJS_DEBUG_PORT] intValue]]; }
-(void) setNodeDebugPort:(NSNumber *)nodeDebugPort { [[NSUserDefaults standardUserDefaults] setValue:nodeDebugPort forKey:APPIUM_PLIST_NODEJS_DEBUG_PORT]; }

-(iOSOrientation) orientationToForce { return [[_defaults stringForKey:APPIUM_PLIST_ORIENTATION] isEqualToString:APPIUM_PLIST_FORCE_ORIENTATION_LANDSCAPE] ? iOSOrientation_Landscape : iOSOrientation_Portrait; }
-(void) setOrientationToForce:(iOSOrientation)orientationToForce {[self setOrientationToForceString:(orientationToForce == iOSOrientation_Landscape ? APPIUM_PLIST_FORCE_ORIENTATION_LANDSCAPE : APPIUM_PLIST_FORCE_ORIENTATION_PORTRAIT)]; }
-(NSString*) orientationToForceString { return [[_defaults valueForKey:APPIUM_PLIST_ORIENTATION] isEqualToString:APPIUM_PLIST_FORCE_ORIENTATION_LANDSCAPE] ? APPIUM_PLIST_FORCE_ORIENTATION_LANDSCAPE : APPIUM_PLIST_FORCE_ORIENTATION_PORTRAIT ; }
-(void) setOrientationToForceString:(NSString *)orientationToForceString { [_defaults setValue:orientationToForceString forKey:APPIUM_PLIST_ORIENTATION]; }

-(BOOL) overrideExistingSessions { return [_defaults boolForKey:APPIUM_PLIST_OVERRIDE_EXISTING_SESSIONS]; }
-(void) setOverrideExistingSessions:(BOOL)overrideExistingSessions { [_defaults setBool:overrideExistingSessions forKey:APPIUM_PLIST_OVERRIDE_EXISTING_SESSIONS]; }

-(Platform)platform
{
    if (self.useAppPath)
    {
        if ([self.appPath hasSuffix:@".app"])
        {
            [self setPlatform:Platform_iOS];
        }
        if ([self.appPath hasSuffix:@".apk"])
        {
            [self setPlatform:Platform_Android];
            [self refreshAvailableActivities];
        }
    }
    return [_defaults integerForKey:APPIUM_PLIST_TAB_STATE] == APPIUM_PLIST_TAB_STATE_ANDROID ? Platform_Android : Platform_iOS;
}
-(void)setPlatform:(Platform)platform { [_defaults setInteger:(platform == Platform_Android ? APPIUM_PLIST_TAB_STATE_ANDROID : APPIUM_PLIST_TAB_STATE_IOS) forKey:APPIUM_PLIST_TAB_STATE]; }

-(NSNumber*) port { return [NSNumber numberWithInt:[[_defaults stringForKey:APPIUM_PLIST_SERVER_PORT] intValue]]; }
-(void) setPort:(NSNumber *)port { [[NSUserDefaults standardUserDefaults] setValue:port forKey:APPIUM_PLIST_SERVER_PORT]; }

-(BOOL) prelaunchApp { return [_defaults boolForKey:APPIUM_PLIST_PRELAUNCH]; }
-(void) setPrelaunchApp:(BOOL)preLaunchApp { [_defaults setBool:preLaunchApp forKey:APPIUM_PLIST_PRELAUNCH]; }

-(BOOL) resetApplicationState { return [_defaults boolForKey:APPIUM_PLIST_RESET_APPLICATION_STATE]; }
-(void) setResetApplicationState:(BOOL)resetApplicationState { [_defaults setBool:resetApplicationState forKey:APPIUM_PLIST_RESET_APPLICATION_STATE]; }

-(NSString*) robotAddress { return [_defaults stringForKey:APPIUM_PLIST_ROBOT_ADDRESS]; }
-(void) setRobotAddress:(NSString *)robotAddress { [_defaults setValue:robotAddress forKey:APPIUM_PLIST_ROBOT_ADDRESS]; }

-(NSNumber*) robotPort { return [NSNumber numberWithInt:[[_defaults stringForKey:APPIUM_PLIST_ROBOT_PORT] intValue]]; }
-(void) setRobotPort:(NSNumber *)robotPort { [[NSUserDefaults standardUserDefaults] setValue:robotPort forKey:APPIUM_PLIST_ROBOT_PORT]; }

-(NSNumber*) selendroidPort { return [NSNumber numberWithInt:[[_defaults stringForKey:APPIUM_PLIST_SELENDROID_PORT] intValue]]; }
-(void) setSelendroidPort:(NSNumber *)selendroidPort{ [[NSUserDefaults standardUserDefaults] setValue:selendroidPort forKey:APPIUM_PLIST_SELENDROID_PORT]; }

-(NSString*) seleniumGridConfigFile { return [_defaults stringForKey:APPIUM_PLIST_SELENIUM_GRID_CONFIG_FILE]; }
-(void) setSeleniumGridConfigFile:(NSString *)seleniumGridConfigFile { [_defaults setValue:seleniumGridConfigFile forKey:APPIUM_PLIST_SELENIUM_GRID_CONFIG_FILE]; }

-(NSString*) udid {return [_defaults stringForKey:APPIUM_PLIST_UDID];}
-(void) setUdid:(NSString *)udid { [ _defaults setValue:udid forKey:APPIUM_PLIST_UDID]; }

-(BOOL) useAndroidActivity { return [_defaults boolForKey:APPIUM_PLIST_USE_ANDROID_ACTIVITY]; }
-(void) setUseAndroidActivity:(BOOL)useAndroidActivity { [_defaults setBool:useAndroidActivity forKey:APPIUM_PLIST_USE_ANDROID_ACTIVITY]; }

-(BOOL) useAndroidDeviceReadyTimeout { return [_defaults boolForKey:APPIUM_PLIST_USE_ANDROID_DEVICE_READY_TIMEOUT]; }
-(void) setUseAndroidDeviceReadyTimeout:(BOOL)useAndroidDeviceReadyTimeout { [_defaults setBool:useAndroidDeviceReadyTimeout forKey:APPIUM_PLIST_USE_ANDROID_DEVICE_READY_TIMEOUT]; }

-(BOOL) useAndroidKeystore { return [_defaults boolForKey:APPIUM_PLIST_USE_ANDROID_KEYSTORE]; }
-(void) setUseAndroidKeystore:(BOOL)useAndroidKeystore { [_defaults setBool:useAndroidKeystore forKey:APPIUM_PLIST_USE_ANDROID_KEYSTORE]; }

-(BOOL) useAndroidPackage {	return [_defaults boolForKey:APPIUM_PLIST_USE_ANDROID_PACKAGE]; }
-(void) setUseAndroidPackage:(BOOL)useAndroidPackage { [_defaults setBool:useAndroidPackage forKey:APPIUM_PLIST_USE_ANDROID_PACKAGE]; }

-(BOOL) useAndroidWaitActivity { return [_defaults boolForKey:APPIUM_PLIST_USE_ANDROID_WAIT_ACTIVITY]; }
-(void) setUseAndroidWaitActivity:(BOOL)useAndroidWaitActivity { [_defaults setBool:useAndroidWaitActivity forKey:APPIUM_PLIST_USE_ANDROID_WAIT_ACTIVITY]; }

-(BOOL) useAppPath { return [_defaults boolForKey:APPIUM_PLIST_USE_APP_PATH]; }
-(void) setUseAppPath:(BOOL)useAppPath { [_defaults setBool:useAppPath forKey:APPIUM_PLIST_USE_APP_PATH]; }

-(BOOL) useAVD { return [_defaults boolForKey:APPIUM_PLIST_USE_AVD]; }
-(void) setUseAVD:(BOOL)useAVD { [_defaults setBool:useAVD forKey:APPIUM_PLIST_USE_AVD]; }

-(BOOL) useBundleID { return [_defaults boolForKey:APPIUM_PLIST_USE_BUNDLEID]; }
-(void) setUseBundleID:(BOOL)useBundleID { [_defaults setBool:useBundleID forKey:APPIUM_PLIST_USE_BUNDLEID]; }

-(BOOL) useCustomAndroidSDKPath { return [_defaults boolForKey:APPIUM_PLIST_USE_CUSTOM_ANDROID_SDK_PATH]; }
-(void) setUseCustomAndroidSDKPath:(BOOL)useCustomAndroidSDKPath { [_defaults setBool:useCustomAndroidSDKPath forKey:APPIUM_PLIST_USE_CUSTOM_ANDROID_SDK_PATH]; }

-(BOOL) useExternalAppiumPackage { return self.developerMode && [_defaults boolForKey:APPIUM_PLIST_USE_EXTERNAL_APPIUM_PACKAGE]; }
-(void) setUseExternalAppiumPackage:(BOOL)useCustomAppiumPackage { [_defaults setBool:useCustomAppiumPackage forKey:APPIUM_PLIST_USE_EXTERNAL_APPIUM_PACKAGE]; }

-(BOOL) useExternalNodeJSBinary { return self.developerMode && [_defaults boolForKey:APPIUM_PLIST_USE_EXTERNAL_NODEJS_BINARY]; }
-(void) setUseExternalNodeJSBinary:(BOOL)useCustomNodeJSBinary { [_defaults setBool:useCustomNodeJSBinary forKey:APPIUM_PLIST_USE_EXTERNAL_NODEJS_BINARY]; }

-(BOOL) useLogFile { return [_defaults boolForKey:APPIUM_PLIST_USE_LOG_FILE]; }
-(void) setUseLogFile:(BOOL)useLogFile { [_defaults setBool:useLogFile forKey:APPIUM_PLIST_USE_LOG_FILE]; }

-(BOOL) useLogWebHook { return [_defaults boolForKey:APPIUM_PLIST_USE_LOG_WEBHOOK]; }
-(void) setUseLogWebHook:(BOOL)useLogWebHook { [_defaults setBool:useLogWebHook forKey:APPIUM_PLIST_USE_LOG_WEBHOOK]; }

-(BOOL) useMobileSafari { return [_defaults boolForKey:APPIUM_PLIST_USE_MOBILE_SAFARI]; }
-(void) setUseMobileSafari:(BOOL)useMobileSafari { [_defaults setBool:useMobileSafari forKey:APPIUM_PLIST_USE_MOBILE_SAFARI]; }

-(BOOL) useNativeInstrumentsLib { return [_defaults boolForKey:APPIUM_PLIST_USE_NATIVE_INSTRUMENTS_LIB]; }
-(void) setUseNativeInstrumentsLib:(BOOL)useInstrumentsWithoutDelay { [_defaults setBool:useInstrumentsWithoutDelay forKey:APPIUM_PLIST_USE_NATIVE_INSTRUMENTS_LIB]; }

-(BOOL) useNodeDebugging { return self.developerMode && [_defaults boolForKey:APPIUM_PLIST_USE_NODEJS_DEBUGGING]; }
-(void) setUseNodeDebugging:(BOOL)useNodeDebugging { [_defaults setBool:useNodeDebugging forKey:APPIUM_PLIST_USE_NODEJS_DEBUGGING]; }

-(BOOL) useRobot { return [_defaults boolForKey:APPIUM_PLIST_USE_ROBOT]; }
-(void) setUseRobot:(BOOL)useRobot { [_defaults setBool:useRobot forKey:APPIUM_PLIST_USE_ROBOT]; }

-(BOOL) useQuietLogging { return [_defaults boolForKey:APPIUM_PLIST_USE_QUIET_LOGGING]; }
-(void) setUseQuietLogging:(BOOL)useQuietLogging { [_defaults setBool:useQuietLogging forKey:APPIUM_PLIST_USE_QUIET_LOGGING]; }

-(BOOL) useRemoteServer { return [_defaults boolForKey:APPIUM_PLIST_USE_REMOTE_SERVER] && [self developerMode]; }
-(void) setUseRemoteServer:(BOOL)useRemoteServer
{
	[_defaults setBool:useRemoteServer forKey:APPIUM_PLIST_USE_REMOTE_SERVER];
	if (useRemoteServer)
	{
		[self killServer];
	}
	[self setIsServerListening:useRemoteServer];
}

-(BOOL) useSelendroidPort { return [_defaults boolForKey:APPIUM_PLIST_USE_SELENDROID_PORT]; }
-(void) setUseSelendroidPort:(BOOL)useSelendroidPort { [_defaults setBool:useSelendroidPort forKey:APPIUM_PLIST_USE_SELENDROID_PORT]; }

-(BOOL) useSeleniumGridConfigFile { return [_defaults boolForKey:APPIUM_PLIST_USE_SELENIUM_GRID_CONFIG_FILE]; }
-(void) setUseSeleniumGridConfigFile:(BOOL)useSeleniumGridConfigFile { [_defaults setBool:useSeleniumGridConfigFile forKey:APPIUM_PLIST_USE_SELENIUM_GRID_CONFIG_FILE]; }

-(BOOL) useUDID { return [_defaults boolForKey:APPIUM_PLIST_USE_UDID]; }
-(void) setUseUDID:(BOOL)useUDID { [_defaults setBool:useUDID forKey:APPIUM_PLIST_USE_UDID]; }

-(NSString*) xcodePath
{
	@try
	{
		NSString *path = [Utility runTaskWithBinary:@"/usr/bin/xcode-select" arguments:[NSArray arrayWithObject:@"--print-path"]];
		path = [path stringByReplacingOccurrencesOfString:@"\n" withString:@""];
		if ([path hasSuffix:@"/Contents/Developer"])
		{
			path = [path substringWithRange:NSMakeRange(0, path.length - @"/Contents/Developer".length)];
		}
		return path;
	}
	@catch (NSException *exception) {
		return @"/";
	}
}

-(void) setXcodePath:(NSString *)xcodePath
{
	NSAppleScript	*xcodeSelectScript;
	NSMutableDictionary *errorDict = [NSMutableDictionary new];
	xcodeSelectScript = [[NSAppleScript alloc] initWithSource:
								[NSString stringWithFormat:@"do shell script \"/usr/bin/xcode-select --switch \\\"%@\\\"\" with administrator privileges", xcodePath]];
	[[xcodeSelectScript executeAndReturnError:&errorDict] stringValue];

	// update xcode path
	NSLog(@"New Xcode Path: %@", self.xcodePath);
}

#pragma mark - Methods

-(BOOL)killServer
{
    if (self.serverTask != nil && [self.serverTask isRunning])
    {
        [self.serverTask terminate];
		[self setIsServerRunning:NO];
        return YES;
    }
    return NO;
}

-(BOOL)startServer
{
    int myPid = (self.serverTask != nil) ? self.serverTask.processIdentifier : -1;
    if ([self killServer])
    {
        return NO;
    }

    // kill any processes using the appium server port
    if (self.killProcessesUsingPort)
    {
        NSNumber *procPid = [Utility getPidListeningOnPort:self.port];
        if (procPid != nil && myPid != [procPid intValue])
        {
            NSString* script = [NSString stringWithFormat: @"kill `lsof -t -i:%@`", self.port];
            system([script UTF8String]);
			system([@"killall -z lsof" UTF8String]);
        }
    }

	// build arguments
	NSString *nodeDebuggingArguments = @"";
	if (self.useNodeDebugging)
	{
		nodeDebuggingArguments = [nodeDebuggingArguments stringByAppendingString:[NSString stringWithFormat:@" --debug=%@", [self.nodeDebugPort stringValue]]];
		if (self.breakOnNodeApplicationStart)
		{
			nodeDebuggingArguments = [nodeDebuggingArguments stringByAppendingString:@" --debug-brk"];
		}
	}
	NSString *nodeCommandString;
	if (self.useExternalNodeJSBinary)
	{
		nodeCommandString = [NSString stringWithFormat:@"'%@'%@ lib/server/main.js", self.externalNodeJSBinaryPath, nodeDebuggingArguments];
	}
	else
	{
		nodeCommandString = [NSString stringWithFormat:@"'%@%@'%@ lib/server/main.js", [[NSBundle mainBundle]resourcePath], @"/node/bin/node", nodeDebuggingArguments];
		
	}
	if (self.useCustomAndroidSDKPath)
	{
		nodeCommandString = [NSString stringWithFormat:@"export ANDROID_HOME=\"%@\"; %@", self.customAndroidSDKPath, nodeCommandString];
	}

	if (![self.ipAddress isEqualTo:@"0.0.0.0"])
    {
		nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--address", self.ipAddress];
    }
	if (![self.port isEqualTo:@"4723"])
    {
		nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--port", [self.port stringValue]];
    }
    if (self.useAppPath)
    {
		if ([self.appPath hasSuffix:@"ipa"])
		{
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--ipa", [self.appPath stringByReplacingOccurrencesOfString:@" " withString:@"\\ "]];
		}
		else
		{
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--app", [self.appPath stringByReplacingOccurrencesOfString:@" " withString:@"\\ "]];
		}
    }
	else if (self.useBundleID)
    {
		nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--app", self.bundleID];
    }
	if (self.useUDID)
    {
		nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--udid", self.udid];
    }
	if (self.prelaunchApp)
    {
		nodeCommandString = [nodeCommandString stringByAppendingString:@" --pre-launch"];
    }
	if (!self.resetApplicationState)
    {
		nodeCommandString = [nodeCommandString stringByAppendingString:@" --no-reset"];
    }
    if (self.overrideExistingSessions)
    {
        nodeCommandString = [nodeCommandString stringByAppendingString:@" --session-override"];
    }
    if (self.useSeleniumGridConfigFile)
    {
        nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--nodeconfig", [self.seleniumGridConfigFile stringByReplacingOccurrencesOfString:@" " withString:@"\\ "]];
    }

    // logging preferences
	if (self.useQuietLogging)
    {
		nodeCommandString = [nodeCommandString stringByAppendingString:@" --quiet"];
    }
    if (self.keepArtifacts)
    {
		nodeCommandString = [nodeCommandString stringByAppendingString:@" --keep-artifacts"];
    }
    if (self.useLogFile)
    {
        nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--log", [self.logFile stringByReplacingOccurrencesOfString:@" " withString:@"\\ "]];
    }
    if (self.useLogWebHook)
    {
        nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--webhook", self.logWebHook];
    }

    // iOS preferences
    if (self.platform == Platform_iOS)
    {
        if (self.useNativeInstrumentsLib)
        {
			nodeCommandString = [nodeCommandString stringByAppendingString:@" --native-instruments-lib"];
        }
        if (self.forceDevice)
        {
            if (self.deviceToForce == iOSAutomationDevice_iPhone)
            {
				nodeCommandString = [nodeCommandString stringByAppendingString:@" --force-iphone"];
            }
            else if (self.deviceToForce == iOSAutomationDevice_iPad)
            {
				nodeCommandString = [nodeCommandString stringByAppendingString:@" --force-ipad"];
            }
        }
		if (self.forceOrientation)
        {
            if (self.orientationToForce == iOSOrientation_Portrait)
            {
				nodeCommandString = [nodeCommandString stringByAppendingString:@" --orientation PORTRAIT"];
            }
            else if (self.orientationToForce == iOSOrientation_Landscape)
            {
				nodeCommandString = [nodeCommandString stringByAppendingString:@" --orientation LANDSCAPE"];
            }
        }
		if (self.useMobileSafari)
		{
			nodeCommandString = [nodeCommandString stringByAppendingString:@" --safari"];
		}
    }

    // Android preferences
    if (self.platform == Platform_Android)
    {
        if (self.useAndroidPackage)
        {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%@\"", @"--app-pkg", self.androidPackage];
        }
        if (self.useAndroidActivity)
        {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%@\"", @"--app-activity", self.androidActivity];
        }
		if (self.useAndroidDeviceReadyTimeout)
        {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%d\"", @"--device-ready-timeout", [self.androidDeviceReadyTimeout intValue]];
        }
		if (self.useAndroidWaitActivity)
        {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%@\"", @"--app-wait-activity", self.androidWaitActivity];
        }
		if (self.useAVD)
        {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ @%@", @"--avd", self.avd];
        }
		if (self.androidFullReset)
		{
			nodeCommandString = [nodeCommandString stringByAppendingString:@" --full-reset"];
		}
		if (self.useSelendroidPort)
		{
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%d\"", @"--selendroid-port", [self.selendroidPort intValue]];
		}

        // Android keystore preferences
        if (self.useAndroidKeystore)
        {
            nodeCommandString = [nodeCommandString stringByAppendingString:@" --use-keystore"];
            nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--keystore-path", [self.androidKeystorePath stringByReplacingOccurrencesOfString:@" " withString:@"\\ "]];
            nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--keystore-password", [self.androidKeystorePassword stringByReplacingOccurrencesOfString:@" " withString:@"\\ "]];
            nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--key-alias", [self.androidKeyAlias stringByReplacingOccurrencesOfString:@" " withString:@"\\ "]];
            nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--key-password", [self.androidKeyPassword stringByReplacingOccurrencesOfString:@" " withString:@"\\ "]];
        }
    }

	// Robot preferences
	if (self.useRobot)
    {
		nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%@\"", @"--robot-address", self.robotAddress];
		nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%d\"", @"--robot-port", [self.robotPort intValue]];
	}

	[self setServerTask:[NSTask new]];
	if (self.useExternalAppiumPackage)
	{
		[self.serverTask setCurrentDirectoryPath:self.externalAppiumPackagePath];
	}
	else
	{
		[self.serverTask setCurrentDirectoryPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle]resourcePath], @"node_modules/appium"]];
	}
    [self.serverTask setLaunchPath:@"/bin/bash"];
    [self.serverTask setArguments: [NSArray arrayWithObjects: @"-l",
									@"-c", nodeCommandString, nil]];

	// redirect i/o
    [self.serverTask setStandardOutput:[NSPipe pipe]];
	[self.serverTask setStandardError:[NSPipe pipe]];
    [self.serverTask setStandardInput:[NSPipe pipe]];

	// launch
    [self.serverTask launch];
    [self setIsServerRunning:self.serverTask.isRunning];
	[self performSelectorInBackground:@selector(monitorListenStatus) withObject:nil];
    return self.isServerRunning;
}

-(void) monitorListenStatus
{
	uint pollInterval = self.isServerListening ? 60 : 1;
	while(self.isServerRunning)
	{
        // OPTION #1
        // poll with sockets api
        /*
		 sleep(.5);
		 BOOL newValue = [Utility checkIfTCPPortIsInUse:[self.port shortValue] atAddress:[self.ipAddress UTF8String]];
		 if (newValue == YES && self.isServerListening)
		 {
		 // sleep to avoid race condition where server is listening but not ready
		 sleep(1);
		 }
		 [self setIsServerListening:newValue];
		 */


        // OPTION #2
        // poll with lsof command

		/*
        // space out the checks by 1 second
		sleep(1);

        // check if there is a process listening on the port
        NSNumber *pidOnPort = [Utility getPidListeningOnPort:self.port];
        BOOL newValue = pidOnPort != nil;

        // set the value
	 	if (newValue == YES && !self.isServerListening)
	 	{
			// sleep to avoid race condition where server is listening but not ready
		 	sleep(1);
		}
		[self setIsServerListening:newValue];
		 */

        // OPTION #3
		// poll with web requests

		 sleep(pollInterval);
		 NSError *error = nil;
		 NSString *urlString = [NSString stringWithFormat:@"http://%@:%d/wd/hub/status", self.ipAddress, self.port.intValue];
		 NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:1];

		 NSURLResponse *response;
		 NSData *urlData = [NSURLConnection sendSynchronousRequest:request
		 returningResponse:&response
		 error:&error];
		 if (error != nil && [error code] != 0)
		 {
			 [self setIsServerListening:NO];
			 pollInterval = 1;
			 continue;
		 }

		 NSDictionary *json = [NSJSONSerialization JSONObjectWithData:urlData
		 options: NSJSONReadingMutableContainers & NSJSONReadingMutableLeaves
		 error: &error];
		 if (error != nil && [error code] != 0)
		 {
			 [self setIsServerListening:NO];
			 pollInterval = 1;
			 continue;
		 }
		 else
		 {
			 NSObject *statusObj = [json objectForKey:@"status"];
			 sleep(1); // sleep to avoid race condition where server is listening but not ready
			 [self setIsServerListening:statusObj != nil && [statusObj isKindOfClass:[NSNumber class]] && [((NSNumber*)statusObj) intValue] == 0];
			 pollInterval = MIN(10*pollInterval, 60); // sleep for longer
			 continue;
		 }


	}
	[self setIsServerListening:NO];
}

-(void) refreshAvailableActivities
{
    NSString *androidBinaryPath = [Utility pathToAndroidBinary:@"aapt"];

	if (androidBinaryPath == nil || ![[NSFileManager defaultManager] fileExistsAtPath:androidBinaryPath])
	{
		return;
	}
	@try
	{
		// get the xml dump from aapt
		NSString *aaptString = [Utility runTaskWithBinary:androidBinaryPath arguments:[NSArray arrayWithObjects:@"dump", @"xmltree", self.appPath, @"AndroidManifest.xml", nil]];

		// read line by line
		NSArray *aaptLines = [aaptString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		NSMutableArray *activities = [NSMutableArray new];
		BOOL currentElementIsActivity;
		for (int i=0; i < aaptLines.count; i++)
		{
			NSString *line = [((NSString*)[aaptLines objectAtIndex:i]) stringByTrimmingLeadingWhitespace];

			// determine when an activity element has started or ended
			if ([line hasPrefix:@"E:"])
			{
				currentElementIsActivity = [line hasPrefix:@"E: activity (line="];
			}

			// determine when the activity name has appeared
			if (currentElementIsActivity && [line hasPrefix:@"A: android:name("])
			{
				NSArray *lineComponents = [line componentsSeparatedByString:@"\""];
				if (lineComponents.count >= 3)
				{
					[activities addObject:(NSString*)[lineComponents objectAtIndex:1]];
				}
			}
		}
		[self setAvailableActivities:activities];
	}
	@catch (NSException *exception) {
		NSLog(@"Could not list Android Activities: %@", exception);
	}
}

-(void) refreshAVDs
{
	NSString *androidBinaryPath = [Utility pathToAndroidBinary:@"android"];

	if (androidBinaryPath == nil || ![[NSFileManager defaultManager] fileExistsAtPath:androidBinaryPath])
	{
		return;
	}
	
	NSMutableArray *avds = [NSMutableArray new];

	@try
	{
		NSString *avdString = [Utility runTaskWithBinary:androidBinaryPath arguments:[NSArray arrayWithObjects:@"list", @"avd", @"-c", nil]];
		NSArray *avdList = [avdString componentsSeparatedByString:@"\n"];
		for (NSString *avd in avdList)
		{
			if (avd.length > 0)
			{
				[avds addObject:avd];
			}
		}
	}
	@catch (NSException *exception) {
		NSLog(@"Could not list Android AVDs: %@", exception);
	}

	[self setAvailableAVDs:avds];
	if (avds.count > 0)
	{
		[self setAvd:[avds objectAtIndex:0]];
	}
}


@end
