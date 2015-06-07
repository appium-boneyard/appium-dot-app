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

@implementation AppiumAndroidSettingsModel

-(id) init
{
	self = [super init];
    if (self)
	{

		// initialize
		[self setAvailableAVDs:[NSArray new]];
        [self setAvailableActivities:[NSArray new]];
		[self setAvailablePackages:[NSArray new]];
		
		// update keystore path to match current user
		if ([self.keystorePath hasPrefix:@"/Users/me/"])
		{
			[self setKeystorePath:[self.keystorePath stringByReplacingOccurrencesOfString:@"/Users/me" withString:NSHomeDirectory()]];
		}
	
		// asynchronous initilizations
		[self performSelectorInBackground:@selector(refreshAVDs) withObject:nil];
		[self performSelectorInBackground:@selector(refreshAvailableActivitiesAndPackages) withObject:nil];
	}
	return self;
}

-(NSScriptObjectSpecifier*) objectSpecifier
{
	NSScriptClassDescription *containerClassDesc = (NSScriptClassDescription *)
    [NSScriptClassDescription classDescriptionForClass:[NSApp class]];
	return [[NSNameSpecifier alloc]
			initWithContainerClassDescription:containerClassDesc
			containerSpecifier:nil key:@"android"
			name:@"android settings"];
}

#pragma mark - Properties

-(NSString*) activity
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_ACTIVITY];
}
-(void) setActivity:(NSString *)activity {
	[DEFAULTS setValue:activity forKey:APPIUM_PLIST_ANDROID_ACTIVITY];
}

-(NSArray*) allAutomationNames {
	return @[@"Appium", @"Selendroid"];
}

- (NSArray*)allBrowserNames
{
	return @[@"Browser", @"Chrome", @"Chromium"];
}

-(NSArray*) allLanguages
{
	return @[@"ar", @"bg", @"ca", @"cs", @"da", @"de", @"el", @"en", @"es", @"fi", @"fr", @"he", @"hi", @"hr", @"hu", @"id", @"it", @"iw",
			@"ja", @"ko", @"li", @"lt", @"lv", @"ms", @"nb", @"nl", @"pl", @"pt", @"ro", @"ru", @"sk", @"sl", @"sr", @"sv", @"th", @"tl", @"tr", @"uk", @"vi",
			@"zh_CN", @"zh_TW"];
}

-(NSArray*) allLocales
{
	return @[@"AT", @"AU", @"BE", @"BG", @"BR", @"CA", @"CH", @"CN", @"CZ", @"DE", @"DK", @"EG", @"ES", @"FI", @"FR", @"GB", @"GR", @"HR",
			@"HU", @"ID", @"IE", @"IL", @"IN", @"JP", @"KR", @"LI", @"LT", @"LV", @"NL", @"NO", @"NZ", @"PH", @"PL", @"PT", @"RO", @"RS", @"RU", @"SE", @"SG", @"SK",
			@"TH", @"TR", @"TW", @"UA", @"US", @"VN", @"ZA"];
}

-(NSArray*) allPlatformNames
{
	return @[@"Android", @"FirefoxOS"];
}
-(NSArray*) allPlatformVersions
{
	return  @[
			  @"5.1 Lollipop (API Level 22)",
			  @"5.0.1 Lollipop (API Level 21)",
			  @"5.0 Lollipop (API Level 20)",
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
			  @"1.0 (API Level 1)"
			  ];
}

-(NSString*) automationName
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_AUTOMATION_NAME];
}
-(void) setAutomationName:(NSString *)automationName
{
	[DEFAULTS setValue:automationName forKey:APPIUM_PLIST_ANDROID_AUTOMATION_NAME];
}

-(NSString*) appPath
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_APP_PATH];
}
-(void) setAppPath:(NSString *)appPath
{
	[DEFAULTS setValue:appPath forKey:APPIUM_PLIST_ANDROID_APP_PATH];
	[self performSelectorInBackground:@selector(refreshAvailableActivitiesAndPackages) withObject:nil];
}

-(NSString*) avd
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_AVD];
}
-(void) setAvd:(NSString *)avd
{
	[DEFAULTS setValue:avd forKey:APPIUM_PLIST_ANDROID_AVD];
}

