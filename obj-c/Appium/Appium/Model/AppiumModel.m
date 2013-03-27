//
//  AppiumModel.m
//  Appium
//
//  Created by Dan Cuellar on 3/12/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumModel.h"
#import "AppiumAppDelegate.h"

# pragma mark - Constants

#define PLIST_ANDROID_ACTIVITY @"Android Activity"
#define PLIST_ANDROID_PACKAGE @"Android Package"
#define PLIST_APP_PATH @"App Path"
#define PLIST_BUNDLEID @"BundleID"
#define PLIST_CHECK_FOR_UPDATES @"Check For Updates"
#define PLIST_DEVICE @"Device"
#define PLIST_FORCE_DEVICE @"Force Device"
#define PLIST_FORCE_DEVICE_IPAD @"iPad"
#define PLIST_FORCE_DEVICE_IPHONE @"iPhone"
#define PLIST_KEEP_ARTIFACTS @"Keep Artifacts"
#define PLIST_TAB_STATE @"Tab State"
#define PLIST_TAB_STATE_ANDROID 1
#define PLIST_TAB_STATE_IOS 0
#define PLIST_PRELAUNCH @"Prelaunch"
#define PLIST_RESET_APPLICATION_STATE @"Reset Application State"
#define PLIST_SERVER_ADDRESS @"Server Address"
#define PLIST_SERVER_PORT @"Server Port"
#define PLIST_UDID @"UDID"
#define PLIST_USE_ANDROID_ACTIVITY @"Use Android Activity"
#define PLIST_USE_ANDROID_PACKAGE @"Use Android Package"
#define PLIST_USE_APP_PATH @"Use App Path"
#define PLIST_USE_BUNDLEID @"Use BundleID"
#define PLIST_USE_MOBILE_SAFARI @"Use Mobile Safari"
#define PLIST_USE_UDID @"Use UDID"
#define PLIST_USE_WARP @"Use Warp"
#define PLIST_VERBOSE @"Verbose"
#define PLIST_WITHOUT_DELAY @"Without Delay"

#pragma  mark - Model

NSUserDefaults* _defaults;
BOOL _isServerRunning;

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
    }
    return self;
}

#pragma mark - Properties

-(NSString*) androidActivity { return [_defaults stringForKey:PLIST_ANDROID_ACTIVITY]; }
-(void) setAndroidActivity:(NSString *)androidActivity { [_defaults setValue:androidActivity forKey:PLIST_ANDROID_ACTIVITY]; }

-(NSString*) androidPackage { return [_defaults stringForKey:PLIST_ANDROID_PACKAGE]; }
-(void) setAndroidPackage:(NSString *)androidPackage { [_defaults setValue:androidPackage forKey:PLIST_ANDROID_PACKAGE]; }

-(NSString*) appPath { return [_defaults stringForKey:PLIST_APP_PATH];}
-(void) setAppPath:(NSString *)appPath { [_defaults setValue:appPath forKey:PLIST_APP_PATH]; }

-(NSString*) bundleID { return [_defaults stringForKey:PLIST_BUNDLEID]; }
-(void) setBundleID:(NSString *)bundleID { [_defaults setValue:bundleID forKey:PLIST_BUNDLEID]; }

-(BOOL) checkForUpdates { return [_defaults boolForKey:PLIST_CHECK_FOR_UPDATES]; }
-(void) setCheckForUpdates:(BOOL)checkForUpdates { [_defaults setBool:checkForUpdates forKey:PLIST_CHECK_FOR_UPDATES]; }

-(iOSAutomationDevice) deviceToForce { return [[_defaults stringForKey:PLIST_DEVICE] isEqualToString:PLIST_FORCE_DEVICE_IPAD] ? iOSAutomationDevice_iPad : iOSAutomationDevice_iPhone; }
-(void) setDeviceToForce:(iOSAutomationDevice)deviceToForce {[self setDeviceToForceString:(deviceToForce == iOSAutomationDevice_iPad ? PLIST_FORCE_DEVICE_IPAD : PLIST_FORCE_DEVICE_IPHONE)]; }
-(NSString*) deviceToForceString { return [[_defaults valueForKey:PLIST_DEVICE] isEqualToString:PLIST_FORCE_DEVICE_IPAD] ? PLIST_FORCE_DEVICE_IPAD : PLIST_FORCE_DEVICE_IPHONE ; }
-(void) setDeviceToForceString:(NSString *)deviceToForceString { [_defaults setValue:deviceToForceString forKey:PLIST_DEVICE]; }

-(BOOL) forceDevice { return [_defaults boolForKey:PLIST_FORCE_DEVICE]; }
-(void) setForceDevice:(BOOL)forceDevice { [_defaults setBool:forceDevice forKey:PLIST_FORCE_DEVICE]; }

-(BOOL) isServerRunning { return _isServerRunning; }
-(void) setIsServerRunning:(BOOL)isServerRunning { _isServerRunning = isServerRunning; }

-(NSString*) ipAddress { return [_defaults stringForKey:PLIST_SERVER_ADDRESS]; }
-(void) setIpAddress:(NSString *)ipAddress { [_defaults setValue:ipAddress forKey:PLIST_SERVER_ADDRESS]; }

-(BOOL) keepArtifacts { return [_defaults boolForKey:PLIST_KEEP_ARTIFACTS]; }
-(void) setKeepArtifacts:(BOOL)keepArtifacts { [_defaults setBool:keepArtifacts forKey:PLIST_KEEP_ARTIFACTS];}

