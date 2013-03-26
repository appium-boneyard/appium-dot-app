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

@property NSString *androidActivity;
@property NSString *androidPackage;
@property NSString *appPath;
@property NSString *bundleID;
@property BOOL checkForUpdates;
@property iOSAutomationDevice deviceToForce;
@property NSString *deviceToForceString;
@property BOOL forceDevice;
@property BOOL isServerRunning;
@property NSString *ipAddress;
@property BOOL keepArtifacts;
@property BOOL logVerbose;
@property Platform platform;
@property NSNumber *port;
@property BOOL prelaunchApp;
@property BOOL resetApplicationState;
@property NSString *udid;
@property BOOL useAndroidActivity;
@property BOOL useAndroidPackage;
@property BOOL useAppPath;
@property BOOL useBundleID;
@property BOOL useInstrumentsWithoutDelay;
@property BOOL useMobileSafari;
@property BOOL useUDID;
@property BOOL useWarp;

@end