-(NSString*) avdArguments
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_AVD_ARGUMENTS];
}
-(void) setAvdArguments:(NSString *)avdArguments
{
	[DEFAULTS setValue:avdArguments forKey:APPIUM_PLIST_ANDROID_AVD_ARGUMENTS];
}

-(NSNumber*) bootstrapPort
{
	return [NSNumber numberWithInt:[[DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_BOOTSTRAP_PORT] intValue]];
}
-(void) setBootstrapPort:(NSNumber *)bootstrapPort
{
	[[NSUserDefaults standardUserDefaults] setValue:bootstrapPort forKey:APPIUM_PLIST_ANDROID_BOOTSTRAP_PORT];
}

-(NSString*) browserName
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_BROWSER_NAME];
}
-(void) setBrowserName:(NSString *)browserName
{
	[DEFAULTS setValue:browserName forKey:APPIUM_PLIST_ANDROID_BROWSER_NAME];
}

-(NSString*) chromedriverExecutablePath
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_CHROMEDRIVER_EXECUTABLE_PATH];
}
-(void) setChromedriverExecutablePath:(NSString *)chromedriverExecutablePath
{
	[DEFAULTS setValue:chromedriverExecutablePath forKey:APPIUM_PLIST_ANDROID_CHROMEDRIVER_EXECUTABLE_PATH];
}

-(NSNumber*) chromedriverPort
{
	return [NSNumber numberWithInt:[[DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_CHROMEDRIVER_PORT] intValue]];
}
-(void) setChromedriverPort:(NSNumber *)chromedriverPort
{
	[[NSUserDefaults standardUserDefaults] setValue:chromedriverPort forKey:APPIUM_PLIST_ANDROID_CHROMEDRIVER_PORT];
}

-(NSString*) coverageClass
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_COVERAGE_CLASS];
}
-(void) setCoverageClass:(NSString *)coverageClass
{
	[DEFAULTS setValue:coverageClass forKey:APPIUM_PLIST_ANDROID_COVERAGE_CLASS];
}

-(NSString*) customSDKPath
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_CUSTOM_SDK_PATH];
}
-(void) setCustomSDKPath:(NSString *)customSDKPath
{
	[DEFAULTS setValue:customSDKPath forKey:APPIUM_PLIST_ANDROID_CUSTOM_SDK_PATH];
}

-(NSString*) deviceName
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_DEVICE_NAME];
}
-(void) setDeviceName:(NSString *)deviceName
{
	[DEFAULTS setValue:deviceName forKey:APPIUM_PLIST_ANDROID_DEVICE_NAME];
}

-(NSNumber*) deviceReadyTimeout
{
	return [NSNumber numberWithInt:[[DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_DEVICE_READY_TIMEOUT] intValue]];
}
-(void) setDeviceReadyTimeout:(NSNumber *)deviceReadyTimeout
{
	[[NSUserDefaults standardUserDefaults] setValue:deviceReadyTimeout forKey:APPIUM_PLIST_ANDROID_DEVICE_READY_TIMEOUT];
}

-(BOOL) dontStopAppOnReset
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_ANDROID_DONT_STOP_APP_ON_RESET];
}
-(void) setDontStopAppOnReset:(BOOL)dontStopAppOnReset
{
	[DEFAULTS setBool:dontStopAppOnReset forKey:APPIUM_PLIST_ANDROID_DONT_STOP_APP_ON_RESET];
}

-(BOOL) fullReset
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_ANDROID_FULL_RESET];
}
-(void) setFullReset:(BOOL)fullReset
{
	if(self.noReset&&fullReset)
	{
		[self setNoReset:NO];
	}
	[DEFAULTS setBool:fullReset forKey:APPIUM_PLIST_ANDROID_FULL_RESET];
}

-(BOOL) noReset
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_ANDROID_NO_RESET];
}
-(void) setNoReset:(BOOL)noReset
{
	if(self.fullReset&&noReset)
	{
		[self setFullReset:NO];
	}
	[DEFAULTS setBool:noReset forKey:APPIUM_PLIST_ANDROID_NO_RESET];
}