-(BOOL) logVerbose { return [_defaults boolForKey:PLIST_VERBOSE]; }
-(void) setLogVerbose:(BOOL)logVerbose { [_defaults setBool:logVerbose forKey:PLIST_VERBOSE]; }

-(Platform)platform { return [_defaults integerForKey:PLIST_TAB_STATE] == PLIST_TAB_STATE_ANDROID ? Platform_Android : Platform_iOS; }
-(void)setPlatform:(Platform)platform { [_defaults setInteger:(platform == Platform_Android ? PLIST_TAB_STATE_ANDROID : PLIST_TAB_STATE_IOS) forKey:PLIST_TAB_STATE]; }

-(NSNumber*) port { return [NSNumber numberWithInt:[[_defaults stringForKey:PLIST_SERVER_PORT] intValue]]; }
-(void) setPort:(NSNumber *)port { [[NSUserDefaults standardUserDefaults] setValue:port forKey:PLIST_SERVER_PORT]; }

-(BOOL) prelaunchApp { return [_defaults boolForKey:PLIST_PRELAUNCH]; }
-(void) setPrelaunchApp:(BOOL)preLaunchApp { [_defaults setBool:preLaunchApp forKey:PLIST_PRELAUNCH]; }

-(BOOL) resetApplicationState { return [_defaults boolForKey:PLIST_RESET_APPLICATION_STATE]; }
-(void) setResetApplicationState:(BOOL)resetApplicationState { [_defaults setBool:resetApplicationState forKey:PLIST_RESET_APPLICATION_STATE]; }

-(NSString*) udid {return [_defaults stringForKey:PLIST_UDID];}
-(void) setUdid:(NSString *)udid { [ _defaults setValue:udid forKey:PLIST_UDID]; }

-(BOOL) useAndroidActivity { return [_defaults boolForKey:PLIST_USE_ANDROID_ACTIVITY]; }
-(void) setUseAndroidActivity:(BOOL)useAndroidActivity { [_defaults setBool:useAndroidActivity forKey:PLIST_USE_ANDROID_ACTIVITY]; }

-(BOOL) useAndroidPackage {	return [_defaults boolForKey:PLIST_USE_ANDROID_PACKAGE]; }
-(void) setUseAndroidPackage:(BOOL)useAndroidPackage { [_defaults setBool:useAndroidPackage forKey:PLIST_USE_ANDROID_PACKAGE]; }

-(BOOL) useAppPath { return [_defaults boolForKey:PLIST_USE_APP_PATH]; }
-(void) setUseAppPath:(BOOL)useAppPath { [_defaults setBool:useAppPath forKey:PLIST_USE_APP_PATH]; }

-(BOOL) useBundleID { return [_defaults boolForKey:PLIST_USE_BUNDLEID]; }
-(void) setUseBundleID:(BOOL)useBundleID { [_defaults setBool:useBundleID forKey:PLIST_USE_BUNDLEID]; }

-(BOOL) useInstrumentsWithoutDelay { return [_defaults boolForKey:PLIST_WITHOUT_DELAY]; }
-(void) setUseInstrumentsWithoutDelay:(BOOL)useInstrumentsWithoutDelay { [_defaults setBool:useInstrumentsWithoutDelay forKey:PLIST_WITHOUT_DELAY]; }

-(BOOL) useMobileSafari { return [_defaults boolForKey:PLIST_USE_MOBILE_SAFARI]; }
-(void) setUseMobileSafari:(BOOL)useMobileSafari { [_defaults setBool:useMobileSafari forKey:PLIST_USE_MOBILE_SAFARI]; }

-(BOOL) useUDID { return [_defaults boolForKey:PLIST_USE_UDID]; }
-(void) setUseUDID:(BOOL)useUDID { [_defaults setBool:useUDID forKey:PLIST_USE_UDID]; }

-(BOOL) useWarp { return [_defaults boolForKey:PLIST_USE_WARP]; }
-(void) setUseWarp:(BOOL)useWarp { [[NSUserDefaults standardUserDefaults] setBool:useWarp forKey:PLIST_USE_WARP]; }

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
    
	// get binary path
    [self setServerTask:[NSTask new]];
    [self.serverTask setCurrentDirectoryPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle]resourcePath], @"node_modules/appium"]];
    [self.serverTask setLaunchPath:@"/bin/bash"];
    
	// build arguments
	NSString *nodeCommandString = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle]resourcePath], @"node/bin/node server.js"];
	
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
	if (self.keepArtifacts)
    {
		nodeCommandString = [nodeCommandString stringByAppendingString:@" --keep-artifacts"];
    }
	if (self.logVerbose)
    {
		nodeCommandString = [nodeCommandString stringByAppendingString:@" --verbose"];
        
    }
	if (self.useWarp)
    {
		nodeCommandString = [nodeCommandString stringByAppendingString:@" --warp 1"];
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
    }
    
    // Android Prefs
    if (self.platform == Platform_Android)
    {
        if (self.useAndroidPackage)
        {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%@\"", @"app-pkg", self.androidPackage];
        }
        if (self.useAndroidActivity)
        {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%@\"", @"--app-activity", self.androidActivity];
        }
    }
    
    [self.serverTask setArguments: [NSArray arrayWithObjects: @"-l",
							   @"-c", nodeCommandString, nil]];
    
	// redirect i/o
    [self.serverTask setStandardOutput:[NSPipe pipe]];
	[self.serverTask setStandardError:[NSPipe pipe]];
    [self.serverTask setStandardInput:[NSPipe pipe]];
    
	// launch
    [self.serverTask launch];
    [self setIsServerRunning:self.serverTask.isRunning];
    return self.isServerRunning;
}

@end
