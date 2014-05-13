//
//  AppiumRobotSettings.m
//  Appium
//
//  Created by Dan Cuellar on 5/13/14.
//  Copyright (c) 2014 Appium. All rights reserved.
//

#import "AppiumRobotSettingsModel.h"
#import "AppiumPreferencesFile.h"

@implementation AppiumRobotSettingsModel

-(NSScriptObjectSpecifier*) objectSpecifier
{
	NSScriptClassDescription *containerClassDesc = (NSScriptClassDescription *)
    [NSScriptClassDescription classDescriptionForClass:[NSApp class]];
	return [[NSNameSpecifier alloc]
			initWithContainerClassDescription:containerClassDesc
			containerSpecifier:nil key:@"robot"
			name:@"robot settings"];
}


-(NSString*) robotAddress { return [DEFAULTS stringForKey:APPIUM_PLIST_ROBOT_ADDRESS]; }
-(void) setRobotAddress:(NSString *)robotAddress { [DEFAULTS setValue:robotAddress forKey:APPIUM_PLIST_ROBOT_ADDRESS]; }

-(NSNumber*) robotPort { return [NSNumber numberWithInt:[[DEFAULTS stringForKey:APPIUM_PLIST_ROBOT_PORT] intValue]]; }
-(void) setRobotPort:(NSNumber *)robotPort { [DEFAULTS setValue:robotPort forKey:APPIUM_PLIST_ROBOT_PORT]; }

-(BOOL) useRobot { return [DEFAULTS boolForKey:APPIUM_PLIST_USE_ROBOT]; }
-(void) setUseRobot:(BOOL)useRobot { [DEFAULTS setBool:useRobot forKey:APPIUM_PLIST_USE_ROBOT]; }

@end