-(NSString*) intentAction
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_INTENT_ACTION];
}
-(void) setIntentAction:(NSString *)intentAction
{
	[DEFAULTS setValue:intentAction forKey:APPIUM_PLIST_ANDROID_INTENT_ACTION];
}

-(NSString*) intentCategory
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_INTENT_CATEGORY];
}
-(void) setIntentCategory:(NSString *)intentCategory {
	[DEFAULTS setValue:intentCategory forKey:APPIUM_PLIST_ANDROID_INTENT_CATEGORY];
}

-(NSString*) intentFlags
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_INTENT_FLAGS];
}
-(void) setIntentFlags:(NSString *)intentFlags
{
	[DEFAULTS setValue:intentFlags forKey:APPIUM_PLIST_ANDROID_INTENT_FLAGS];
}

-(NSString*) intentArguments
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_INTENT_ARGUMENTS];
}
-(void) setIntentArguments:(NSString *)intentArguments
{
	[DEFAULTS setValue:intentArguments forKey:APPIUM_PLIST_ANDROID_INTENT_ARGUMENTS];
}

-(NSString*) keyAlias
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_KEY_ALIAS];
}
-(void) setKeyAlias:(NSString *)keyAlias
{
	[DEFAULTS setValue:keyAlias forKey:APPIUM_PLIST_ANDROID_KEY_ALIAS];
}

-(NSString*) keyPassword
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_KEY_PASSWORD];
}
-(void) setKeyPassword:(NSString *)keyPassword
{
	[DEFAULTS setValue:keyPassword forKey:APPIUM_PLIST_ANDROID_KEY_PASSWORD];
}

-(NSString*) keystorePassword
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_KEYSTORE_PASSWORD];
}
-(void) setKeystorePassword:(NSString *)keystorePassword
{
	[DEFAULTS setValue:keystorePassword forKey:APPIUM_PLIST_ANDROID_KEYSTORE_PASSWORD];
}

-(NSString*) keystorePath
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_KEYSTORE_PATH];
}
-(void) setKeystorePath:(NSString *)keystorePath
{
	[DEFAULTS setValue:keystorePath forKey:APPIUM_PLIST_ANDROID_KEYSTORE_PATH];
}

-(NSString*) language
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_LANGUAGE];
}
-(void) setLanguage:(NSString *)language
{
	[DEFAULTS setValue:language forKey:APPIUM_PLIST_ANDROID_LANGUAGE];
}

-(NSString*) locale
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_LOCALE];
}
-(void) setLocale:(NSString *)locale
{
	[DEFAULTS setValue:locale forKey:APPIUM_PLIST_ANDROID_LOCALE];
}


-(NSString*) package
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_PACKAGE];
}
-(void) setPackage:(NSString *)package
{
	[DEFAULTS setValue:package forKey:APPIUM_PLIST_ANDROID_PACKAGE];
}

-(NSString*) platformName
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_PLATFORM_NAME];
}
-(void) setPlatformName:(NSString *)platformName
{
	[DEFAULTS setValue:platformName forKey:APPIUM_PLIST_ANDROID_PLATFORM_NAME];
}

-(NSString*) platformVersion
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_PLATFORM_VERSION];
}
-(void) setPlatformVersion:(NSString *)platformVersion
{
	[DEFAULTS setValue:platformVersion forKey:APPIUM_PLIST_ANDROID_PLATFORM_VERSION];
}
-(NSString*) platformVersionNumber
{
	NSError *err;
	NSRegularExpression *platformVersionNumberRegex = [NSRegularExpression regularExpressionWithPattern:@"\\d+\\.\\d\\.?\\d?" options:NSRegularExpressionCaseInsensitive error:&err];
	NSRange rangeOfFirstMatch = [platformVersionNumberRegex rangeOfFirstMatchInString:self.platformVersion options:0 range:NSMakeRange(0, [self.platformVersion length])];
	NSString *versionNumber = @"4.4";
	if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0)))
	{
		versionNumber = [self.platformVersion substringWithRange:rangeOfFirstMatch];
	}
	return versionNumber;
}

