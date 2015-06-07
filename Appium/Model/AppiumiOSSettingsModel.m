//
//  AppiumiOSSettingsModel.m
//  Appium
//
//  Created by Dan Cuellar on 4/23/14.
//  Copyright (c) 2014 Appium. All rights reserved.
//

#import "AppiumiOSSettingsModel.h"
#import "AppiumPreferencesFile.h"
#import "Utility.h"

@implementation AppiumiOSSettingsModel

-(NSScriptObjectSpecifier*) objectSpecifier{
	NSScriptClassDescription *containerClassDesc = (NSScriptClassDescription *)
    [NSScriptClassDescription classDescriptionForClass:[NSApp class]];
	return [[NSNameSpecifier alloc]
			initWithContainerClassDescription:containerClassDesc
			containerSpecifier:nil key:@"iOS"
			name:@"ios settings"];
}

#pragma mark - Properties

-(NSArray*) allCalendarFormats
{
	return [NSArray arrayWithObjects:@"gregorian", @"japanese", @"buddhist", nil];
}

-(NSArray*) allDevices
{
	//return [self getDevices];
	return @[@"iPhone 6"
			, @"iPhone 6 Plus"
			, @"iPhone 5s"
			, @"iPhone 5"
			, @"iPhone 4s"
			, @"iPad 2"
			, @"iPad Retina"
			, @"iPad Air"
			];
}

-(NSArray*) allLanguages
{
	return @[@"ar", @"ca", @"cs", @"da", @"de", @"el", @"en", @"en-GB", @"en-AU", @"es", @"es-MX", @"fi", @"fr", @"he", @"hr", @"hu",
			@"id", @"it", @"ja", @"ko", @"ms", @"nb", @"nl", @"pl", @"pt", @"pt-PT", @"ro", @"ru", @"sk", @"sv", @"th", @"tr", @"uk", @"vi", @"zh-Hans", @"zh-Hant"];
}

-(NSArray*) allLocales
{
	return @[@"ar_AE", @"ar_BH", @"ar_DZ", @"ar_EG", @"ar_IQ", @"ar_JO", @"ar_LB", @"ar_LY", @"ar_MA", @"ar_OM", @"ar_QA", @"ar_SA", @"ar_SY",
			@"ar_TN", @"ca_ES", @"cs_CZ", @"da_DK", @"de_AT", @"de_CH", @"de_DE", @"de_LU", @"el_CY", @"el_GR", @"en_AU", @"en_CA", @"en_GB", @"en_IE", @"en_IN",
			@"en_NZ", @"en_SG", @"en_US", @"en_ZH", @"es_AR", @"es_BO", @"es_CL", @"es_CO", @"es_CR", @"es_DO", @"es_EC", @"es_ES", @"es_GT", @"es_HN", @"es_MX",
			@"es_NI", @"es_PA", @"es_PE", @"es_PR", @"es_PY", @"es_US", @"es_UG", @"es_VE", @"fi_FI", @"fr_BE", @"fr_CA", @"fr_FR", @"fr_LU", @"fr_CS", @"he_IL",
			@"hr_HR", @"hu_HU", @"it_CH", @"it_IT", @"ja_JP", @"ko_KR", @"ms_MY", @"nb_NO", @"nl_BE", @"nl_NL", @"pl_PL", @"pt_BR", @"pt_PT", @"ro_RO", @"ru_RU",
			@"sk_SK", @"sv_SE", @"th_TH", @"tr_TR", @"uk_UA", @"vi_VN", @"zh_CN", @"zh_HK", @"zh_SG", @"zh_TW"];
}

-(NSArray*) allPlatformVersions
{
	return @[@"8.3", @"8.2", @"8.1.2", @"8.1.1", @"8.1", @"8.0.2", @"8.0", @"7.1.1", @"7.1", @"7.0.6", @"7.0.5", @"7.0.4", @"7.0.3", @"7.0.2", @"7.0.1", @"7.0", @"6.1", @"6.0"];
}

-(NSString*) appPath
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_IOS_APP_PATH];
}
-(void) setAppPath:(NSString *)appPath {
	[DEFAULTS setValue:appPath forKey:APPIUM_PLIST_IOS_APP_PATH];
}

