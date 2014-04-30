//
//  AppiumAndroidSettingsModel.m
//  Appium
//
//  Created by Dan Cuellar on 4/23/14.
//  Copyright (c) 2014 Appium. All rights reserved.
//

#import "AppiumAndroidSettingsModel.h"
#import "AppiumPreferencesFile.h"
#import "NSString+trimLeadingWhitespace.h"
#import "Utility.h"

NSUserDefaults* _defaults;

@implementation AppiumAndroidSettingsModel

-(id) initWithDefaults:(NSUserDefaults*)defaults {
	self = [super init];
    if (self) {

		// initialize
		_defaults = defaults;
		[self setAvailableAVDs:[NSArray new]];
        [self setAvailableActivities:[NSArray new]];
		
		// update keystore path to match current user
		if ([self.keystorePath hasPrefix:@"/Users/me/"])
		{
			[self setKeystorePath:[self.keystorePath stringByReplacingOccurrencesOfString:@"/Users/me" withString:NSHomeDirectory()]];
		}
	
		// asynchronous initilizations
		[self performSelectorInBackground:@selector(refreshAVDs) withObject:nil];
		[self performSelectorInBackground:@selector(refreshAvailableActivities) withObject:nil];
	}
	return self;
}

#pragma mark - Properties

-(NSString*) activity { return [_defaults stringForKey:APPIUM_PLIST_ANDROID_ACTIVITY]; }
-(void) setActivity:(NSString *)activity { [_defaults setValue:activity forKey:APPIUM_PLIST_ANDROID_ACTIVITY]; }

-(NSArray*) allAutomationNames { return [NSArray arrayWithObjects:@"Appium", @"Selendroid", nil]; }
-(NSArray*) allPlatformNames { return [NSArray arrayWithObjects:@"Android", @"FirefoxOS", nil]; }
-(NSArray*) allPlatformVersions { return [NSArray arrayWithObjects:
										  @"4.4 KitKat (API Level 19)",
										  @"4.3 Jelly Bean (API Level 18)",
										  @"4.2 Jelly Bean (API Level 17)",
										  @"4.1 Jelly Bean (API Level 16)",
										  @"4.0.3 Ice Cream Sandwich (API Level 15)",
										  @"4.0 Ice Cream Sandwich (API Level 14)",
										  @"3.2 Honeycomb (API Level 13)",
										  @"3.1 Honeycomb (API Level 12)",
										  @"3.0 Honeycomb (API Level 11)",
										  @"2.3.3 Gingerbread (API Level 10)",
										  @"2.3 Gingerbread (API Level 9)",
										  @"2.2 Froyo (API Level 8)",
										  @"2.1 Eclair (API Level 7)",
										  @"2.0.1 Eclair (API Level 6)",
										  @"2.0 Eclair (API Level 5)",
										  @"1.6 Donut (API Level 4)",
										  @"1.5 Cupcake (API Level 3)",
										  @"1.1 (API Level 2)",
										  @"1.0 (API Level 1)", nil]; }

-(NSString*) automationName { return [_defaults stringForKey:APPIUM_PLIST_ANDROID_AUTOMATION_NAME]; }
-(void) setAutomationName:(NSString *)automationName { [_defaults setValue:automationName forKey:APPIUM_PLIST_ANDROID_AUTOMATION_NAME]; }

-(NSString*) appPath { return [_defaults stringForKey:APPIUM_PLIST_ANDROID_APP_PATH]; }
-(void) setAppPath:(NSString *)appPath
{
	[_defaults setValue:appPath forKey:APPIUM_PLIST_ANDROID_APP_PATH];
	[self performSelectorInBackground:@selector(refreshAvailableActivities) withObject:nil];
}

-(NSString*) avd { return [_defaults stringForKey:APPIUM_PLIST_ANDROID_AVD]; }
-(void) setAvd:(NSString *)avd { [_defaults setValue:avd forKey:APPIUM_PLIST_ANDROID_AVD]; }

-(NSString*) avdArguments { return [_defaults stringForKey:APPIUM_PLIST_ANDROID_AVD_ARGUMENTS]; }
-(void) setAvdArguments:(NSString *)avdArguments { [_defaults setValue:avdArguments forKey:APPIUM_PLIST_ANDROID_AVD_ARGUMENTS]; }

