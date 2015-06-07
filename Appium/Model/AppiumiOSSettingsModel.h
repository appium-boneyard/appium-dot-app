//
//  AppiumiOSSettingsModel.h
//  Appium
//
//  Created by Dan Cuellar on 4/23/14.
//  Copyright (c) 2014 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppiumiOSSettingsModel : NSObject

@property (readonly) NSArray* allCalendarFormats;
@property (readonly) NSArray* allDevices;
@property (readonly) NSArray* allLanguages;
@property (readonly) NSArray* allLocales;
@property (readonly) NSArray* allPlatformVersions;
@property NSString *appPath;
@property BOOL authorized;
@property NSNumber *backendRetries;
@property NSString *bundleID;
@property NSString *calendarFormat;
@property NSString *customTraceTemplatePath;
@property NSString *deviceName;
@property BOOL fullReset;
@property NSString *instrumentsBinaryPath;
@property BOOL isolateSimDevice;
@property BOOL keepKeychains;
@property NSString *language;
@property NSNumber *launchTimeout;
@property NSString *locale;
@property NSString *localizableStringsDirectory;
@property BOOL noReset;
@property NSString *orientation;
@property NSString *platformVersion;
@property BOOL showSystemLog;
@property BOOL showSimulatorLog;
@property NSString *traceDirectory;
@property NSString *udid;
@property BOOL useAppPath;
@property BOOL useBackendRetries;
@property BOOL useBundleID;
@property BOOL useCalendar;
@property BOOL useCustomTraceTemplate;
@property BOOL useDefaultDevice;
@property BOOL useDeviceName;
@property BOOL useInstrumentsBinaryPath;
@property BOOL useLanguage;
@property BOOL useLaunchTimeout;
@property BOOL useLocale;
@property BOOL useLocalizableStringsDirectory;
@property BOOL useMobileSafari;
@property BOOL useNativeInstrumentsLibrary;
@property BOOL useOrientation;
@property BOOL useTraceDirectory;
@property BOOL useUDID;
@property NSString *xcodePath;

@end