-(BOOL) authorized
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_IOS_AUTHORIZED];
}
-(void) setAuthorized:(BOOL)authorized {
	[DEFAULTS setBool:authorized forKey:APPIUM_PLIST_IOS_AUTHORIZED];
}

-(NSNumber*) backendRetries
{
	return [NSNumber numberWithInt:[[DEFAULTS stringForKey:APPIUM_PLIST_IOS_BACKEND_RETRIES] intValue]];
}
-(void) setBackendRetries:(NSNumber *)backendRetries
{
	[DEFAULTS setValue:backendRetries forKey:APPIUM_PLIST_IOS_BACKEND_RETRIES];
}

-(NSString*) bundleID
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_IOS_BUNDLEID];
}
-(void) setBundleID:(NSString *)bundleID
{
	[DEFAULTS setValue:bundleID forKey:APPIUM_PLIST_IOS_BUNDLEID];
}

-(NSString*) calendarFormat
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_IOS_CALENDAR_FORMAT];
}
-(void) setCalendarFormat:(NSString *)calendarFormat
{
	[DEFAULTS setValue:calendarFormat forKey:APPIUM_PLIST_IOS_CALENDAR_FORMAT];
}

-(NSString*) customTraceTemplatePath
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_IOS_CUSTOM_TRACE_TEMPLATE_PATH];
}
-(void) setCustomTraceTemplatePath:(NSString *)customTraceTemplatePath
{
	[DEFAULTS setValue:customTraceTemplatePath forKey:APPIUM_PLIST_IOS_CUSTOM_TRACE_TEMPLATE_PATH];
}

-(NSString*) deviceName
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_IOS_DEVICE_NAME];
}
-(void) setDeviceName:(NSString *)deviceName
{
	[DEFAULTS setValue:deviceName forKey:APPIUM_PLIST_IOS_DEVICE_NAME];
}

-(NSString*) instrumentsBinaryPath
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_IOS_INSTRUMENTS_BINARY_PATH];
}
-(void) setInstrumentsBinaryPath:(NSString *)instrumentsBinaryPath
{
	[DEFAULTS setValue:instrumentsBinaryPath forKey:APPIUM_PLIST_IOS_INSTRUMENTS_BINARY_PATH];
}

-(BOOL) isolateSimDevice
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_IOS_ISOLATE_SIM_DEVICE];
}
-(void) setIsolateSimDevice:(BOOL)isolateSimDevice
{
	[DEFAULTS setBool:isolateSimDevice forKey:APPIUM_PLIST_IOS_ISOLATE_SIM_DEVICE];
}

-(BOOL) keepKeychains
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_IOS_KEEP_KEYCHAINS];
}
-(void) setKeepKeychains:(BOOL)keepKeychains
{
	[DEFAULTS setBool:keepKeychains forKey:APPIUM_PLIST_IOS_KEEP_KEYCHAINS];
}

-(NSString*) language
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_IOS_LANGUAGE];
}
-(void) setLanguage:(NSString *)language
{
	[DEFAULTS setValue:language forKey:APPIUM_PLIST_IOS_LANGUAGE];
}

-(NSNumber*) launchTimeout
{
	return [NSNumber numberWithInt:[[DEFAULTS stringForKey:APPIUM_PLIST_IOS_LAUNCH_TIMEOUT] intValue]];
}

-(void) setLaunchTimeout:(NSNumber *)launchTimeout
{
	[DEFAULTS setValue:launchTimeout forKey:APPIUM_PLIST_IOS_LAUNCH_TIMEOUT];
}

-(NSString*) locale
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_IOS_LOCALE];
}
-(void) setLocale:(NSString *)locale {
	[DEFAULTS setValue:locale forKey:APPIUM_PLIST_IOS_LOCALE];
}

-(NSString*) localizableStringsDirectory
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_IOS_LOCALIZABLE_STRING_DIRECTORY];
}
-(void) setLocalizableStringsDirectory:(NSString *)localizableStringsDirectory {
	[DEFAULTS setValue:localizableStringsDirectory forKey:APPIUM_PLIST_IOS_LOCALIZABLE_STRING_DIRECTORY];
}

