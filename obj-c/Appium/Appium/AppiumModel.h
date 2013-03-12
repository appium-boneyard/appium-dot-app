//
//  AppiumModel.h
//  Appium
//
//  Created by Dan Cuellar on 3/12/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum platformTypes
{
	Platform_iOS,
	Platform_Android
} Platform;

typedef enum iOSAutomationDeviceTypes
{
	iOSAutomationDevice_iPhone,
	iOSAutomationDevice_iPad
} iOSAutomationDevice;


@interface AppiumModel : NSObject

@property BOOL isServerRunning;
@property NSString *ipAddress;
@property NSNumber *port;
@property BOOL useAppPath;
@property NSString *appPath;
@property BOOL useUDID;
@property NSString *udid;
@property BOOL useAndroidPackage;
@property NSString *androidPackage;
@property BOOL useAndroidActivity;
@property NSString *androidActivity;
@property BOOL skipAndroidInstall;
@property BOOL prelaunchApp;
@property BOOL keepArtifacts;
@property BOOL useInstrumentsWithoutDelay;
@property BOOL useWarp;
@property BOOL resetApplicationState;
@property BOOL checkForUpdates;
@property BOOL logVerbose;
@property BOOL forceDevice;
@property BOOL useBundleID;
@property NSString *bundleID;
@property BOOL useMobileSafari;
@property iOSAutomationDevice deviceToForce;
@property Platform platform;

@end
