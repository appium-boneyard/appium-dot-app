//
//  AppiumAppleScriptSupport.m
//  Appium
//
//  Created by Dan Cuellar on 3/4/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumAppleScriptSupport.h"
#import "AppiumAppDelegate.h"
#import "Constants.h"

@implementation NSApplication(AppiumAppleScriptSupport)

-(NSNumber*) s_IsServerRunning
{
    return [NSNumber numberWithBool:[[[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] mainWindowController] isServerRunning] boolValue]];
}

-(NSString*) s_IPAddress
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:PLIST_SERVER_ADDRESS];
}

-(void) setS_IPAddress:(NSString *)s_IPAddress
{
	[[NSUserDefaults standardUserDefaults] setBool:[s_IPAddress boolValue] forKey:PLIST_SERVER_ADDRESS];
}

-(NSNumber*) s_Port
{
    return [NSNumber numberWithInt:[[[NSUserDefaults standardUserDefaults] stringForKey:PLIST_SERVER_PORT] intValue]];
}

-(void) setS_Port:(NSNumber *)s_Port
{
	[[NSUserDefaults standardUserDefaults] setValue:s_Port forKey:PLIST_SERVER_PORT];
}

-(NSString*) s_AppPath
{
	return [[[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] mainWindowController] appPathControl] stringValue];
}

-(void) setS_AppPath:(NSString *)s_AppPath
{
    [[[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] mainWindowController] appPathControl] setStringValue:s_AppPath];
}

-(NSNumber*) s_UseAppPath
{
    return [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:PLIST_USE_APP_PATH]];
}

-(void) setS_UseAppPath:(NSNumber *)s_UseAppPath
{
	[[NSUserDefaults standardUserDefaults] setBool:[s_UseAppPath boolValue] forKey:PLIST_USE_APP_PATH];
}

-(NSNumber*) s_UseUDID
{
    return [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:PLIST_USE_UDID]];
}

-(void) setS_UseUDID:(NSNumber *)s_UseUDID
{
	[[NSUserDefaults standardUserDefaults] setBool:[s_UseUDID boolValue] forKey:PLIST_USE_UDID];
}

-(NSString*) s_UDID
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:PLIST_UDID];
}

-(void) setS_UDID:(NSString *)s_UDID
{
    [[NSUserDefaults standardUserDefaults] setValue:s_UDID forKey:PLIST_UDID];
}

-(NSNumber*) s_PrelaunchApp
{
    return [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:PLIST_PRELAUNCH]];
}

-(void) setS_PrelaunchApp:(NSNumber *)s_PreLaunchApp
{
	[[NSUserDefaults standardUserDefaults] setBool:[s_PreLaunchApp boolValue] forKey:PLIST_PRELAUNCH];
}

-(NSNumber*) s_KeepArtifacts
{
    return [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:PLIST_KEEP_ARTIFACTS]];
}

-(void) setS_KeepArtifacts:(NSNumber *)s_KeepArtifacts
{
	[[NSUserDefaults standardUserDefaults] setBool:[s_KeepArtifacts boolValue] forKey:PLIST_KEEP_ARTIFACTS];
}

-(NSNumber*) s_UseWarp
{
    return [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:PLIST_USE_WARP]];
}

-(void) setS_UseWarp:(NSNumber *)s_UseWarp
{
	[[NSUserDefaults standardUserDefaults] setBool:[s_UseWarp boolValue] forKey:PLIST_USE_WARP];
}

-(NSNumber*) s_ResetApplicationState
{
    return [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:PLIST_RESET_APPLICATION_STATE]];
}

-(void) setS_ResetApplicationState:(NSNumber *)s_ResetApplicationState
{
	[[NSUserDefaults standardUserDefaults] setBool:[s_ResetApplicationState boolValue] forKey:PLIST_RESET_APPLICATION_STATE];
}

-(NSNumber*) s_CheckForUpdates
{
    return [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:PLIST_CHECK_FOR_UPDATES]];
}

-(void) setS_CheckForUpdates:(NSNumber *)s_CheckForUpdates
{
	[[NSUserDefaults standardUserDefaults] setBool:[s_CheckForUpdates boolValue] forKey:PLIST_CHECK_FOR_UPDATES];
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

-(void) s_ClearLog: (NSScriptCommand*)command
{
	[[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] mainWindowController] clearLog:nil];
}

@end