-(BOOL) noReset
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_IOS_NO_RESET];
}
-(void) setNoReset:(BOOL)noReset
{
	if(noReset && self.fullReset)
	{
		[self setFullReset:NO];
	}
	[DEFAULTS setBool:noReset forKey:APPIUM_PLIST_IOS_NO_RESET];
}
-(BOOL) fullReset
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_IOS_FULL_RESET];
}
-(void) setFullReset:(BOOL)fullReset
{
	if(self.noReset && fullReset)
	{
		[self setNoReset:NO];
	}
	[DEFAULTS setBool:fullReset forKey:APPIUM_PLIST_IOS_FULL_RESET];
}

-(NSString*) orientation
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_IOS_ORIENTATION];
}
-(void) setOrientation:(NSString *)orientation
{
	[DEFAULTS setValue:orientation forKey:APPIUM_PLIST_IOS_ORIENTATION];
}

-(NSString*) platformVersion
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_IOS_PLATFORM_VERSION];
}
-(void) setPlatformVersion:(NSString *)platformVersion
{
	[DEFAULTS setValue:platformVersion forKey:APPIUM_PLIST_IOS_PLATFORM_VERSION];
}

-(BOOL) showSimulatorLog
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_IOS_SHOW_SIMULATOR_LOG];
}
-(void) setShowSimulatorLog:(BOOL)showSimulatorLog
{
	[DEFAULTS setBool:showSimulatorLog forKey:APPIUM_PLIST_IOS_SHOW_SIMULATOR_LOG];
}

-(BOOL) showSystemLog
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_IOS_SHOW_SYSTEM_LOG];
}
-(void) setShowSystemLog:(BOOL)showSystemLog
{
	[DEFAULTS setBool:showSystemLog forKey:APPIUM_PLIST_IOS_SHOW_SYSTEM_LOG];
}

- (NSString *)traceDirectory
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_IOS_TRACE_DIRECTORY];
}
- (void)setTraceDirectory:(NSString *)traceDirectory
{
	[DEFAULTS setValue:traceDirectory forKey:APPIUM_PLIST_IOS_TRACE_DIRECTORY];
}

-(NSString*) udid
{
	return [DEFAULTS stringForKey:APPIUM_PLIST_IOS_UDID];
}
-(void) setUdid:(NSString *)udid
{
	[DEFAULTS setValue:udid forKey:APPIUM_PLIST_IOS_UDID];
}

-(BOOL) useAppPath
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_IOS_USE_APP_PATH];
}
-(void) setUseAppPath:(BOOL)useAppPath
{
	[DEFAULTS setBool:useAppPath forKey:APPIUM_PLIST_IOS_USE_APP_PATH];
}

-(BOOL) useBackendRetries
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_IOS_USE_BACKEND_RETRIES];
}
-(void) setUseBackendRetries:(BOOL)useBackendRetries
{
	[DEFAULTS setBool:useBackendRetries forKey:APPIUM_PLIST_IOS_USE_BACKEND_RETRIES];
}

-(BOOL) useBundleID
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_IOS_USE_BUNDLEID];
}
-(void) setUseBundleID:(BOOL)useBundleID
{
	[DEFAULTS setBool:useBundleID forKey:APPIUM_PLIST_IOS_USE_BUNDLEID];
}

-(BOOL) useCalendar
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_IOS_USE_CALENDAR];
}
-(void) setUseCalendar:(BOOL)useCalendar
{
	[DEFAULTS setBool:useCalendar forKey:APPIUM_PLIST_IOS_USE_CALENDAR];
}

-(BOOL) useCustomTraceTemplate
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_IOS_USE_CUSTOM_TRACE_TEMPLATE];
}
-(void) setUseCustomTraceTemplate:(BOOL)useCustomTraceTemplate
{
	[DEFAULTS setBool:useCustomTraceTemplate forKey:APPIUM_PLIST_IOS_USE_CUSTOM_TRACE_TEMPLATE];
}

-(BOOL) useDefaultDevice
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_IOS_USE_DEFAULT_DEVICE];
}
-(void) setUseDefaultDevice:(BOOL)useDefaultDevice
{
	[DEFAULTS setBool:useDefaultDevice forKey:APPIUM_PLIST_IOS_USE_DEFAULT_DEVICE];
}

-(BOOL) useDeviceName
{
	return !self.useDefaultDevice;
}
-(void) setUseDeviceName:(BOOL)useDeviceName
{
	[self setUseDefaultDevice:!useDeviceName];
}