-(NSNumber*) selendroidPort
{
	return [NSNumber numberWithInt:[[DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_SELENDROID_PORT] intValue]];
}
-(void) setSelendroidPort:(NSNumber *)selendroidPort
{
	[[NSUserDefaults standardUserDefaults] setValue:selendroidPort forKey:APPIUM_PLIST_ANDROID_SELENDROID_PORT];
}

-(BOOL) useActivity
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_ANDROID_USE_ACTIVITY];
}
-(void) setUseActivity:(BOOL)useActivity
{
	[DEFAULTS setBool:useActivity forKey:APPIUM_PLIST_ANDROID_USE_ACTIVITY];
}

-(BOOL) useAppPath
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_ANDROID_USE_APP_PATH];
}
-(void) setUseAppPath:(BOOL)useAppPath
{
	[DEFAULTS setBool:useAppPath forKey:APPIUM_PLIST_ANDROID_USE_APP_PATH];
}

-(BOOL) useAVD
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_ANDROID_USE_AVD];
}
-(void) setUseAVD:(BOOL)useAVD
{
	[DEFAULTS setBool:useAVD forKey:APPIUM_PLIST_ANDROID_USE_AVD];
}

-(BOOL) useAVDArguments
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_ANDROID_USE_AVD_ARGUMENTS];
}
-(void) setUseAVDArguments :(BOOL)useAVDArguments
{
	[DEFAULTS setBool:useAVDArguments  forKey:APPIUM_PLIST_ANDROID_USE_AVD_ARGUMENTS];
}

-(BOOL) useBoostrapPort
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_ANDROID_USE_BOOTSTRAP_PORT];
}
-(void) setUseBoostrapPort:(BOOL)useBoostrapPort
{
	[DEFAULTS setBool:useBoostrapPort forKey:APPIUM_PLIST_ANDROID_USE_BOOTSTRAP_PORT];
}

-(BOOL) useBrowser
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_ANDROID_USE_BROWSER];
}
-(void) setUseBrowser:(BOOL)useBrowser
{
	[DEFAULTS setBool:useBrowser forKey:APPIUM_PLIST_ANDROID_USE_BROWSER];
}

-(BOOL) useChromedriverExecutablePath
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_ANDROID_USE_CHROMEDRIVER_EXECUTABLE_PATH];
}
-(void) setUseChromedriverExecutablePath:(BOOL)useChromedriverExecutablePath
{
	[DEFAULTS setBool:useChromedriverExecutablePath forKey:APPIUM_PLIST_ANDROID_USE_CHROMEDRIVER_EXECUTABLE_PATH];
}

-(BOOL) useChromedriverPort
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_ANDROID_USE_CHROMEDRIVER_PORT];
}
-(void) setUseChromedriverPort:(BOOL)useChromedriverPort
{
	[DEFAULTS setBool:useChromedriverPort forKey:APPIUM_PLIST_ANDROID_USE_CHROMEDRIVER_PORT];
}

-(BOOL) useCoverageClass
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_ANDROID_USE_COVERAGE_CLASS];
}
-(void) setUseCoverageClass:(BOOL)useCoverageClass
{
	[DEFAULTS setBool:useCoverageClass forKey:APPIUM_PLIST_ANDROID_USE_COVERAGE_CLASS];
}

-(BOOL) useCustomSDKPath
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_ANDROID_USE_CUSTOM_SDK_PATH];
}
-(void) setUseCustomSDKPath:(BOOL)useCustomSDKPath
{
	[DEFAULTS setBool:useCustomSDKPath forKey:APPIUM_PLIST_ANDROID_USE_CUSTOM_SDK_PATH];
}

-(BOOL) useDeviceName
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_ANDROID_USE_DEVICE_NAME];
}
-(void) setUseDeviceName:(BOOL)useDeviceName
{
	[DEFAULTS setBool:useDeviceName forKey:APPIUM_PLIST_ANDROID_USE_DEVICE_NAME];
}

-(BOOL) useDeviceReadyTimeout
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_ANDROID_USE_DEVICE_READY_TIMEOUT];
}
-(void) setUseDeviceReadyTimeout:(BOOL)useDeviceReadyTimeout
{
	[DEFAULTS setBool:useDeviceReadyTimeout forKey:APPIUM_PLIST_ANDROID_USE_DEVICE_READY_TIMEOUT];
}