-(NSNumber*) bootstrapPort { return [NSNumber numberWithInt:[[_defaults stringForKey:APPIUM_PLIST_ANDROID_BOOTSTRAP_PORT] intValue]]; }
-(void) setBootstrapPort:(NSNumber *)bootstrapPort { [[NSUserDefaults standardUserDefaults] setValue:bootstrapPort forKey:APPIUM_PLIST_ANDROID_BOOTSTRAP_PORT]; }

-(NSNumber*) chromedriverPort { return [NSNumber numberWithInt:[[_defaults stringForKey:APPIUM_PLIST_ANDROID_CHROMEDRIVER_PORT] intValue]]; }
-(void) setChromedriverPort:(NSNumber *)chromedriverPort { [[NSUserDefaults standardUserDefaults] setValue:chromedriverPort forKey:APPIUM_PLIST_ANDROID_CHROMEDRIVER_PORT]; }

-(NSString*) coverageClass { return [_defaults stringForKey:APPIUM_PLIST_ANDROID_COVERAGE_CLASS]; }
-(void) setCoverageClass:(NSString *)coverageClass { [_defaults setValue:coverageClass forKey:APPIUM_PLIST_ANDROID_COVERAGE_CLASS]; }

-(NSString*) customSDKPath { return [_defaults stringForKey:APPIUM_PLIST_ANDROID_CUSTOM_SDK_PATH]; }
-(void) setCustomSDKPath:(NSString *)customSDKPath { [_defaults setValue:customSDKPath forKey:APPIUM_PLIST_ANDROID_CUSTOM_SDK_PATH]; }

-(NSString*) deviceName { return [_defaults stringForKey:APPIUM_PLIST_ANDROID_DEVICE_NAME]; }
-(void) setDeviceName:(NSString *)deviceName { [_defaults setValue:deviceName forKey:APPIUM_PLIST_ANDROID_DEVICE_NAME]; }

-(NSNumber*) deviceReadyTimeout { return [NSNumber numberWithInt:[[_defaults stringForKey:APPIUM_PLIST_ANDROID_DEVICE_READY_TIMEOUT] intValue]]; }
-(void) setDeviceReadyTimeout:(NSNumber *)deviceReadyTimeout { [[NSUserDefaults standardUserDefaults] setValue:deviceReadyTimeout forKey:APPIUM_PLIST_ANDROID_DEVICE_READY_TIMEOUT]; }

-(BOOL) fullReset { return [_defaults boolForKey:APPIUM_PLIST_ANDROID_FULL_RESET]; }
-(void) setFullReset:(BOOL)fullReset { [_defaults setBool:fullReset forKey:APPIUM_PLIST_ANDROID_FULL_RESET]; }

-(NSString*) keyAlias { return [_defaults stringForKey:APPIUM_PLIST_ANDROID_KEY_ALIAS]; }
-(void) setKeyAlias:(NSString *)keyAlias { [_defaults setValue:keyAlias forKey:APPIUM_PLIST_ANDROID_KEY_ALIAS]; }

-(NSString*) keyPassword { return [_defaults stringForKey:APPIUM_PLIST_ANDROID_KEY_PASSWORD]; }
-(void) setKeyPassword:(NSString *)keyPassword { [_defaults setValue:keyPassword forKey:APPIUM_PLIST_ANDROID_KEY_PASSWORD]; }

-(NSString*) keystorePassword { return [_defaults stringForKey:APPIUM_PLIST_ANDROID_KEYSTORE_PASSWORD]; }
-(void) setKeystorePassword:(NSString *)keystorePassword { [_defaults setValue:keystorePassword forKey:APPIUM_PLIST_ANDROID_KEYSTORE_PASSWORD]; }

-(NSString*) keystorePath { return [_defaults stringForKey:APPIUM_PLIST_ANDROID_KEYSTORE_PATH]; }
-(void) setKeystorePath:(NSString *)keystorePath { [_defaults setValue:keystorePath forKey:APPIUM_PLIST_ANDROID_KEYSTORE_PATH]; }

-(BOOL) noReset { return [_defaults boolForKey:APPIUM_PLIST_ANDROID_NO_RESET]; }
-(void) setNoReset:(BOOL)noReset { [_defaults setBool:noReset forKey:APPIUM_PLIST_ANDROID_NO_RESET]; }

