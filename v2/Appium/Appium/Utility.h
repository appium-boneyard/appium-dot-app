//
//  Utility.h
//  Appium
//
//  Created by Dan Cuellar on 3/3/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+ (NSString*) runTaskWithBinary:(NSString*)binary arguments:(NSArray*)args path:(NSString*)path;
+ (NSString*) runTaskWithBinary:(NSString*)binary arguments:(NSArray*)args;

@end