-(BOOL) useIntentAction
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_ANDROID_USE_INTENT_ACTION];
}
-(void) setUseIntentAction:(BOOL)useIntentAction
{
	[DEFAULTS setBool:useIntentAction forKey:APPIUM_PLIST_ANDROID_USE_INTENT_ACTION];
}

-(BOOL) useIntentCategory
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_ANDROID_USE_INTENT_CATEGORY];
}
-(void) setUseIntentCategory:(BOOL)useIntentCategory
{
	[DEFAULTS setBool:useIntentCategory forKey:APPIUM_PLIST_ANDROID_USE_INTENT_CATEGORY];
}

-(BOOL) useIntentFlags
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_ANDROID_USE_INTENT_FLAGS];
}
-(void) setUseIntentFlags:(BOOL)useIntentFlags
{
	[DEFAULTS setBool:useIntentFlags forKey:APPIUM_PLIST_ANDROID_USE_INTENT_FLAGS];
}

-(BOOL) useIntentArguments
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_ANDROID_USE_INTENT_ARGUMENTS];
}
-(void) setUseIntentArguments:(BOOL)useIntentArguments
{
	[DEFAULTS setBool:useIntentArguments forKey:APPIUM_PLIST_ANDROID_USE_INTENT_ARGUMENTS];
}

-(BOOL) useKeystore
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_ANDROID_USE_KEYSTORE];
}
-(void) setUseKeystore:(BOOL)useKeystore
{
	[DEFAULTS setBool:useKeystore forKey:APPIUM_PLIST_ANDROID_USE_KEYSTORE];
}

-(BOOL) useLanguage
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_ANDROID_USE_LANGUAGE];
}
-(void) setUseLanguage:(BOOL)useLanguage
{
	[DEFAULTS setBool:useLanguage forKey:APPIUM_PLIST_ANDROID_USE_LANGUAGE];
}

-(BOOL) useLocale
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_ANDROID_USE_LOCALE];
}
-(void) setUseLocale:(BOOL)useLocale
{
	[DEFAULTS setBool:useLocale forKey:APPIUM_PLIST_ANDROID_USE_LOCALE];
}

-(BOOL) usePackage
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_ANDROID_USE_PACKAGE];
}
-(void) setUsePackage:(BOOL)usePackage
{
	[DEFAULTS setBool:usePackage forKey:APPIUM_PLIST_ANDROID_USE_PACKAGE];
}

-(BOOL) useSelendroidPort
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_ANDROID_USE_SELENDROID_PORT];
}
-(void) setUseSelendroidPort:(BOOL)useSelendroidPort
{
	[DEFAULTS setBool:useSelendroidPort forKey:APPIUM_PLIST_ANDROID_USE_SELENDROID_PORT];
}

-(BOOL) useWaitActivity
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_ANDROID_USE_WAIT_ACTIVITY];
}
-(void) setUseWaitActivity:(BOOL)useWaitActivity
{
	[DEFAULTS setBool:useWaitActivity forKey:APPIUM_PLIST_ANDROID_USE_WAIT_ACTIVITY];
}

-(BOOL) useWaitPackage
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_ANDROID_USE_WAIT_PACKAGE];
}
-(void) setUseWaitPackage:(BOOL)useWaitPackage
{
	[DEFAULTS setBool:useWaitPackage forKey:APPIUM_PLIST_ANDROID_USE_WAIT_PACKAGE];
}

-(NSString*) waitActivity
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_WAIT_ACTIVITY];
}
-(void) setWaitActivity:(NSString *)waitActivity
{
	[DEFAULTS setValue:waitActivity forKey:APPIUM_PLIST_ANDROID_WAIT_ACTIVITY];
}

-(NSString*) waitPackage
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_ANDROID_WAIT_PACKAGE];
}
-(void) setWaitPackage:(NSString *)waitPackage
{
	[DEFAULTS setValue:waitPackage forKey:APPIUM_PLIST_ANDROID_WAIT_PACKAGE];
}


#pragma mark - Methods

