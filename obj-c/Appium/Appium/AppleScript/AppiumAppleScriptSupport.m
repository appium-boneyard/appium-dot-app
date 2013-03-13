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

-(AppiumModel*) model { return [(AppiumAppDelegate*)[self delegate] model]; }

# pragma mark - Properties

-(NSNumber*) s_IsServerRunning { return [NSNumber numberWithBool:[[self model] isServerRunning]]; }

-(NSString*) s_IPAddress { return [[self model] ipAddress]; }
-(void) setS_IPAddress:(NSString *)s_IPAddress { [[self model] setIpAddress:s_IPAddress]; }

-(NSNumber*) s_Port { return [NSNumber numberWithInt:[[[self model] port] intValue]]; }
-(void) setS_Port:(NSNumber *)s_Port { [[self model] setPort:s_Port]; }

-(NSString*) s_AppPath { return [[self model] appPath]; }
-(void) setS_AppPath:(NSString *)s_AppPath { [[self model] setAppPath:s_AppPath]; }

-(NSNumber*) s_UseAppPath { return [NSNumber numberWithBool:[[self model] useAppPath]]; }
-(void) setS_UseAppPath:(NSNumber *)s_UseAppPath { [[self model] setUseAppPath:[s_UseAppPath boolValue]]; }

-(NSNumber*) s_UseUDID { return [NSNumber numberWithBool:[[self model] useUDID]]; }
-(void) setS_UseUDID:(NSNumber *)s_UseUDID { [[self model] setUseUDID:[s_UseUDID boolValue]]; }

-(NSString*) s_UDID { return [[self model] udid]; }
-(void) setS_UDID:(NSString *)s_UDID { [[self model] setUdid:s_UDID]; }

-(NSNumber*) s_UseAndroidPackage { return [NSNumber numberWithBool:[[self model] useAndroidPackage]]; }
-(void) setS_UseAndroidPackage:(NSNumber *)s_UseAndroidPackage { [[self model] setUseAndroidPackage:[s_UseAndroidPackage boolValue]]; }

-(NSString*) s_AndroidPackage { return [[self model] androidPackage]; }
-(void) setS_AndroidPackage:(NSString *)s_AndroidPackage { [[self model] setAndroidPackage:s_AndroidPackage]; }

-(NSNumber*) s_UseAndroidActivity { return [NSNumber numberWithBool:[[self model] useAndroidActivity]]; }
-(void) setS_UseAndroidActivity:(NSNumber *)s_UseAndroidActivity { [[self model] setUseAndroidActivity:[s_UseAndroidActivity boolValue]]; }

-(NSString*) s_AndroidActivity { return [[self model] androidActivity]; }
-(void) setS_AndroidActivity:(NSString *)s_AndroidActivity { [[self model] setAndroidActivity:s_AndroidActivity]; }

-(NSNumber*) s_SkipAndroidInstall {	return [NSNumber numberWithBool:[[self model] skipAndroidInstall]]; }
-(void) setS_SkipAndroidInstall:(NSNumber *)s_SkipAndroidInstall{ [[self model] setSkipAndroidInstall:[s_SkipAndroidInstall boolValue]]; }

-(NSNumber*) s_PrelaunchApp { return [NSNumber numberWithBool:[[self model] prelaunchApp]]; }
-(void) setS_PrelaunchApp:(NSNumber *)s_PreLaunchApp { [[self model] setPrelaunchApp:[s_PreLaunchApp boolValue]]; }

-(NSNumber*) s_KeepArtifacts { return [NSNumber numberWithBool:[[self model] keepArtifacts]]; }
-(void) setS_KeepArtifacts:(NSNumber *)s_KeepArtifacts{	[[self model] setKeepArtifacts:[s_KeepArtifacts boolValue]]; }

-(NSNumber*) s_UseWarp { return [NSNumber numberWithBool:[[self model] useWarp]]; }
-(void) setS_UseWarp:(NSNumber *)s_UseWarp { [[self model] setUseWarp:[s_UseWarp boolValue]]; }

-(NSNumber*) s_UseInstrumentsWithoutDelay { return [NSNumber numberWithBool:[[self model] useInstrumentsWithoutDelay]]; }
-(void) setS_UseInstrumentsWithoutDelay:(NSNumber *)s_UseInstrumentsWithoutDelay { [[self model] setUseInstrumentsWithoutDelay:[s_UseInstrumentsWithoutDelay boolValue]]; }

-(NSNumber*) s_ResetApplicationState { return [NSNumber numberWithBool:[[self model] resetApplicationState]]; }
-(void) setS_ResetApplicationState:(NSNumber *)s_ResetApplicationState{	[[self model] setResetApplicationState:[s_ResetApplicationState boolValue]]; }

-(NSNumber*) s_CheckForUpdates { return [NSNumber numberWithBool:[[self model] checkForUpdates]]; }
-(void) setS_CheckForUpdates:(NSNumber *)s_CheckForUpdates { [[self model] setCheckForUpdates:[s_CheckForUpdates boolValue]]; }

-(NSString*) s_BundleID { return [[self model] bundleID];}
-(void) setS_BundleID:(NSString *)s_BundleID { [[self model] setBundleID:s_BundleID]; }

-(NSNumber*) s_UseBundleID { return [NSNumber numberWithBool:[[self model] useBundleID]]; }
-(void) setS_UseBundleID:(NSNumber *)s_UseBundleID { [[self model] setUseBundleID:[s_UseBundleID boolValue]]; }

-(NSNumber*) s_UseMobileSafari { return [NSNumber numberWithBool:[[self model] useMobileSafari]]; }
-(void) setS_UseMobileSafari:(NSNumber *)s_UseMobileSafari { [[self model] setUseMobileSafari:[s_UseMobileSafari boolValue]]; }

#pragma mark - Functions

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

-(void) s_UsePlatform:(NSScriptCommand *)command
{
	NSString *parameter = [command directParameter];
	if ([parameter isEqualToString:@"android"])
	{
		[[self model] setPlatform:Platform_Android];
	}
	else if ([parameter isEqualToString:@"ios"])
	{
		[[self model] setPlatform:Platform_iOS];
	}
}

-(void) s_ForceiOSDevice:(NSScriptCommand *)command
{
	NSString *parameter = [command directParameter];
	if ([parameter isEqualToString:@"none"])
	{
		[[self model] setForceDevice:NO];
	}
	else if ([parameter isEqualToString:@"ipad"])
	{
		[[self model] setForceDevice:YES];
		[[self model] setDeviceToForce:iOSAutomationDevice_iPad];
	}
	else if ([parameter isEqualToString:@"iphone"])
	{
		[[self model] setForceDevice:YES];
		[[self model] setDeviceToForce:iOSAutomationDevice_iPhone];
	}
}

@end