-(BOOL) useInstrumentsBinaryPath
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_IOS_USE_INSTRUMENTS_BINARY_PATH];
}
-(void) setUseInstrumentsBinaryPath:(BOOL)useInstrumentsBinaryPath
{
	[DEFAULTS setBool:useInstrumentsBinaryPath forKey:APPIUM_PLIST_IOS_USE_INSTRUMENTS_BINARY_PATH];
}

-(BOOL) useLanguage
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_IOS_USE_LANGUAGE];
}
-(void) setUseLanguage:(BOOL)useLanguage
{
	[DEFAULTS setBool:useLanguage forKey:APPIUM_PLIST_IOS_USE_LANGUAGE];
}

-(BOOL) useLaunchTimeout
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_IOS_USE_LAUNCH_TIMEOUT];
}
-(void) setUseLaunchTimeout:(BOOL)useLaunchTimeout
{
	[DEFAULTS setBool:useLaunchTimeout forKey:APPIUM_PLIST_IOS_USE_LAUNCH_TIMEOUT];
}

-(BOOL) useLocale
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_IOS_USE_LOCALE];
}
-(void) setUseLocale:(BOOL)useLocale
{
	[DEFAULTS setBool:useLocale forKey:APPIUM_PLIST_IOS_USE_LOCALE];
}

-(BOOL) useLocalizableStringsDirectory
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_IOS_USE_LOCALIZABLE_STRINGS_DIRECTORY];
}
-(void) setUseLocalizableStringsDirectory:(BOOL)useLocalizableStringsDirectory
{
	[DEFAULTS setBool:useLocalizableStringsDirectory forKey:APPIUM_PLIST_IOS_USE_LOCALIZABLE_STRINGS_DIRECTORY];
}

-(BOOL) useMobileSafari
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_IOS_USE_MOBILE_SAFARI];
}
-(void) setUseMobileSafari:(BOOL)useMobileSafari
{
	[DEFAULTS setBool:useMobileSafari forKey:APPIUM_PLIST_IOS_USE_MOBILE_SAFARI];
}

-(BOOL) useNativeInstrumentsLibrary
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_IOS_USE_NATIVE_INSTRUMENTS_LIBRARY];
}
-(void) setUseNativeInstrumentsLibrary:(BOOL)useNativeInstrumentsLibrary
{
	[DEFAULTS setBool:useNativeInstrumentsLibrary forKey:APPIUM_PLIST_IOS_USE_NATIVE_INSTRUMENTS_LIBRARY];
}

-(BOOL) useOrientation
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_IOS_USE_ORIENTATION];
}
-(void) setUseOrientation:(BOOL)useOrientation
{
	[DEFAULTS setBool:useOrientation forKey:APPIUM_PLIST_IOS_USE_ORIENTATION];
}

- (BOOL)useTraceDirectory
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_IOS_USE_TRACE_DIRECTORY];
}
- (void)setUseTraceDirectory:(BOOL)useTraceDirectory
{
	[DEFAULTS setBool:useTraceDirectory forKey:APPIUM_PLIST_IOS_USE_TRACE_DIRECTORY];
}

-(BOOL) useUDID
{
	return [DEFAULTS boolForKey:APPIUM_PLIST_IOS_USE_UDID];
}
-(void) setUseUDID:(BOOL)useUDID
{
	[DEFAULTS setBool:useUDID forKey:APPIUM_PLIST_IOS_USE_UDID];
}

#pragma mark - Methods

-(NSString*) xcodePath
{
	@try{
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

-(NSArray*) getDevices
{
	//@try{
		NSMutableArray *devices = [NSMutableArray new];
		NSString *deviceListString = [Utility runTaskWithBinary:@"/usr/bin/xcrun" arguments:@[@"simctl", @"list", @"devices"]];
		for (NSString* line in [deviceListString componentsSeparatedByString:@"\n"])
		{
			if ([line hasPrefix:@"    "])
			{
				NSArray *deviceNamePieces = [[line stringByReplacingOccurrencesOfString:@"    " withString:@""] componentsSeparatedByString:@")"];
				NSString *deviceName = [NSString stringWithFormat:@"%@)", [deviceNamePieces objectAtIndex:0]];
				[devices addObject:deviceName];
			}
		}
		return devices;
	//}
	//@catch (NSException *exception) {
	//	return @[];
	//}
}

@end
