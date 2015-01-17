//
//  AppiumModel.h
//  Appium
//
//  Created by Dan Cuellar on 3/12/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppiumAndroidSettingsModel.h"
#import "AppiumiOSSettingsModel.h"
#import "AppiumDeveloperSettingsModel.h"
#import "AppiumGeneralSettingsModel.h"
#import "AppiumRobotSettingsModel.h"
#import "SocketIO.h"

typedef enum platformTypes
{
	AppiumiOSPlatform,
	AppiumAndroidPlatform
} AppiumPlatform;

@class SocketIO;

@interface AppiumModel : NSObject<SocketIODelegate>

@property NSTask *serverTask;

@property AppiumAndroidSettingsModel *android;
@property AppiumDeveloperSettingsModel *developer;
@property AppiumGeneralSettingsModel *general;
@property AppiumiOSSettingsModel *iOS;
@property AppiumRobotSettingsModel *robot;

@property SocketIO *doctorSocket;
@property BOOL doctorSocketIsConnected;
@property BOOL isAndroid;
@property BOOL isIOS;
@property BOOL isServerRunning;
@property BOOL isServerListening;
@property AppiumPlatform platform;

@property NSInteger maxLogLength;

-(BOOL) killServer;
-(BOOL) startServer;
-(BOOL) startDoctor;
-(void) startExternalDoctor;
-(void) reset;
-(BOOL) resetWithFile:(NSString*)prefsPath;
-(void) setupServerTask:(NSString *)commandString;

@end