-(NSString*) package { return [_defaults stringForKey:APPIUM_PLIST_ANDROID_PACKAGE]; }
-(void) setPackage:(NSString *)package
{
	[_defaults setValue:package forKey:APPIUM_PLIST_ANDROID_PACKAGE];
	[self performSelectorInBackground:@selector(refreshAvailableActivities) withObject:nil];
}

-(NSString*) platformName { return [_defaults stringForKey:APPIUM_PLIST_ANDROID_PLATFORM_NAME]; }
-(void) setPlatformName:(NSString *)platformName { [_defaults setValue:platformName forKey:APPIUM_PLIST_ANDROID_PLATFORM_NAME]; }

-(NSString*) platformVersion { return [_defaults stringForKey:APPIUM_PLIST_ANDROID_PLATFORM_VERSION]; }
-(void) setPlatformVersion:(NSString *)platformVersion { [_defaults setValue:platformVersion forKey:APPIUM_PLIST_ANDROID_PLATFORM_VERSION]; }
-(NSString*) platformVersionNumber {
	NSError *err;
	NSRegularExpression *platformVersionNumberRegex = [NSRegularExpression regularExpressionWithPattern:@"\\d+\\.\\d\\.?\\d?" options:NSRegularExpressionCaseInsensitive error:&err];
	NSRange rangeOfFirstMatch = [platformVersionNumberRegex rangeOfFirstMatchInString:self.platformVersion options:0 range:NSMakeRange(0, [self.platformVersion length])];
	NSString *versionNumber = @"4.4";
	if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
		versionNumber = [self.platformVersion substringWithRange:rangeOfFirstMatch];
	}
	return versionNumber;
}

-(NSNumber*) selendroidPort { return [NSNumber numberWithInt:[[_defaults stringForKey:APPIUM_PLIST_ANDROID_SELENDROID_PORT] intValue]]; }
-(void) setSelendroidPort:(NSNumber *)selendroidPort { [[NSUserDefaults standardUserDefaults] setValue:selendroidPort forKey:APPIUM_PLIST_ANDROID_SELENDROID_PORT]; }

-(BOOL) useActivity { return [_defaults boolForKey:APPIUM_PLIST_ANDROID_USE_ACTIVITY]; }
-(void) setUseActivity:(BOOL)useActivity { [_defaults setBool:useActivity forKey:APPIUM_PLIST_ANDROID_USE_ACTIVITY]; }

-(BOOL) useAppPath { return [_defaults boolForKey:APPIUM_PLIST_ANDROID_USE_APP_PATH]; }
-(void) setUseAppPath:(BOOL)useAppPath { [_defaults setBool:useAppPath forKey:APPIUM_PLIST_ANDROID_USE_APP_PATH]; }

-(BOOL) useAVD { return [_defaults boolForKey:APPIUM_PLIST_ANDROID_USE_AVD]; }
-(void) setUseAVD:(BOOL)useAVD { [_defaults setBool:useAVD forKey:APPIUM_PLIST_ANDROID_USE_AVD]; }

-(BOOL) useAVDArguments { return [_defaults boolForKey:APPIUM_PLIST_ANDROID_USE_AVD_ARGUMENTS]; }
-(void) setUseAVDArguments :(BOOL)useAVDArguments  { [_defaults setBool:useAVDArguments  forKey:APPIUM_PLIST_ANDROID_USE_AVD_ARGUMENTS]; }

-(BOOL) useBoostrapPort { return [_defaults boolForKey:APPIUM_PLIST_ANDROID_USE_BOOTSTRAP_PORT]; }
-(void) setUseBoostrapPort:(BOOL)useBoostrapPort { [_defaults setBool:useBoostrapPort forKey:APPIUM_PLIST_ANDROID_USE_BOOTSTRAP_PORT]; }

-(BOOL) useBrowser { return [_defaults boolForKey:APPIUM_PLIST_ANDROID_USE_BROWSER]; }
-(void) setUseBrowser:(BOOL)useBrowser { [_defaults setBool:useBrowser forKey:APPIUM_PLIST_ANDROID_USE_BROWSER]; }