-(void) refreshAvailableActivitiesAndPackages{
	// do not load if no app path is provided
	if (self.appPath == nil || ![[NSFileManager defaultManager] fileExistsAtPath:self.appPath]) {
		return;
	}
	
	// do not load if aapt cannot be found
    NSString *androidBinaryPath = [Utility pathToAndroidBinary:@"aapt" atSDKPath:self.useCustomSDKPath ? self.customSDKPath : nil];
	if (androidBinaryPath == nil || ![[NSFileManager defaultManager] fileExistsAtPath:androidBinaryPath])
	{
		return;
	}
	
	@try	{
		// get the xml dump from aapt
		NSString *aaptString = [Utility runTaskWithBinary:androidBinaryPath arguments:[NSArray arrayWithObjects:@"dump", @"xmltree", self.appPath, @"AndroidManifest.xml", nil]];
		
		// read line by line
		NSArray *aaptLines = [aaptString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		NSMutableArray *activities = [NSMutableArray new];
		NSMutableArray *packages = [NSMutableArray new];
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
			if (currentElementIsActivity && [line hasPrefix:@"A: android:name("]){
				NSArray *lineComponents = [line componentsSeparatedByString:@"\""];
				if (lineComponents.count >= 3)
				{
					[activities addObject:(NSString*)[lineComponents objectAtIndex:1]];
				}
			}
			
			// detect packages
			if ([line hasPrefix:@"A: package="])
			{
				NSArray *lineComponents = [line componentsSeparatedByString:@"\""];
				if (lineComponents.count >= 3)
				{
					[packages addObject:(NSString*)[lineComponents objectAtIndex:1]];
				}
			}
		}
		[self setAvailableActivities:activities];
		[self setAvailablePackages:packages];
	}
	@catch (NSException *exception)
	{
		NSLog(@"Could not list Android Activities: %@", exception);
	}
}

-(void) refreshAVDs{
	NSString *androidBinaryPath = [Utility pathToAndroidBinary:@"android" atSDKPath:self.useCustomSDKPath ? self.customSDKPath : nil];
    NSString *vBoxManagePath = [Utility pathToVBoxManageBinary];
    // have to have either "android" or "vboxmanage" available
    BOOL hasAndroid = androidBinaryPath != nil && [[NSFileManager defaultManager] fileExistsAtPath:androidBinaryPath];
    BOOL hasVBoxManage = vBoxManagePath != nil && [[NSFileManager defaultManager] fileExistsAtPath:vBoxManagePath];
	
	if ( !hasAndroid && !hasVBoxManage)
	{
		return;
	}
	
	NSMutableArray *avds = [NSMutableArray new];
	
	@try{
        // check android avd first
		if (hasAndroid)
		{
			NSString *avdString = [Utility runTaskWithBinary:androidBinaryPath arguments:[NSArray arrayWithObjects:@"list", @"avd", @"-c", nil]];
			NSArray *avdList = [avdString componentsSeparatedByString:@"\n"];
			for (NSString *avd in avdList){
				if (avd.length > 0)
				{
					[avds addObject:avd];
				}
			}
		}
		// now try genymotion
		if (hasVBoxManage)
		{
            NSString *vBoxManageString = [Utility runTaskWithBinary:vBoxManagePath arguments:[NSArray arrayWithObjects:@"list", @"vms", nil]];
            NSArray *gmList = [vBoxManageString componentsSeparatedByString:@"\n"];
            for (NSString *gm in gmList){
                NSRange startQuote = [gm rangeOfString:@"\""];
                if (startQuote.location != NSNotFound) {
                    NSRange endQuote = [gm rangeOfString:@"\"" options:NSBackwardsSearch];
                    if (endQuote.location != NSNotFound && endQuote.location > startQuote.location){
                        NSString *gmAvd = [gm substringWithRange:NSMakeRange(startQuote.location + 1, endQuote.location-1)];
                        [avds addObject:gmAvd];
                    }
                }
            }
		}
	}
	@catch (NSException *exception)
	{
		NSLog(@"Could not list Android AVDs: %@", exception);
	}
	
	[self setAvailableAVDs:avds];
	if (avds.count > 0)	{
		[self setAvd:[avds objectAtIndex:0]];
	}
}


@end
