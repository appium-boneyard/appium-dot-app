//
//  AppiumAndroidSettingsModel.h
//  Appium
//
//  Created by Dan Cuellar on 4/23/14.
//  Copyright (c) 2014 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppiumAndroidSettingsModel : NSObject

@property NSString *activity;
@property (readonly) NSArray *allAutomationNames;
@property (readonly) NSArray *allBrowserNames;
@property (readonly) NSArray *allLanguages;
@property (readonly) NSArray *allLocales;
@property (readonly) NSArray *allPlatformNames;
@property (readonly) NSArray *allPlatformVersions;
@property NSString *appPath;
@property NSString *automationName;
@property NSArray *availableActivities;
@property NSArray *availablePackages;
@property NSArray *availableAVDs;
@property NSString *avd;
@property NSString *avdArguments;
@property NSNumber *bootstrapPort;
@property NSString *browserName;
@property NSString *chromedriverExecutablePath;
@property NSNumber *chromedriverPort;
@property NSString *coverageClass;
@property NSString *customSDKPath;
@property NSString *deviceName;
@property NSNumber *deviceReadyTimeout;
@property BOOL dontStopAppOnReset;
@property BOOL fullReset;
@property NSString *intentAction;
@property NSString *intentCategory;
@property NSString *intentFlags;
@property NSString *intentArguments;
@property NSString *keyAlias;
@property NSString *keyPassword;
@property NSString *keystorePassword;
@property NSString *keystorePath;
@property NSString *language;
@property NSString *locale;
@property BOOL noReset;
@property NSString *package;
@property NSString *platformName;
@property NSString *platformVersion;
@property (readonly) NSString *platformVersionNumber;
@property NSNumber *selendroidPort;
@property BOOL useActivity;
@property BOOL useAppPath;
@property BOOL useAVD;
@property BOOL useAVDArguments;
@property BOOL useBootstrapPort;
@property BOOL useBrowser;
@property BOOL useChromedriverExecutablePath;
@property BOOL useChromedriverPort;
@property BOOL useCoverageClass;
@property BOOL useCustomSDKPath;
@property BOOL useDeviceName;
@property BOOL useDeviceReadyTimeout;
@property BOOL useIntentAction;
@property BOOL useIntentCategory;
@property BOOL useIntentFlags;
@property BOOL useIntentArguments;
@property BOOL useKeystore;
@property BOOL useLanguage;
@property BOOL useLocale;
@property BOOL usePackage;
@property BOOL useSelendroidPort;
@property BOOL useWaitActivity;
@property BOOL useWaitPackage;
@property NSString *waitActivity;
@property NSString *waitPackage;

-(void) refreshAvailableActivitiesAndPackages;
-(void) refreshAVDs;

@end
