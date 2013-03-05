//
//  AppiumAppleScriptSupport.m
//  Appium
//
//  Created by Dan Cuellar on 3/4/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumAppleScriptSupport.h"
#import "AppiumAppDelegate.h"


@implementation NSApplication(AppiumAppleScriptSupport)

-(NSNumber*) s_IsServerRunning
{
    return [NSNumber numberWithBool:[[[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] mainWindowController] isServerRunning] boolValue]];
}

@end
