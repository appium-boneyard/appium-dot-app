//
//  AppiumDeveloperSettingsModel.h
//  Appium
//
//  Created by Dan Cuellar on 5/13/14.
//  Copyright (c) 2014 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppiumDeveloperSettingsModel : NSObject

@property BOOL breakOnNodeApplicationStart;
@property NSString *customFlags;
@property BOOL developerMode;
@property NSString *externalAppiumPackagePath;
@property NSString *externalNodeJSBinaryPath;
@property NSNumber *nodeJSDebugPort;
@property BOOL useCustomFlags;
@property BOOL useExternalAppiumPackage;
@property BOOL useExternalNodeJSBinary;
@property BOOL useNodeDebugging;

@end
