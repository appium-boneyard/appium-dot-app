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

-(NSString*) s_AppPath
{
    return [[[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] mainWindowController] appPathTextField] stringValue];
}

-(void) setS_AppPath:(NSString *)s_AppPath
{
    [[[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] mainWindowController] appPathTextField] setStringValue:s_AppPath];
}

-(NSNumber*) s_UseAppPath
{
    BOOL value = [[[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] mainWindowController] appPathCheckBox] state] == NSOnState;
    return [NSNumber numberWithBool:value];
}

-(void) setS_UseAppPath:(NSNumber *)s_AppPath
{
    NSInteger newState = [s_AppPath boolValue] ? NSOnState : NSOffState;
    [[[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] mainWindowController] appPathCheckBox] setState:newState];
}

-(NSString*) s_LogText
{
    return [[[[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] mainWindowController] logTextView] textStorage] string];
}

- (NSNumber*) s_StartServer: (NSScriptCommand*)command
{
    if ([[self s_IsServerRunning] boolValue])
        return [NSNumber numberWithBool:NO];
    [[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] mainWindowController] launchButtonClicked:nil];
    return [NSNumber numberWithBool:YES];
    
}
- (NSNumber*) s_StopServer: (NSScriptCommand*)command
{
    if (![[self s_IsServerRunning] boolValue])
        return [NSNumber numberWithBool:NO];
    [[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] mainWindowController] launchButtonClicked:nil];
    return [NSNumber numberWithBool:YES];
}

@end
