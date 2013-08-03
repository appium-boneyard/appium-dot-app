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

# pragma mark - Getters

-(NSString*) s_AndroidActivity { return self.model.androidActivity; }
-(NSNumber*) s_AndroidDeviceReadyTimeout { return [NSNumber numberWithInt:[self.model. androidDeviceReadyTimeout intValue]]; }
-(NSString*) s_AndroidKeyAlias { return self.model.androidKeyAlias; }
-(NSString*) s_AndroidKeyPassword { return self.model.androidKeyPassword; }
-(NSString*) s_AndroidKeystorePassword { return self.model.androidKeystorePassword; }
-(NSString*) s_AndroidKeystorePath { return self.model.androidKeystorePath; }
-(NSString*) s_AndroidPackage { return self.model.androidPackage; }
-(NSString*) s_AndroidWaitActivity { return self.model.androidWaitActivity; }
-(NSString*) s_AppPath { return self.model.appPath; }
-(NSString*) s_AVD { return self.model.avd; }
-(NSNumber*) s_BreakOnNodeAppStart { return [NSNumber numberWithBool:self.model.breakOnNodeApplicationStart]; }
-(NSString*) s_BundleID { return self.model.bundleID;}
-(NSNumber*) s_CheckForUpdates { return [NSNumber numberWithBool:self.model.checkForUpdates]; }
-(NSString*) s_CustomAndroidSDKPath { return self.model.customAndroidSDKPath;}
-(NSNumber*) s_DeveloperMode { return [NSNumber numberWithBool:self.model.developerMode]; }
-(NSString*) s_ExternalAppiumPackagePath { return self.model.externalAppiumPackagePath; }
-(NSString*) s_ExternalNodeJSBinaryPath { return self.model.externalNodeJSBinaryPath; }
-(NSString*) s_IPAddress { return self.model.ipAddress; }
-(NSNumber*) s_IsServerListening { return [NSNumber numberWithBool:self.model.isServerListening]; }
-(NSNumber*) s_IsServerRunning { return [NSNumber numberWithBool:self.model.isServerRunning]; }
-(NSNumber*) s_KeepArtifacts { return [NSNumber numberWithBool:self.model.keepArtifacts]; }
-(NSNumber*) s_KillProcessesUsingPort { return [NSNumber numberWithBool:self.model.killProcessesUsingPort]; }
-(NSString*) s_LogFile { return self.model.logFile; }
-(NSString*) s_LogWebhook { return self.model.logWebHook; }
-(NSNumber*) s_NodeDebugPort { return [NSNumber numberWithInt:[self.model.nodeDebugPort intValue]]; }
-(NSString*) s_NodePath { return [[[(AppiumAppDelegate*)[[NSApplication sharedApplication]delegate] mainWindowController] node] pathToNodeBinary]; }
-(NSNumber*) s_OverrideExistingSessions { return [NSNumber numberWithBool:self.model.overrideExistingSessions]; }
-(NSNumber*) s_PrelaunchApp { return [NSNumber numberWithBool:self.model.prelaunchApp]; }
-(NSNumber*) s_ResetApplicationState { return [NSNumber numberWithBool:self.model.resetApplicationState]; }
-(NSString*) s_RobotAddress { return self.model.robotAddress; }
-(NSNumber*) s_RobotPort { return [NSNumber numberWithInt:[self.model.robotPort intValue]]; }
-(NSNumber*) s_SelendroidPort { return [NSNumber numberWithInt:[self.model.selendroidPort intValue]]; }
-(NSString*) s_SeleniumGridConfigFile { return self.model.seleniumGridConfigFile; }
-(NSString*) s_UDID { return self.model.udid; }
-(NSNumber*) s_UseAndroidActivity { return [NSNumber numberWithBool:self.model.useAndroidActivity]; }
-(NSNumber*) s_UseAndroidDeviceReadyTimeout { return [NSNumber numberWithBool:self.model.useAndroidDeviceReadyTimeout]; }
-(NSNumber*) s_UseAndroidFullReset { return [NSNumber numberWithBool:self.model.androidFullReset]; }
-(NSNumber*) s_UseAndroidKeystore { return [NSNumber numberWithBool:self.model.useAndroidKeystore]; }
-(NSNumber*) s_UseAndroidPackage { return [NSNumber numberWithBool:self.model.useAndroidPackage]; }
-(NSNumber*) s_UseAndroidWaitActivity { return [NSNumber numberWithBool:self.model.useAndroidWaitActivity]; }
-(NSNumber*) s_UseAppPath { return [NSNumber numberWithBool:self.model.useAppPath]; }
-(NSNumber*) s_UseAVD { return [NSNumber numberWithBool:self.model.useAVD]; }
-(NSNumber*) s_UseBundleID { return [NSNumber numberWithBool:self.model.useBundleID]; }
-(NSNumber*) s_UseCustomAndroidSDKPath { return [NSNumber numberWithBool:self.model.useCustomAndroidSDKPath]; }
-(NSNumber*) s_UseCustomSelendroidPort { return [NSNumber numberWithBool:self.model.useSelendroidPort]; }
-(NSNumber*) s_UseExternalAppiumPackage { return [NSNumber numberWithBool:self.model.useExternalAppiumPackage]; }
-(NSNumber*) s_UseExternalNodeJSBinary { return [NSNumber numberWithBool:self.model.useExternalNodeJSBinary]; }
-(NSNumber*) s_UseLogFile { return [NSNumber numberWithBool:self.model.useLogFile]; }
-(NSNumber*) s_UseLogWebhook { return [NSNumber numberWithBool:self.model.useLogWebHook]; }
-(NSNumber*) s_UseMobileSafari { return [NSNumber numberWithBool:self.model.useMobileSafari]; }
-(NSNumber*) s_UseNativeInstrumentsLibrary { return [NSNumber numberWithBool:self.model.useNativeInstrumentsLib]; }
-(NSNumber*) s_UseNodeDebugger { return [NSNumber numberWithBool:self.model.useNodeDebugging]; }
-(NSNumber*) s_UseQuietLogging { return [NSNumber numberWithBool:self.model.useQuietLogging];}
-(NSNumber*) s_UseRemoteServer { return [NSNumber numberWithBool:self.model.useRemoteServer]; }
-(NSNumber*) s_UseRobot { return [NSNumber numberWithBool:self.model.useRobot];}
-(NSNumber*) s_UseSeleniumGridConfigFile { return [NSNumber numberWithBool:self.model.useSeleniumGridConfigFile];}
-(NSNumber*) s_UseUDID { return [NSNumber numberWithBool:self.model.useUDID]; }
-(NSNumber*) s_Port { return [NSNumber numberWithInt:[self.model.port intValue]]; }

