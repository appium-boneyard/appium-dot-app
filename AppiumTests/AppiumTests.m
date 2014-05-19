//
//  AppiumTests.m
//  AppiumTests
//
//  Created by Dan Cuellar on 3/3/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumTests.h"
#import "Appium.h"
#import "SystemEvents.h"

AppiumApplication *Appium;
SystemEventsApplication *SystemEvents;

@implementation AppiumTests

- (void)setUp
{
    [super setUp];
    SystemEvents = [SBApplication applicationWithBundleIdentifier:@"com.apple.systemevents"];
    Appium = [SBApplication applicationWithBundleIdentifier:@"com.appium.Appium"];
    [Appium activate];
    
    NSLog(@"Waiting up to 30 seconds for Appium.app to launch");
    NSDate *startTime = [NSDate date];
    BOOL processLaunched = NO;
    while ([[NSDate date] timeIntervalSinceDate:startTime] < 30 && !processLaunched)
    {
        SBElementArray *processes = [SystemEvents processes];
        for (int i=0; i < processes.count; i++)
        {
            SystemEventsProcess *process = (SystemEventsProcess*)[processes objectAtIndex:i];
            if ([[process name] isEqualToString:@"Appium"])
            {
                processLaunched = YES;
                break;
            }
        }
    }
    NSLog(@"Appium has launched. Tests will begin.");
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testNotRunningUponLaunch {
    XCTAssertEqual([Appium isServerRunning], NO, @"Verifying Appium server is not running on launch.");
}

- (void)testPlatformToggle {
	[Appium resetPreferences];
	[Appium usePlatform:AppiumPlatformSettingIos];
	XCTAssert([Appium.platform isEqualToString:@"iOS"], @"Verifying platform was set to iOS");
	[Appium usePlatform:AppiumPlatformSettingAndroid];
	XCTAssert([Appium.platform isEqualToString:@"Android"], @"Verifying platform was set to Android");
	[Appium usePlatform:AppiumPlatformSettingIos];
	XCTAssert([Appium.platform isEqualToString:@"iOS"], @"Verifying platform was set back to iOS");
}

@end
