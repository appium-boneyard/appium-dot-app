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

typedef enum iOSOrientationTypes
{
	iOSOrientation_Portrait,
	iOSOrientation_Landscape
} iOSOrientation;

@interface AppiumModel : NSObject

@property NSTask *serverTask;

@property NSString *androidActivity;
@property NSNumber *androidDeviceReadyTimeout;
@property NSString *androidPackage;
@property NSString *androidWaitActivity;
@property NSString *appPath;
@property NSArray *availableAVDs;
@property NSString *avd;
@property NSString *bundleID;
@property BOOL checkForUpdates;
@property NSString *externalAppiumPackagePath;
@property NSString *externalNodeJSBinaryPath;
@property BOOL developerMode;
@property iOSAutomationDevice deviceToForce;
@property NSString *deviceToForceString;
@property BOOL fastReset;
@property BOOL forceDevice;
@property BOOL forceOrientation;
@property BOOL isServerRunning;
@property BOOL isServerListening;
@property NSString *ipAddress;
@property BOOL keepArtifacts;
@property BOOL logVerbose;
@property iOSOrientation orientationToForce;
@property NSString* orientationToForceString;
@property Platform platform;
@property NSNumber *port;
@property BOOL prelaunchApp;
@property BOOL resetApplicationState;
@property NSString *udid;
@property BOOL useAndroidActivity;
@property BOOL useAndroidDeviceReadyTimeout;
@property BOOL useAndroidPackage;
@property BOOL useAndroidWaitActivity;
@property BOOL useAppPath;
@property BOOL useAVD;
@property BOOL useBundleID;
@property BOOL useExternalAppiumPackage;
@property BOOL useExternalNodeJSBinary;
@property BOOL useInstrumentsWithoutDelay;
@property BOOL useMobileSafari;
@property BOOL useRemoteServer;
@property BOOL useUDID;

-(BOOL)killServer;
-(BOOL)startServer;

@end
