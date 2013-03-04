//
//  AppiumAppDelegate.m
//  Appium
//
//  Created by Dan Cuellar on 3/3/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumAppDelegate.h"
#import "NodeInstance.h"
#import "AppiumInstallationWindowController.h"

@implementation AppiumAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    [self setMainWindowController:[[AppiumMonitorWindowController alloc] initWithWindowNibName:@"AppiumMonitorWindow"]];
    [self performSelectorInBackground:@selector(install) withObject:nil];
    
}

-(void) install
{
    AppiumInstallationWindowController *installationWindow = [[AppiumInstallationWindowController alloc] initWithWindowNibName:@"AppiumInstallationWindow"];
    [installationWindow performSelectorOnMainThread:@selector(showWindow:) withObject:self waitUntilDone:YES];
    [[installationWindow window] performSelectorOnMainThread:@selector(makeKeyAndOrderFront:) withObject:self waitUntilDone:YES];
    [[installationWindow messageLabel] performSelectorOnMainThread:@selector(setStringValue:) withObject:@"Installing NodeJS..." waitUntilDone:YES];
    self.mainWindowController.node = [[NodeInstance alloc] initWithPath:[[NSBundle mainBundle] resourcePath]];
    [[installationWindow messageLabel] performSelectorOnMainThread:@selector(setStringValue:) withObject:@"Installing Appium Prerequisites..." waitUntilDone:YES];
    [[[self mainWindowController] node] installPackageWithNPM:@"argparse"];
    [[installationWindow messageLabel] performSelectorOnMainThread:@selector(setStringValue:) withObject:@"Installing Appium..." waitUntilDone:YES];
    [[[self mainWindowController] node] installPackageWithNPM:@"appium"];
    [[installationWindow window] performSelectorOnMainThread:@selector(close) withObject:nil waitUntilDone:YES];
    [[self mainWindowController] performSelectorOnMainThread:@selector(showWindow:) withObject:self waitUntilDone:YES];
    [[[self mainWindowController] window] performSelectorOnMainThread:@selector(makeKeyAndOrderFront:) withObject:self waitUntilDone:YES];
}

-(void)applicationWillTerminate:(NSNotification *)notification
{
    [[self mainWindowController] killServer];
}

@end