# pragma mark - Setters

-(void) setS_AndroidActivity:(NSString *)s_AndroidActivity { [self.model setAndroidActivity:s_AndroidActivity]; }
-(void) setS_AndroidDeviceReadyTimeout:(NSNumber *)s_AndroidDeviceReadyTimeout { [self.model setAndroidDeviceReadyTimeout:s_AndroidDeviceReadyTimeout]; }
-(void) setS_AndroidKeyAlias:(NSString *)s_AndroidKeyAlias {[self.model setAndroidKeyAlias:s_AndroidKeyAlias]; }
-(void) setS_AndroidKeyPassword:(NSString *)s_AndroidKeyPassword { [self.model setAndroidKeyPassword:s_AndroidKeyPassword]; }
-(void) setS_AndroidKeystorePassword:(NSString *)s_AndroidKeystorePassword { [self.model setAndroidKeystorePassword:s_AndroidKeystorePassword]; }
-(void) setS_AndroidKeystorePath:(NSString *)s_AndroidKeystorePath { [self.model setAndroidKeystorePath:s_AndroidKeystorePath]; }
-(void) setS_AndroidPackage:(NSString *)s_AndroidPackage { [self.model setAndroidPackage:s_AndroidPackage]; }
-(void) setS_AndroidWaitActivity:(NSString *)s_AndroidWaitActivity { [self.model setAndroidWaitActivity:s_AndroidWaitActivity]; }
-(void) setS_AppPath:(NSString *)s_AppPath { [self.model setAppPath:s_AppPath]; }
-(void) setS_AVD:(NSString *)s_AVD { [self.model setAvd:s_AVD]; }
-(void) setS_BreakOnNodeAppStart:(NSNumber *)s_BreakOnNodeAppStart { [self.model setUseNodeDebugging:[s_BreakOnNodeAppStart boolValue]]; }
-(void) setS_BundleID:(NSString *)s_BundleID { [self.model setBundleID:s_BundleID]; }
-(void) setS_CheckForUpdates:(NSNumber *)s_CheckForUpdates { [self.model setCheckForUpdates:[s_CheckForUpdates boolValue]]; }
-(void) setS_CustomAndroidSDKPath:(NSString *)s_CustomAndroidSDKPath { [self.model setCustomAndroidSDKPath:s_CustomAndroidSDKPath]; }
-(void) setS_DeveloperMode:(NSNumber *)s_DeveloperMode { [self.model setDeveloperMode:[s_DeveloperMode boolValue]]; }
-(void) setS_ExternalAppiumPackagePath:(NSString *)s_ExternalAppiumPackagePath { [self.model setExternalAppiumPackagePath:s_ExternalAppiumPackagePath]; }
-(void) setS_ExternalNodeJSBinaryPath:(NSString *)s_ExternalNodeJSBinaryPath { [self.model setExternalNodeJSBinaryPath:s_ExternalNodeJSBinaryPath]; }
-(void) setS_IPAddress:(NSString *)s_IPAddress { [self.model setIpAddress:s_IPAddress]; }
-(void) setS_KeepArtifacts:(NSNumber *)s_KeepArtifacts{	[self.model setKeepArtifacts:[s_KeepArtifacts boolValue]]; }
-(void) setS_KillProcessesUsingPort:(NSNumber *)s_KillProcessesUsingPort { [self.model setKillProcessesUsingPort:[s_KillProcessesUsingPort boolValue]]; }
-(void) setS_LogFile:(NSString *)s_LogFile { [self.model setLogFile:s_LogFile]; }
-(void) setS_LogWebhook:(NSString *)s_LogWebhook { [self.model setLogWebHook:s_LogWebhook]; }
-(void) setS_NodeDebugPort:(NSNumber *)s_NodeDebugPort { [self.model setNodeDebugPort:s_NodeDebugPort]; }
-(void) setS_OverrideExistingSessions:(NSNumber *)s_OverrideExistingSessions { [self.model setOverrideExistingSessions:[s_OverrideExistingSessions boolValue]]; }
-(void) setS_PrelaunchApp:(NSNumber *)s_PreLaunchApp { [self.model setPrelaunchApp:[s_PreLaunchApp boolValue]]; }
-(void) setS_ResetApplicationState:(NSNumber *)s_ResetApplicationState{	[self.model setResetApplicationState:[s_ResetApplicationState boolValue]]; }
-(void) setS_RobotAddress:(NSString *)s_RobotAddress{ [self.model setRobotAddress:s_RobotAddress]; }
-(void) setS_RobotPort:(NSNumber *)s_RobotPort { [self.model setRobotPort:s_RobotPort]; }
-(void) setS_SelendroidPort:(NSNumber *)s_SelendroidPort { [self.model setSelendroidPort:s_SelendroidPort]; }
-(void) setS_SeleniumGridConfigFile:(NSString *)s_SeleniumGridConfigFile { [self.model setSeleniumGridConfigFile:s_SeleniumGridConfigFile]; }
-(void) setS_UDID:(NSString *)s_UDID { [self.model setUdid:s_UDID]; }
-(void) setS_UseAndroidActivity:(NSNumber *)s_UseAndroidActivity { [self.model setUseAndroidActivity:[s_UseAndroidActivity boolValue]]; }
-(void) setS_UseAndroidDeviceReadyTimeout:(NSNumber *)s_UseAndroidDeviceReadyTimeout { [self.model setUseAndroidDeviceReadyTimeout:[s_UseAndroidDeviceReadyTimeout boolValue]]; }
-(void) setS_UseAndroidFullReset:(NSNumber *)s_UseFastReset { [self.model setAndroidFullReset:[s_UseFastReset boolValue]]; }
-(void) setS_UseAndroidKeystore:(NSNumber *)s_UseAndroidKeystore { [self.model setUseAndroidKeystore:[s_UseAndroidKeystore boolValue]]; }
-(void) setS_UseAndroidPackage:(NSNumber *)s_UseAndroidPackage { [self.model setUseAndroidPackage:[s_UseAndroidPackage boolValue]]; }
-(void) setS_UseAndroidWaitActivity:(NSNumber *)s_UseAndroidWaitActivity { [self.model setUseAndroidWaitActivity:[s_UseAndroidWaitActivity boolValue]]; }
-(void) setS_UseAppPath:(NSNumber *)s_UseAppPath { [self.model setUseAppPath:[s_UseAppPath boolValue]]; }
-(void) setS_UseAVD:(NSNumber *)s_UseAVD { [self.model setUseAVD:[s_UseAVD boolValue]]; }
-(void) setS_UseBundleID:(NSNumber *)s_UseBundleID { [self.model setUseBundleID:[s_UseBundleID boolValue]]; }
-(void) setS_UseCustomAndroidSDKPath:(NSNumber *)s_UseCustomAndroidSDKPath { [self.model setUseCustomAndroidSDKPath:[s_UseCustomAndroidSDKPath boolValue]]; }
-(void) setS_UseCustomSelendroidPort:(NSNumber *)s_UseCustomSelendroidPort { [self.model setUseSelendroidPort:[s_UseCustomSelendroidPort boolValue]]; }
-(void) setS_UseExternalAppiumPackage:(NSNumber *)s_UseExternalAppiumPackage { [self.model setUseExternalAppiumPackage:[s_UseExternalAppiumPackage boolValue]]; }
-(void) setS_UseExternalNodeJSBinary:(NSNumber *)s_UseExternalNodeJSBinary { [self.model setUseExternalNodeJSBinary:[s_UseExternalNodeJSBinary boolValue]]; }
-(void) setS_UseLogFile:(NSNumber *)s_UseLogFile { [self.model setUseLogFile:[s_UseLogFile boolValue]]; }
-(void) setS_UseLogWebhook:(NSNumber *)s_UseLogWebhook { [self.model setUseLogWebHook:[s_UseLogWebhook boolValue]]; }
-(void) setS_UseMobileSafari:(NSNumber *)s_UseMobileSafari { [self.model setUseMobileSafari:[s_UseMobileSafari boolValue]]; }
-(void) setS_UseNativeInstrumentsLibrary:(NSNumber *)s_UseInstrumentsWithoutDelay { [self.model setUseNativeInstrumentsLib:[s_UseInstrumentsWithoutDelay boolValue]]; }
-(void) setS_UseNodeDebugger:(NSNumber *)s_UseNodeDebugger { [self.model setUseNodeDebugging:[s_UseNodeDebugger boolValue]]; }
-(void) setS_UseQuietLogging:(NSNumber *)s_UseQuietLogging { [self.model setUseQuietLogging:[s_UseQuietLogging boolValue]]; }
-(void) setS_UseRemoteServer:(NSNumber *)s_UseRemoteServer { [self.model setUseRemoteServer:[s_UseRemoteServer boolValue]]; }
-(void) setS_UseRobot:(NSNumber *)s_UseRobot { [self.model setUseRobot:[s_UseRobot boolValue]]; }
-(void) setS_UseSeleniumGridConfigFile:(NSNumber *)s_UseSeleniumGridConfigFile { [self.model setUseSeleniumGridConfigFile:[s_UseSeleniumGridConfigFile boolValue]]; }
-(void) setS_UseUDID:(NSNumber *)s_UseUDID { [self.model setUseUDID:[s_UseUDID boolValue]]; }
-(void) setS_Port:(NSNumber *)s_Port { [self.model setPort:s_Port]; }