-(BOOL) useChromedriverPort { return [_defaults boolForKey:APPIUM_PLIST_ANDROID_USE_CHROMEDRIVER_PORT]; }
-(void) setUseChromedriverPort:(BOOL)useChromedriverPort { [_defaults setBool:useChromedriverPort forKey:APPIUM_PLIST_ANDROID_USE_CHROMEDRIVER_PORT]; }

-(BOOL) useCoverageClass { return [_defaults boolForKey:APPIUM_PLIST_ANDROID_USE_COVERAGE_CLASS]; }
-(void) setUseCoverageClass:(BOOL)useCoverageClass { [_defaults setBool:useCoverageClass forKey:APPIUM_PLIST_ANDROID_USE_COVERAGE_CLASS]; }

-(BOOL) useCustomSDKPath { return [_defaults boolForKey:APPIUM_PLIST_ANDROID_USE_CUSTOM_SDK_PATH]; }
-(void) setUseCustomSDKPath:(BOOL)useCustomSDKPath { [_defaults setBool:useCustomSDKPath forKey:APPIUM_PLIST_ANDROID_USE_CUSTOM_SDK_PATH]; }

-(BOOL) useDeviceReadyTimeout { return [_defaults boolForKey:APPIUM_PLIST_ANDROID_USE_DEVICE_READY_TIMEOUT]; }
-(void) setUseDeviceReadyTimeout:(BOOL)useDeviceReadyTimeout { [_defaults setBool:useDeviceReadyTimeout forKey:APPIUM_PLIST_ANDROID_USE_DEVICE_READY_TIMEOUT]; }

-(BOOL) useKeystore { return [_defaults boolForKey:APPIUM_PLIST_ANDROID_USE_KEYSTORE]; }
-(void) setUseKeystore:(BOOL)useKeystore { [_defaults setBool:useKeystore forKey:APPIUM_PLIST_ANDROID_USE_KEYSTORE]; }

-(BOOL) usePackage { return [_defaults boolForKey:APPIUM_PLIST_ANDROID_USE_PACKAGE]; }
-(void) setUsePackage:(BOOL)usePackage { [_defaults setBool:usePackage forKey:APPIUM_PLIST_ANDROID_USE_PACKAGE]; }

-(BOOL) useSelendroidPort { return [_defaults boolForKey:APPIUM_PLIST_ANDROID_USE_SELENDROID_PORT]; }
-(void) setUseSelendroidPort:(BOOL)useSelendroidPort { [_defaults setBool:useSelendroidPort forKey:APPIUM_PLIST_ANDROID_USE_SELENDROID_PORT]; }

-(BOOL) useWaitActivity { return [_defaults boolForKey:APPIUM_PLIST_ANDROID_USE_WAIT_ACTIVITY]; }
-(void) setUseWaitActivity:(BOOL)useWaitActivity { [_defaults setBool:useWaitActivity forKey:APPIUM_PLIST_ANDROID_USE_WAIT_ACTIVITY]; }

-(BOOL) useWaitPackage { return [_defaults boolForKey:APPIUM_PLIST_ANDROID_USE_WAIT_PACKAGE]; }
-(void) setUseWaitPackage:(BOOL)useWaitPackage { [_defaults setBool:useWaitPackage forKey:APPIUM_PLIST_ANDROID_USE_WAIT_PACKAGE]; }

-(NSString*) waitActivity { return [_defaults stringForKey:APPIUM_PLIST_ANDROID_WAIT_ACTIVITY]; }
-(void) setWaitActivity:(NSString *)waitActivity { [_defaults setValue:waitActivity forKey:APPIUM_PLIST_ANDROID_WAIT_ACTIVITY]; }

-(NSString*) waitPackage{ return [_defaults stringForKey:APPIUM_PLIST_ANDROID_WAIT_PACKAGE]; }
-(void) setWaitPackage:(NSString *)waitPackage { [_defaults setValue:waitPackage forKey:APPIUM_PLIST_ANDROID_WAIT_PACKAGE]; }


#pragma mark - Methods

-(void) refreshAvailableActivities
{
    NSString *androidBinaryPath = [Utility pathToAndroidBinary:@"aapt" atSDKPath:self.useCustomSDKPath ? self.customSDKPath : nil];
	
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
	NSString *androidBinaryPath = [Utility pathToAndroidBinary:@"android" atSDKPath:self.useCustomSDKPath ? self.customSDKPath : nil];
	
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
