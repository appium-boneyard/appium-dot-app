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

-(NSString*) s_IPAddress
{
    return [[[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] mainWindowController] ipAddressTextField] stringValue];
}

-(void) setS_IPAddress:(NSString *)s_IPAddress
{
    [[[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] mainWindowController] ipAddressTextField] setStringValue:s_IPAddress];
}

-(NSNumber*) s_Port
{
    return [NSNumber numberWithInt:[[[[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] mainWindowController] portTextField] stringValue] intValue]];
}

-(void) setS_Port:(NSNumber *)s_Port
{
    [[[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] mainWindowController] portTextField] setStringValue:[s_Port stringValue]];
}

@end
