//
//  AppiumRobotSettings.h
//  Appium
//
//  Created by Dan Cuellar on 5/13/14.
//  Copyright (c) 2014 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppiumRobotSettingsModel : NSObject

@property NSString *robotAddress;
@property NSNumber *robotPort;
@property BOOL useRobot;

@end
