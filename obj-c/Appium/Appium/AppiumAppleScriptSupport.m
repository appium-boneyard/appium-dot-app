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
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"Server Address"];
}

-(void) setS_IPAddress:(NSString *)s_IPAddress
{
	[[NSUserDefaults standardUserDefaults] setBool:[s_IPAddress boolValue] forKey:@"Server Address"];
}

-(NSNumber*) s_Port
{
    return [NSNumber numberWithInt:[[[NSUserDefaults standardUserDefaults] stringForKey:@"Server Port"] intValue]];
}

-(void) setS_Port:(NSNumber *)s_Port
{
	[[NSUserDefaults standardUserDefaults] setValue:s_Port forKey:@"Server Port"];
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
    return [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:@"Use App Path"]];
}

-(void) setS_UseAppPath:(NSNumber *)s_UseAppPath
{
	[[NSUserDefaults standardUserDefaults] setBool:[s_UseAppPath boolValue] forKey:@"Use App Path"];
}

-(NSNumber*) s_UseUDID
{
    return [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:@"Use UDID"]];
}

-(void) setS_UseUDID:(NSNumber *)s_UseUDID
{
	[[NSUserDefaults standardUserDefaults] setBool:[s_UseUDID boolValue] forKey:@"Use UDID"];
}

-(NSString*) s_UDID
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"UDID"];
}

-(void) setS_UDID:(NSString *)s_UDID
{
    [[NSUserDefaults standardUserDefaults] setValue:s_UDID forKey:@"UDID"];
}

-(NSNumber*) s_PrelaunchApp
{
    return [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:@"Prelaunch"]];
}

-(void) setS_PrelaunchApp:(NSNumber *)s_PreLaunchApp
{
	[[NSUserDefaults standardUserDefaults] setBool:[s_PreLaunchApp boolValue] forKey:@"Prelaunch"];
}

-(NSNumber*) s_KeepArtifacts
{
    return [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:@"Keep Artifacts"]];
}

-(void) setS_KeepArtifacts:(NSNumber *)s_KeepArtifacts
{
	[[NSUserDefaults standardUserDefaults] setBool:[s_KeepArtifacts boolValue] forKey:@"Keep Artifacts"];
}

-(NSNumber*) s_UseWarp
{
    return [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:@"Use Warp"]];
}

-(void) setS_UseWarp:(NSNumber *)s_UseWarp
{
	[[NSUserDefaults standardUserDefaults] setBool:[s_UseWarp boolValue] forKey:@"Use Warp"];
}

-(NSNumber*) s_ResetApplicationState
{
    return [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:@"Reset Application State"]];
}

-(void) setS_ResetApplicationState:(NSNumber *)s_ResetApplicationState
{
	[[NSUserDefaults standardUserDefaults] setBool:[s_ResetApplicationState boolValue] forKey:@"Reset Application State"];
}

-(NSNumber*) s_CheckForUpdates
{
    return [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:@"Check For Updates"]];
}

-(void) setS_CheckForUpdates:(NSNumber *)s_CheckForUpdates
{
	[[NSUserDefaults standardUserDefaults] setBool:[s_CheckForUpdates boolValue] forKey:@"Check For Updates"];
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
