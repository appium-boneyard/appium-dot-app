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
	return delegate.inspectorWindow;
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

#pragma mark - Methods

- (NSNumber*) s_StartServer: (NSScriptCommand*)command
{
    if (self.model.isServerRunning)
        return [NSNumber numberWithBool:NO];
    [[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] mainWindowController] launchButtonClicked:nil];
    return [NSNumber numberWithBool:YES];

}

- (NSNumber*) s_StopServer: (NSScriptCommand*)command
{
    if (self.model.isServerRunning)
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

-(void) s_ResetPreferences:(NSScriptCommand *)command
{
	[self.model reset];
}

@end
