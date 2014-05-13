//
//  Utility.h
//  Appium
//
//  Created by Dan Cuellar on 3/3/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+(NSString*) pathToAndroidBinary:(NSString*)binaryName atSDKPath:(NSString*)sdkPath;
+(NSString*) runTaskWithBinary:(NSString*)binary arguments:(NSArray*)args path:(NSString*)path;
+(NSString*) runTaskWithBinary:(NSString*)binary arguments:(NSArray*)args;
+(NSNumber*) getPidListeningOnPort:(NSNumber*)port;
+(NSString*) pathToVBoxManageBinary;

@end