-(AppiumInspectorWindowController*) s_InspectorWindow
{
	AppiumAppDelegate *delegate = [self delegate];
	return delegate.inspectorWindow;
}

#pragma mark - Methods

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
		[self.model setPlatform:Platform_Android];
	}
	else if ([parameter isEqualToString:@"ios"])
	{
		[self.model setPlatform:Platform_iOS];
	}
}

-(void) s_ForceiOSDevice:(NSScriptCommand *)command
{
	NSString *parameter = [command directParameter];
	if ([parameter isEqualToString:@"no device"])
	{
		[self.model setForceDevice:NO];
	}
	else if ([parameter isEqualToString:@"ipad"])
	{
		[self.model setForceDevice:YES];
		[self.model setDeviceToForce:iOSAutomationDevice_iPad];
	}
	else if ([parameter isEqualToString:@"iphone"])
	{
		[self.model setForceDevice:YES];
		[self.model setDeviceToForce:iOSAutomationDevice_iPhone];
	}
}

-(void) s_ForceiOSOrientation:(NSScriptCommand *)command
{
	NSString *parameter = [command directParameter];
	if ([parameter isEqualToString:@"no orientation"])
	{
		[self.model setForceOrientation:NO];
	}
	else if ([parameter isEqualToString:@"portrait"])
	{
		[self.model setForceOrientation:YES];
		[self.model setOrientationToForce:iOSOrientation_Portrait];
	}
	else if ([parameter isEqualToString:@"landscape"])
	{
		[self.model setForceOrientation:YES];
		[self.model setOrientationToForce:iOSOrientation_Landscape];
	}
}

@end
