//
//  AppiumAppleScriptSupport.m
//  Appium
//
//  Created by Dan Cuellar on 3/4/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "NSApplication+AppleScript.h"

#import "AppiumAppDelegate.h"


@implementation NSApplication(AppiumAppleScriptSupport)

-(AppiumModel*) model { return [(AppiumAppDelegate*)[self delegate] model]; }

# pragma mark - Getters

-(AppiumAndroidSettingsModel*) s_Android { return self.model.android; }
-(AppiumDeveloperSettingsModel*) s_Developer { return self.model.developer; }
-(AppiumGeneralSettingsModel*) s_General { return self.model.general; }
-(AppiumiOSSettingsModel*) s_iOS { return self.model.iOS; }
-(AppiumRobotSettingsModel*) s_Robot { return self.model.robot;}

-(AppiumInspectorWindowController*) s_InspectorWindow
{
	AppiumAppDelegate *delegate = [self delegate];
	return delegate.inspectorWindowController;
}

-(NSString*) s_LogText
{
    return [[[[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] mainWindowController] logTextView] textStorage] string];
}

-(BOOL) s_IsServerRunning
{
    return [[[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] mainWindowController] model] isServerRunning];
}

-(BOOL) s_IsServerListening
{
    return [[[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] mainWindowController] model] isServerListening];
}

-(NSString*) s_Platform {
	if ([[[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] mainWindowController] model] isAndroid]) {
		return @"Android";
	} else if ([[[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] mainWindowController] model] isIOS]) {
		return @"iOS";
	} else {
		return @"Unknown";
	}
}

#pragma mark - Methods

-(void) s_AddEnvironmentVariable:(NSScriptCommand *)command
{
	NSString *parameter = [[command directParameter] stringValue];
	NSArray *pieces = [parameter componentsSeparatedByString:@"="];
	NSString *key = [pieces objectAtIndex:0];
	NSString *value = @"";
	for (int i=1; i < pieces.count; i++) {
		if (i > 1) {
			value = [value stringByAppendingString:@"="];
		}
		value = [value stringByAppendingString:[pieces objectAtIndex:i]];
	}
	NSArray *envVars = ((AppiumAppDelegate*)[[NSApplication sharedApplication] delegate]).model.general.environmentVariables;
	[((AppiumAppDelegate*)[[NSApplication sharedApplication] delegate]).model.general setEnvironmentVariables:[envVars arrayByAddingObject:@{@"key":key, @"value":value}]];
}

-(void) s_ClearEnvironmentVariables:(NSScriptCommand *)command
{
	[((AppiumAppDelegate*)[[NSApplication sharedApplication] delegate]).model.general setEnvironmentVariables:@[]];
}

-(void) s_ClearLog: (NSScriptCommand*)command
{
	[[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] mainWindowController] clearLog:nil];
}

-(void) s_ResetPreferences:(NSScriptCommand *)command
{
	[self.model reset];
}

- (NSNumber*) s_StartServer: (NSScriptCommand*)command
{
	if (self.model.isServerRunning)
		return [NSNumber numberWithBool:NO];
	[[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] mainWindowController] launchButtonClicked:nil];
	return [NSNumber numberWithBool:YES];
	
}

- (NSNumber*) s_StopServer: (NSScriptCommand*)command
{
	if (!self.model.isServerRunning)
		return [NSNumber numberWithBool:NO];
	[[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] mainWindowController] launchButtonClicked:nil];
	return [NSNumber numberWithBool:YES];
}

-(void) s_UsePlatform:(NSScriptCommand *)command
{
	NSString *parameter = [command directParameter];
	if ([parameter isEqualToString:@"android"])
	{
		[self.model setIsAndroid:YES];
	}
	else if ([parameter isEqualToString:@"ios"])
	{
		[self.model setIsAndroid:NO];
	}
}

@end
