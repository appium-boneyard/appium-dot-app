//
//  AppiumModel.m
//  Appium
//
//  Created by Dan Cuellar on 3/12/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumModel.h"
#import "AppiumAppDelegate.h"

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
#define PLIST_SKIP_ANDROID_INSTALL @"Skip Android Install"
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

-(BOOL) isServerRunning { return _isServerRunning; }
-(void) setIsServerRunning:(BOOL)isServerRunning { _isServerRunning = isServerRunning; }

-(NSString*) ipAddress { return [_defaults stringForKey:PLIST_SERVER_ADDRESS]; }
-(void) setIpAddress:(NSString *)ipAddress { [_defaults setValue:ipAddress forKey:PLIST_SERVER_ADDRESS]; }

-(NSNumber*) port { return [NSNumber numberWithInt:[[_defaults stringForKey:PLIST_SERVER_PORT] intValue]]; }
-(void) setPort:(NSNumber *)port { [[NSUserDefaults standardUserDefaults] setValue:port forKey:PLIST_SERVER_PORT]; }

-(NSString*) appPath { return [_defaults stringForKey:PLIST_APP_PATH];}
-(void) setAppPath:(NSString *)appPath { [_defaults setValue:appPath forKey:PLIST_APP_PATH]; }
-(BOOL) useAppPath { return [_defaults boolForKey:PLIST_USE_APP_PATH]; }
-(void) setUseAppPath:(BOOL)useAppPath { [_defaults setBool:useAppPath forKey:PLIST_USE_APP_PATH]; }

-(BOOL) useUDID { return [_defaults boolForKey:PLIST_USE_UDID]; }
-(void) setUseUDID:(BOOL)useUDID { [_defaults setBool:useUDID forKey:PLIST_USE_UDID]; }
-(NSString*) udid {return [_defaults stringForKey:PLIST_UDID];}
-(void) setUdid:(NSString *)udid { [ _defaults setValue:udid forKey:PLIST_UDID]; }

-(BOOL) useAndroidPackage {	return [_defaults boolForKey:PLIST_USE_ANDROID_PACKAGE]; }
-(void) setUseAndroidPackage:(BOOL)useAndroidPackage { [_defaults setBool:useAndroidPackage forKey:PLIST_USE_ANDROID_PACKAGE]; }
-(NSString*) androidPackage { return [_defaults stringForKey:PLIST_ANDROID_PACKAGE]; }
-(void) setAndroidPackage:(NSString *)androidPackage { [_defaults setValue:androidPackage forKey:PLIST_ANDROID_PACKAGE]; }

-(BOOL) useAndroidActivity { return [_defaults boolForKey:PLIST_USE_ANDROID_ACTIVITY]; }
-(void) setUseAndroidActivity:(BOOL)useAndroidActivity { [_defaults setBool:useAndroidActivity forKey:PLIST_USE_ANDROID_ACTIVITY]; }
-(NSString*) androidActivity { return [_defaults stringForKey:PLIST_ANDROID_ACTIVITY]; }
-(void) setAndroidActivity:(NSString *)androidActivity { [_defaults setValue:androidActivity forKey:PLIST_ANDROID_ACTIVITY]; }

-(BOOL) skipAndroidInstall { return [_defaults boolForKey:PLIST_SKIP_ANDROID_INSTALL]; }
-(void) setSkipAndroidInstall:(BOOL)skipAndroidInstall { [_defaults setBool:skipAndroidInstall forKey:PLIST_SKIP_ANDROID_INSTALL]; }

-(BOOL) prelaunchApp { return [_defaults boolForKey:PLIST_PRELAUNCH]; }
-(void) setPrelaunchApp:(BOOL)preLaunchApp { [_defaults setBool:preLaunchApp forKey:PLIST_PRELAUNCH]; }

-(BOOL) keepArtifacts { return [_defaults boolForKey:PLIST_KEEP_ARTIFACTS]; }
-(void) setKeepArtifacts:(BOOL)keepArtifacts { [_defaults setBool:keepArtifacts forKey:PLIST_KEEP_ARTIFACTS];}

