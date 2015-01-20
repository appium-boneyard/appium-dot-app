//
//  AppiumAppDelegate.m
//  Appium
//
//  Created by Dan Cuellar on 3/3/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumAppDelegate.h"

#import "AppiumInspectorWindowController.h"
#import "AppiumInstallationWindowController.h"
#import "AppiumUpdater.h"
#import "NodeInstance.h"
#import "Utility.h"

@implementation AppiumAppDelegate

#pragma mark - Handlers

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// create model
	[self setModel:[AppiumModel new]];

    // create main monitor window
    [self setMainWindowController:[[AppiumMainWindowController alloc] initWithWindowNibName:@"AppiumMainWindow"]];
	_updater = [[AppiumUpdater alloc] initWithAppiumMainWindowController:[self mainWindowController]];

    // install anything that's missing
    [self performSelectorInBackground:@selector(install) withObject:nil];

}

-(void)applicationWillTerminate:(NSNotification *)notification
{
    [self.model killServer];
}

-(BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)app {
    return YES;
}

#pragma mark - Inspector

-(IBAction) displayInspector:(id)sender
{
	if (self.inspectorWindowController == nil)
	{
		self.mainWindowController.inspectorIsLaunching = YES;
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			self.inspectorWindowController = [[AppiumInspectorWindowController alloc] initWithWindowNibName:@"AppiumInspectorWindow"];
			self.mainWindowController.inspectorIsLaunching = NO;
			
			dispatch_async(dispatch_get_main_queue(), ^{
				[self presentInspector];
			});
		});
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(inspectorWindowWillClose:)
													 name:NSWindowWillCloseNotification
												   object:[self.inspectorWindowController window]];
	}
	else
	{
		[self presentInspector];
	}
}

- (void)presentInspector
{
	[self.inspectorWindowController showWindow:self];
	[[self.inspectorWindowController window] makeKeyAndOrderFront:self];
}

- (void)closeInspector
{
	if (self.inspectorWindowController != nil)
	{
		[self.inspectorWindowController close];
	}
}

- (void)inspectorWindowWillClose:(NSNotification *)notification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowWillCloseNotification object:[self.inspectorWindowController window]];
	self.inspectorWindowController = nil;
}

#pragma mark - Updates

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
        NSString *appiumVersion = [[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] componentsSeparatedByString:@" "] objectAtIndex:0];
		[[[self mainWindowController] node] installPackage:@"appium" atVersion:appiumVersion forceInstall:NO];
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

    // check for authorization
    [self performSelectorOnMainThread:@selector(checkForAuthorization) withObject:nil waitUntilDone:YES];

    // check for updates
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Check For Updates"])
    {
        [self checkForUpdates:nil];
    }
}

-(void) checkForAuthorization
{
	if (!self.model.iOS.authorized)
	{
		NSAlert *alert = [NSAlert new];
        [alert setMessageText:@"Appium is not authorized to run the iOS Simulator"];
        [alert setInformativeText:@"Would you like to authorize it now?"];
		[alert addButtonWithTitle:@"Do Not Ask Again"];
        [alert addButtonWithTitle:@"No"];
		[alert addButtonWithTitle:@"Yes"];
		NSModalResponse response = [alert runModal];
		if (response == NSAlertThirdButtonReturn)
		{
			NSString *nodePath = [self.mainWindowController.node pathToNodeBinary];
			NSString *appiumPath = [self.mainWindowController.node pathtoPackage:@"appium"];
			NSString *authorizePath = [NSString stringWithFormat:@"%@/%@", appiumPath, @"bin/authorize-ios.js", nil];
			[Utility runTaskWithBinary:nodePath arguments:[NSArray arrayWithObjects:authorizePath, nil] path:appiumPath];
			[self.model.iOS setAuthorized:YES];
		}
		else if (response == NSAlertFirstButtonReturn)
		{
			[self.model.iOS setAuthorized:YES];
		}
	}
}

-(IBAction) checkForUpdates:(id)sender
{
	[_updater performSelectorInBackground:@selector(checkForUpdates:) withObject:sender];
}

-(IBAction) resetPreferences:(id)sender {
	[_model reset];
}

-(IBAction) showHelp:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://appium.io/documentation.html?lang=en"]];
}

-(void) restart
{
    NSTask *restartTask = [NSTask new];
    [restartTask setLaunchPath:@"/bin/sh"];
    [restartTask setArguments:[NSArray arrayWithObjects: @"-c",[NSString stringWithFormat:@"sleep 2; open \"%@\"", [[NSBundle mainBundle] bundlePath] ], nil]];
    [restartTask launch];
    [[NSApplication sharedApplication] terminate:nil];
}

#pragma mark - Open / Save / Open Recent

-(IBAction)openDocument:(id)sender {
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	[openPanel setAllowedFileTypes:@[@"appiumconfig"]];
	[openPanel setDirectoryURL:[NSURL fileURLWithPath: NSHomeDirectory()]];
	[openPanel beginSheetModalForWindow:self.mainWindowController.window completionHandler:^(NSInteger result){
		if (result == NSFileHandlingPanelOKButton) {
			[openPanel orderOut:self];
			[self.model resetWithFile:[openPanel.URL path]];
			[[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:openPanel.URL];
		}
	}];
}

-(IBAction)saveDocument:(id)sender {
	NSSavePanel *savePanel = [NSSavePanel savePanel];
	[savePanel setAllowedFileTypes:@[@"appiumconfig"]];
	[savePanel setDirectoryURL:[NSURL fileURLWithPath: NSHomeDirectory()]];
	[savePanel beginSheetModalForWindow:self.mainWindowController.window completionHandler:^(NSInteger result){
		if (result == NSFileHandlingPanelOKButton) {
			[savePanel orderOut:self];
			NSError *err;
			NSString *pListPath = [NSString pathWithComponents:@[NSHomeDirectory(),@"Library",@"Preferences",@"com.appium.Appium.plist"]];
			
			// remove the file if it exists
			if ([[NSFileManager defaultManager] fileExistsAtPath:[savePanel.URL path]  isDirectory:NO]) {
				[[NSFileManager defaultManager] removeItemAtPath:[savePanel.URL path] error:&err];
				if (err) {
					NSLog(@"%@",err.description);
					return;
				}
			}
			
			// copy the current settings to the file
			[[NSFileManager defaultManager] copyItemAtPath:pListPath toPath:[savePanel.URL path] error:&err];
			
			if (err) {
				NSLog(@"%@",err.description);
			} else {
				[[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:savePanel.URL];
			}
		}
	}];
}

-(BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename {
	[[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:[NSURL fileURLWithPath:filename]];
	return [self.model resetWithFile:filename];
}

@end
