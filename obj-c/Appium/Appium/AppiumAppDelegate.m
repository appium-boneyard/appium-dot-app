//
//  AppiumAppDelegate.m
//  Appium
//
//  Created by Dan Cuellar on 3/3/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumAppDelegate.h"
#import "AppiumUpdater.h"
#import "NodeInstance.h"
#import "AppiumInstallationWindowController.h"

NSWindowController *preferencesWindow;
AppiumUpdater *updater;

@implementation AppiumAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// create model
	[self setModel:[AppiumModel new]];
	
    // create main monitor window
    [self setMainWindowController:[[AppiumMonitorWindowController alloc] initWithWindowNibName:@"AppiumMonitorWindow"]];
	updater = [[AppiumUpdater alloc] initWithAppiumMonitorWindowController:[self mainWindowController]];

    // install anything that's missing
    [self performSelectorInBackground:@selector(install) withObject:nil];
    
}

-(IBAction) displayPreferences:(id)sender
{
	if (preferencesWindow == nil)
	{
		preferencesWindow = [[NSWindowController alloc] initWithWindowNibName:@"AppiumPreferenceWindow" owner:self];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(preferenceWindowWillClose:)
													 name:NSWindowWillCloseNotification
												   object:[preferencesWindow window]];
	}
	
	[preferencesWindow showWindow:self];
	[[preferencesWindow window] makeKeyAndOrderFront:self];
}

- (void)preferenceWindowWillClose:(NSNotification *)notification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowWillCloseNotification object:[preferencesWindow window]];
	preferencesWindow = nil;
}

-(void) install
{
    // check is nodejs, appium, or appium pre-reqs are missing
    NSString *nodeRootPath = [[NSBundle mainBundle] resourcePath];
    BOOL installationRequired = ![NodeInstance instanceExistsAtPath:nodeRootPath];
    installationRequired |= ![NodeInstance packageIsInstalledAtPath:nodeRootPath withName:@"appium"];
    
    if (installationRequired)
    {
        // install software
        AppiumInstallationWindowController *installationWindow = [[AppiumInstallationWindowController alloc] initWithWindowNibName:@"AppiumInstallationWindow"];
        [installationWindow performSelectorOnMainThread:@selector(showWindow:) withObject:self waitUntilDone:YES];
        [[installationWindow window] performSelectorOnMainThread:@selector(makeKeyAndOrderFront:) withObject:self waitUntilDone:YES];
        [[installationWindow messageLabel] performSelectorOnMainThread:@selector(setStringValue:) withObject:@"Installing NodeJS..." waitUntilDone:YES];
        [[self mainWindowController] setNode:[[NodeInstance alloc] initWithPath:nodeRootPath]];
        [[installationWindow messageLabel] performSelectorOnMainThread:@selector(setStringValue:) withObject:@"Installing Appium..." waitUntilDone:YES];
        [[[self mainWindowController] node] installPackage:@"appium"  forceInstall:NO];
        [[installationWindow window] performSelectorOnMainThread:@selector(close) withObject:nil waitUntilDone:YES];
    }
    else
    {
        // create node instance
        [[self mainWindowController] setNode:[[NodeInstance alloc] initWithPath:nodeRootPath]];
    }
    
    // show main monitor window
    [[self mainWindowController] performSelectorOnMainThread:@selector(showWindow:) withObject:self waitUntilDone:YES];
    [[[self mainWindowController] window] performSelectorOnMainThread:@selector(makeKeyAndOrderFront:) withObject:self waitUntilDone:YES];

    // check for updates
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Check For Updates"])
    {
        [self checkForUpdates:nil];
    }
}

-(IBAction)checkForUpdates:(id)sender
{
	[updater performSelectorInBackground:@selector(checkForUpdates:) withObject:sender];
}

-(void) restart
{
    NSTask *restartTask = [NSTask new];
    [restartTask setLaunchPath:@"/bin/sh"];
    [restartTask setArguments:[NSArray arrayWithObjects: @"-c",[NSString stringWithFormat:@"sleep 2; open \"%@\"", [[NSBundle mainBundle] bundlePath] ], nil]];
    [restartTask launch];
    [[NSApplication sharedApplication] terminate:nil];
}

-(void)applicationWillTerminate:(NSNotification *)notification
{
    [[self mainWindowController] killServer];
}

@end