-(BOOL) useWarp { return [_defaults boolForKey:PLIST_USE_WARP]; }
-(void) setUseWarp:(BOOL)useWarp { [[NSUserDefaults standardUserDefaults] setBool:useWarp forKey:PLIST_USE_WARP]; }

-(BOOL) useInstrumentsWithoutDelay { return [_defaults boolForKey:PLIST_WITHOUT_DELAY]; }
-(void) setUseInstrumentsWithoutDelay:(BOOL)useInstrumentsWithoutDelay { [_defaults setBool:useInstrumentsWithoutDelay forKey:PLIST_WITHOUT_DELAY]; }

-(BOOL) resetApplicationState { return [_defaults boolForKey:PLIST_RESET_APPLICATION_STATE]; }
-(void) setResetApplicationState:(BOOL)resetApplicationState { [_defaults setBool:resetApplicationState forKey:PLIST_RESET_APPLICATION_STATE]; }

-(BOOL) checkForUpdates { return [_defaults boolForKey:PLIST_CHECK_FOR_UPDATES]; }
-(void) setCheckForUpdates:(BOOL)checkForUpdates { [_defaults setBool:checkForUpdates forKey:PLIST_CHECK_FOR_UPDATES]; }

-(BOOL) logVerbose { return [_defaults boolForKey:PLIST_VERBOSE]; }
-(void) setLogVerbose:(BOOL)logVerbose { [_defaults setBool:logVerbose forKey:PLIST_VERBOSE]; }

-(BOOL) useBundleID { return [_defaults boolForKey:PLIST_USE_BUNDLEID]; }
-(void) setUseBundleID:(BOOL)useBundleID { [_defaults setBool:useBundleID forKey:PLIST_USE_BUNDLEID]; }

-(NSString*) bundleID { return [_defaults stringForKey:PLIST_BUNDLEID]; }
-(void) setBundleID:(NSString *)bundleID { [_defaults setValue:bundleID forKey:PLIST_BUNDLEID]; }

-(BOOL) useMobileSafari { return [_defaults boolForKey:PLIST_USE_MOBILE_SAFARI]; }
-(void) setUseMobileSafari:(BOOL)useMobileSafari { [_defaults setBool:useMobileSafari forKey:PLIST_USE_MOBILE_SAFARI]; }

-(BOOL) forceDevice { return [_defaults boolForKey:PLIST_FORCE_DEVICE]; }
-(void) setForceDevice:(BOOL)forceDevice { [_defaults setBool:forceDevice forKey:PLIST_FORCE_DEVICE]; }

-(iOSAutomationDevice) deviceToForce { return [[_defaults stringForKey:PLIST_DEVICE] isEqualToString:PLIST_FORCE_DEVICE_IPAD] ? iOSAutomationDevice_iPad : iOSAutomationDevice_iPhone; }
-(void) setDeviceToForce:(iOSAutomationDevice)deviceToForce {[self setDeviceToForceString:(deviceToForce == iOSAutomationDevice_iPad ? PLIST_FORCE_DEVICE_IPAD : PLIST_FORCE_DEVICE_IPHONE)]; }
-(NSString*) deviceToForceString { return [[_defaults valueForKey:PLIST_DEVICE] isEqualToString:PLIST_FORCE_DEVICE_IPAD] ? PLIST_FORCE_DEVICE_IPAD : PLIST_FORCE_DEVICE_IPHONE ; }
-(void) setDeviceToForceString:(NSString *)deviceToForceString { [_defaults setValue:deviceToForceString forKey:PLIST_DEVICE]; }

-(Platform)platform { return [_defaults integerForKey:PLIST_TAB_STATE] == PLIST_TAB_STATE_ANDROID ? Platform_Android : Platform_iOS; }
-(void)setPlatform:(Platform)platform { [_defaults setInteger:(platform == Platform_Android ? PLIST_TAB_STATE_ANDROID : PLIST_TAB_STATE_IOS) forKey:PLIST_TAB_STATE]; }

@end
