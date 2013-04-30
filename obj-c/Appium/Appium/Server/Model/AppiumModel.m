//
//  AppiumModel.m
//  Appium
//
//  Created by Dan Cuellar on 3/12/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumModel.h"
#import "AppiumAppDelegate.h"
#import "Utility.h"
#import "AppiumPreferencesFile.h"

#pragma  mark - Model

NSUserDefaults* _defaults;
BOOL _isServerRunning;
BOOL _isServerListening;

@implementation AppiumModel

- (id)init
{
    self = [super init];
    if (self) {
		NSString *filePath = [[NSBundle mainBundle] pathForResource:@"defaults" ofType:@"plist"];
		NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
		[[NSUserDefaults standardUserDefaults] registerDefaults:settingsDict];
		[[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:settingsDict];
		_defaults = [NSUserDefaults standardUserDefaults];
		_isServerRunning = NO;
		_isServerListening = [self useRemoteServer];
    }
    return self;
}

#pragma mark - Properties

-(NSString*) androidActivity { return [_defaults stringForKey:APPIUM_PLIST_ANDROID_ACTIVITY]; }
-(void) setAndroidActivity:(NSString *)androidActivity { [_defaults setValue:androidActivity forKey:APPIUM_PLIST_ANDROID_ACTIVITY]; }

-(NSNumber*) androidDeviceReadyTimeout { return [NSNumber numberWithInt:[[_defaults stringForKey:APPIUM_PLIST_ANDROID_DEVICE_READY_TIMEOUT] intValue]]; }
-(void) setAndroidDeviceReadyTimeout:(NSNumber *)androidDeviceReadyTimeout { [[NSUserDefaults standardUserDefaults] setValue:androidDeviceReadyTimeout forKey:APPIUM_PLIST_ANDROID_DEVICE_READY_TIMEOUT]; }

-(NSString*) androidPackage { return [_defaults stringForKey:APPIUM_PLIST_ANDROID_PACKAGE]; }
-(void) setAndroidPackage:(NSString *)androidPackage { [_defaults setValue:androidPackage forKey:APPIUM_PLIST_ANDROID_PACKAGE]; }

-(NSString*) androidWaitActivity { return [_defaults stringForKey:APPIUM_PLIST_ANDROID_WAIT_ACTIVITY]; }
-(void) setAndroidWaitActivity:(NSString *)androidWaitActivity { [_defaults setValue:androidWaitActivity forKey:APPIUM_PLIST_ANDROID_WAIT_ACTIVITY]; }

-(NSString*) appPath { return [_defaults stringForKey:APPIUM_PLIST_APP_PATH];}
-(void) setAppPath:(NSString *)appPath { [_defaults setValue:appPath forKey:APPIUM_PLIST_APP_PATH]; }

-(NSString*) bundleID { return [_defaults stringForKey:APPIUM_PLIST_BUNDLEID]; }
-(void) setBundleID:(NSString *)bundleID { [_defaults setValue:bundleID forKey:APPIUM_PLIST_BUNDLEID]; }

-(BOOL) checkForUpdates { return [_defaults boolForKey:APPIUM_PLIST_CHECK_FOR_UPDATES]; }
-(void) setCheckForUpdates:(BOOL)checkForUpdates { [_defaults setBool:checkForUpdates forKey:APPIUM_PLIST_CHECK_FOR_UPDATES]; }

-(NSString*) externalAppiumPackagePath { return [_defaults stringForKey:APPIUM_PLIST_EXTERNAL_APPIUM_PACKAGE_PATH]; }
-(void) setExternalAppiumPackagePath:(NSString *)customAppiumPackagePath { [_defaults setValue:customAppiumPackagePath forKey:APPIUM_PLIST_EXTERNAL_APPIUM_PACKAGE_PATH]; }

-(NSString*) externalNodeJSBinaryPath { return [_defaults stringForKey:APPIUM_PLIST_EXTERNAL_NODEJS_BINARY_PATH]; }
-(void) setExternalNodeJSBinaryPath:(NSString *)customNodeJSBinaryPath { [_defaults setValue:customNodeJSBinaryPath forKey:APPIUM_PLIST_EXTERNAL_NODEJS_BINARY_PATH]; }

-(BOOL) developerMode { return [_defaults boolForKey:APPIUM_PLIST_DEVELOPER_MODE]; }
-(void) setDeveloperMode:(BOOL)developerMode { [_defaults setBool:developerMode forKey:APPIUM_PLIST_DEVELOPER_MODE]; }

-(iOSAutomationDevice) deviceToForce { return [[_defaults stringForKey:APPIUM_PLIST_DEVICE] isEqualToString:APPIUM_PLIST_FORCE_DEVICE_IPAD] ? iOSAutomationDevice_iPad : iOSAutomationDevice_iPhone; }
-(void) setDeviceToForce:(iOSAutomationDevice)deviceToForce {[self setDeviceToForceString:(deviceToForce == iOSAutomationDevice_iPad ? APPIUM_PLIST_FORCE_DEVICE_IPAD : APPIUM_PLIST_FORCE_DEVICE_IPHONE)]; }
-(NSString*) deviceToForceString { return [[_defaults valueForKey:APPIUM_PLIST_DEVICE] isEqualToString:APPIUM_PLIST_FORCE_DEVICE_IPAD] ? APPIUM_PLIST_FORCE_DEVICE_IPAD : APPIUM_PLIST_FORCE_DEVICE_IPHONE ; }
-(void) setDeviceToForceString:(NSString *)deviceToForceString { [_defaults setValue:deviceToForceString forKey:APPIUM_PLIST_DEVICE]; }

-(BOOL) fastReset { return [_defaults boolForKey:APPIUM_PLIST_FAST_RESET]; }
-(void) setFastReset:(BOOL)fastReset { [_defaults setBool:fastReset forKey:APPIUM_PLIST_FAST_RESET]; }

-(BOOL) forceDevice { return [_defaults boolForKey:APPIUM_PLIST_FORCE_DEVICE]; }
-(void) setForceDevice:(BOOL)forceDevice { [_defaults setBool:forceDevice forKey:APPIUM_PLIST_FORCE_DEVICE]; }

-(BOOL) forceOrientation { return [_defaults boolForKey:APPIUM_PLIST_FORCE_ORIENTATION]; }
-(void) setForceOrientation:(BOOL)forceOrientation { [_defaults setBool:forceOrientation forKey:APPIUM_PLIST_FORCE_ORIENTATION]; }

-(BOOL) isServerRunning { return _isServerRunning; }
-(void) setIsServerRunning:(BOOL)isServerRunning { _isServerRunning = isServerRunning; }

-(BOOL) isServerListening { return _isServerListening; }
-(void) setIsServerListening:(BOOL)isServerListening { _isServerListening = isServerListening; }

-(NSString*) ipAddress { return [_defaults stringForKey:APPIUM_PLIST_SERVER_ADDRESS]; }
-(void) setIpAddress:(NSString *)ipAddress { [_defaults setValue:ipAddress forKey:APPIUM_PLIST_SERVER_ADDRESS]; }

-(BOOL) keepArtifacts { return [_defaults boolForKey:APPIUM_PLIST_KEEP_ARTIFACTS]; }
-(void) setKeepArtifacts:(BOOL)keepArtifacts { [_defaults setBool:keepArtifacts forKey:APPIUM_PLIST_KEEP_ARTIFACTS];}

-(BOOL) logVerbose { return [_defaults boolForKey:APPIUM_PLIST_VERBOSE]; }
-(void) setLogVerbose:(BOOL)logVerbose { [_defaults setBool:logVerbose forKey:APPIUM_PLIST_VERBOSE]; }

-(iOSOrientation) orientationToForce { return [[_defaults stringForKey:APPIUM_PLIST_ORIENTATION] isEqualToString:APPIUM_PLIST_FORCE_ORIENTATION_LANDSCAPE] ? iOSOrientation_Landscape : iOSOrientation_Portrait; }
-(void) setOrientationToForce:(iOSOrientation)orientationToForce {[self setOrientationToForceString:(orientationToForce == iOSOrientation_Landscape ? APPIUM_PLIST_FORCE_ORIENTATION_LANDSCAPE : APPIUM_PLIST_FORCE_ORIENTATION_PORTRAIT)]; }
-(NSString*) orientationToForceString { return [[_defaults valueForKey:APPIUM_PLIST_ORIENTATION] isEqualToString:APPIUM_PLIST_FORCE_ORIENTATION_LANDSCAPE] ? APPIUM_PLIST_FORCE_ORIENTATION_LANDSCAPE : APPIUM_PLIST_FORCE_ORIENTATION_PORTRAIT ; }
-(void) setOrientationToForceString:(NSString *)orientationToForceString { [_defaults setValue:orientationToForceString forKey:APPIUM_PLIST_ORIENTATION]; }

-(Platform)platform { return [_defaults integerForKey:APPIUM_PLIST_TAB_STATE] == APPIUM_PLIST_TAB_STATE_ANDROID ? Platform_Android : Platform_iOS; }
-(void)setPlatform:(Platform)platform { [_defaults setInteger:(platform == Platform_Android ? APPIUM_PLIST_TAB_STATE_ANDROID : APPIUM_PLIST_TAB_STATE_IOS) forKey:APPIUM_PLIST_TAB_STATE]; }

-(NSNumber*) port { return [NSNumber numberWithInt:[[_defaults stringForKey:APPIUM_PLIST_SERVER_PORT] intValue]]; }
-(void) setPort:(NSNumber *)port { [[NSUserDefaults standardUserDefaults] setValue:port forKey:APPIUM_PLIST_SERVER_PORT]; }

-(BOOL) prelaunchApp { return [_defaults boolForKey:APPIUM_PLIST_PRELAUNCH]; }
-(void) setPrelaunchApp:(BOOL)preLaunchApp { [_defaults setBool:preLaunchApp forKey:APPIUM_PLIST_PRELAUNCH]; }

-(BOOL) resetApplicationState { return [_defaults boolForKey:APPIUM_PLIST_RESET_APPLICATION_STATE]; }
-(void) setResetApplicationState:(BOOL)resetApplicationState { [_defaults setBool:resetApplicationState forKey:APPIUM_PLIST_RESET_APPLICATION_STATE]; }

-(NSString*) udid {return [_defaults stringForKey:APPIUM_PLIST_UDID];}
-(void) setUdid:(NSString *)udid { [ _defaults setValue:udid forKey:APPIUM_PLIST_UDID]; }

-(BOOL) useAndroidActivity { return [_defaults boolForKey:APPIUM_PLIST_USE_ANDROID_ACTIVITY]; }
-(void) setUseAndroidActivity:(BOOL)useAndroidActivity { [_defaults setBool:useAndroidActivity forKey:APPIUM_PLIST_USE_ANDROID_ACTIVITY]; }

-(BOOL) useAndroidDeviceReadyTimeout { return [_defaults boolForKey:APPIUM_PLIST_USE_ANDROID_DEVICE_READY_TIMEOUT]; }
-(void) setUseAndroidDeviceReadyTimeout:(BOOL)useAndroidDeviceReadyTimeout { [_defaults setBool:useAndroidDeviceReadyTimeout forKey:APPIUM_PLIST_USE_ANDROID_DEVICE_READY_TIMEOUT]; }

-(BOOL) useAndroidPackage {	return [_defaults boolForKey:APPIUM_PLIST_USE_ANDROID_PACKAGE]; }
-(void) setUseAndroidPackage:(BOOL)useAndroidPackage { [_defaults setBool:useAndroidPackage forKey:APPIUM_PLIST_USE_ANDROID_PACKAGE]; }

-(BOOL) useAndroidWaitActivity { return [_defaults boolForKey:APPIUM_PLIST_USE_ANDROID_WAIT_ACTIVITY]; }
-(void) setUseAndroidWaitActivity:(BOOL)useAndroidWaitActivity { [_defaults setBool:useAndroidWaitActivity forKey:APPIUM_PLIST_USE_ANDROID_WAIT_ACTIVITY]; }

-(BOOL) useAppPath { return [_defaults boolForKey:APPIUM_PLIST_USE_APP_PATH]; }
-(void) setUseAppPath:(BOOL)useAppPath
{
	[_defaults setBool:useAppPath forKey:APPIUM_PLIST_USE_APP_PATH];
	if (useAppPath)
	{
		if (self.useUDID != NO)
		{
			[self setUseUDID:NO];
		}
		if (self.useBundleID != NO)
		{
			[self setUseBundleID:NO];
		}
		if (self.useMobileSafari != NO)
		{
			[self setUseMobileSafari:NO];
		}
	}
}

-(BOOL) useBundleID { return [_defaults boolForKey:APPIUM_PLIST_USE_BUNDLEID]; }
-(void) setUseBundleID:(BOOL)useBundleID
{
	[_defaults setBool:useBundleID forKey:APPIUM_PLIST_USE_BUNDLEID];
	if (useBundleID)
	{
		if (self.useUDID != YES)
		{
			[self setUseUDID:YES];
		}
		if (self.useAppPath != NO)
		{
			[self setUseAppPath:NO];
		}
		if (self.useMobileSafari != NO)
		{
			[self setUseMobileSafari:NO];
		}
	}
	else
	{
		if (self.useUDID != NO)
		{
			[self setUseUDID:NO];
		}
	}
}

-(BOOL) useExternalAppiumPackage { return self.developerMode && [_defaults boolForKey:APPIUM_PLIST_USE_EXTERNAL_APPIUM_PACKAGE]; }
-(void) setUseExternalAppiumPackage:(BOOL)useCustomAppiumPackage { [_defaults setBool:useCustomAppiumPackage forKey:APPIUM_PLIST_USE_EXTERNAL_APPIUM_PACKAGE]; }

-(BOOL) useExternalNodeJSBinary { return self.developerMode && [_defaults boolForKey:APPIUM_PLIST_USE_EXTERNAL_NODEJS_BINARY]; }
-(void) setUseExternalNodeJSBinary:(BOOL)useCustomNodeJSBinary { [_defaults setBool:useCustomNodeJSBinary forKey:APPIUM_PLIST_USE_EXTERNAL_NODEJS_BINARY]; }

-(BOOL) useInstrumentsWithoutDelay { return [_defaults boolForKey:APPIUM_PLIST_WITHOUT_DELAY]; }
-(void) setUseInstrumentsWithoutDelay:(BOOL)useInstrumentsWithoutDelay { [_defaults setBool:useInstrumentsWithoutDelay forKey:APPIUM_PLIST_WITHOUT_DELAY]; }

-(BOOL) useMobileSafari { return [_defaults boolForKey:APPIUM_PLIST_USE_MOBILE_SAFARI]; }
-(void) setUseMobileSafari:(BOOL)useMobileSafari
{
	[_defaults setBool:useMobileSafari forKey:APPIUM_PLIST_USE_MOBILE_SAFARI];
	if (useMobileSafari)
	{
		if (self.useAppPath != NO)
		{
			[self setUseAppPath:NO];
		}
		if (self.useUDID != NO)
		{
			[self setUseUDID:NO];
		}
		if (self.useBundleID != NO)
		{
			[self setUseBundleID:NO];
		}
	}
}

-(BOOL) useRemoteServer
{
	return [_defaults boolForKey:APPIUM_PLIST_USE_REMOTE_SERVER] && [self developerMode];
}
-(void) setUseRemoteServer:(BOOL)useRemoteServer
{
	[_defaults setBool:useRemoteServer forKey:APPIUM_PLIST_USE_REMOTE_SERVER];
	if (useRemoteServer)
	{
		[self killServer];
	}
	[self setIsServerListening:useRemoteServer];
}

-(BOOL) useUDID { return [_defaults boolForKey:APPIUM_PLIST_USE_UDID]; }
-(void) setUseUDID:(BOOL)useUDID
{
	[_defaults setBool:useUDID forKey:APPIUM_PLIST_USE_UDID];
	if (useUDID)
	{
		if (self.useBundleID != YES)
		{
			[self setUseBundleID:YES];
		}
		if (self.useAppPath != NO)
		{
			[self setUseAppPath:NO];
		}
		if (self.useMobileSafari != NO)
		{
			[self setUseMobileSafari:NO];
		}
	}
	else
	{
		if (self.useBundleID != NO)
		{
			[self setUseBundleID:NO];
		}
	}
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
    if ([self killServer])
    {
        return NO;
    }
    
	// build arguments
	NSString *nodeCommandString;
	if (self.useExternalAppiumPackage)
	{
		nodeCommandString = [NSString stringWithFormat:@"%@ server.js", self.externalNodeJSBinaryPath];

	}
	else
	{
		nodeCommandString = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle]resourcePath], @"node/bin/node server.js"];
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
		nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--app", [self.appPath stringByReplacingOccurrencesOfString:@" " withString:@"\\ "]];
    }
	else if (self.useBundleID)
    {
		nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--app", self.bundleID];
    }
	if (self.useUDID)
    {
		nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--udid", self.udid];
    }
	if (self.prelaunchApp && self.useAppPath)
    {
		nodeCommandString = [nodeCommandString stringByAppendingString:@" --pre-launch"];
    }
	if (!self.resetApplicationState)
    {
		nodeCommandString = [nodeCommandString stringByAppendingString:@" --no-reset"];
    }
	if (self.keepArtifacts)
    {
		nodeCommandString = [nodeCommandString stringByAppendingString:@" --keep-artifacts"];
    }
	if (self.logVerbose)
    {
		nodeCommandString = [nodeCommandString stringByAppendingString:@" --verbose"];
        
    }
    
    // iOS Prefs
    if (self.platform == Platform_iOS)
    {
        if (self.useInstrumentsWithoutDelay)
        {
			nodeCommandString = [nodeCommandString stringByAppendingString:@" --without-delay"];
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
    
    // Android Prefs
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
		if (self.fastReset)
		{
			nodeCommandString = [nodeCommandString stringByAppendingString:@" --fast-reset"];
		}
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
	while(self.isServerRunning)
	{
		sleep(1);
		NSString *output = [Utility runTaskWithBinary:@"/usr/sbin/lsof" arguments:[NSArray arrayWithObjects:@"-i", [NSString stringWithFormat:@":%@", self.port, nil], nil]];
		BOOL newValue = ([output rangeOfString:@"LISTEN"].location != NSNotFound);
		if (newValue == YES && self.isServerListening)
		{
			// sleep to avoid race condition where server is listening but not ready
			sleep(1);
		}
		[self setIsServerListening:newValue];
	}
	[self setIsServerListening:NO];
}

@end
