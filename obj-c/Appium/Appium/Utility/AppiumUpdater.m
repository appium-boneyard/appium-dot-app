//
//  AppiumUpgrader.m
//  Appium
//
//  Created by Dan Cuellar on 3/7/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumUpdater.h"
#import "AppiumAppDelegate.h"
#import "AppiumMonitorWindowController.h"
#import "AppiumInstallationWindowController.h"
#import "Utility.h"

#pragma mark - Constants

#define APPIUM_APP_VERSION_URL @"https://raw.github.com/appium/appium.github.com/master/autoupdate/Appium.app.version"

#define APPIUM_PACKAGE_VERSION_URL @"https://raw.github.com/appium/appium/master/package.json"

#pragma mark - Appium Updater

AppiumMonitorWindowController *mainWindowController;

@implementation AppiumUpdater

- (id)initWithAppiumMonitorWindowController:(AppiumMonitorWindowController*)windowController
{
    self = [super init];
    if (self) {
        mainWindowController = windowController;
    }
    return self;
}

-(void) checkForUpdates:(id)sender
{
	BOOL alertOnNoUpdates = sender != nil;
	BOOL updatesAvailable = NO;
    updatesAvailable |= [self checkForAppUpdate];
    updatesAvailable |= [self checkForPackageUpdate];
	if (alertOnNoUpdates && !updatesAvailable)
	{
		NSAlert *alert = [NSAlert new];
		[alert setMessageText:@"No Updates Available"];
		[alert setInformativeText:@"Your application is up to date"];
		[alert performSelectorOnMainThread:@selector(runModal) withObject:nil waitUntilDone:YES];
	}
}

#pragma mark - Appium.app Update

-(BOOL) checkForAppUpdate
{
    // check github for the latest version
    NSString *stringURL = APPIUM_APP_VERSION_URL;
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if (!urlData)
    {
        return NO;
    }
    NSString *latestVersion = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
	latestVersion = [latestVersion stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	
    // check the local copy of appium
    NSString *myVersion = (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];

    if (![myVersion isEqualToString:latestVersion])
    {
        [self performSelectorOnMainThread:@selector(doAppUpgradeAlert:) withObject:[NSArray arrayWithObjects:myVersion, latestVersion, nil] waitUntilDone:NO];
		return YES;
    }
	return NO;
}

-(void)doAppUpgradeAlert:(NSArray*)versions
{
    NSAlert *upgradeAlert = [NSAlert new];
    [upgradeAlert setInformativeText:[NSString stringWithFormat:@"Would you like to download the latest version of Appium.app and restart?\n\nYour Version:\t%@\nLatest Version:\t%@", [versions objectAtIndex:0], [versions objectAtIndex:1]]];
    [upgradeAlert addButtonWithTitle:@"No"];
    [upgradeAlert addButtonWithTitle:@"Yes"];
    if([upgradeAlert runModal] == NSAlertSecondButtonReturn)
    {
        [self performSelectorInBackground:@selector(doAppUpgradeInstall) withObject:nil];
    }
}

-(void)doAppUpgradeInstall
{
    [mainWindowController killServer];
    
    AppiumInstallationWindowController *installationWindow = [[AppiumInstallationWindowController alloc] initWithWindowNibName:@"AppiumInstallationWindow"];
    [[mainWindowController window] close];
    [installationWindow performSelectorOnMainThread:@selector(showWindow:) withObject:self waitUntilDone:YES];
    [[installationWindow window] makeKeyAndOrderFront:self];
    [[installationWindow messageLabel] performSelectorOnMainThread:@selector(setStringValue:) withObject:@"Downloading Appium.app..." waitUntilDone:YES];
    
    // download latest appium.app
    NSString *stringURL = @"http://appium.io/appium.dmg";
    NSLog(@"Downloading Appium app from \"%@.\"", stringURL);
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if (!urlData)
    {
        return;
    }
    
	NSString *dmgPath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],@"appium.dmg"];
	NSString *mountPath = @"/Volumes/Appium";
	NSString *sourcePath = @"/Volumes/Appium/Appium.app";
	NSString *destinationPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [urlData writeToFile:dmgPath atomically:YES];
    
	NSString *upgradeScriptPath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Upgrade.applescript"];
    NSTask *restartTask = [NSTask new];
    [restartTask setLaunchPath:@"/bin/sh"];
    [restartTask setArguments:[NSArray arrayWithObjects: @"-c",[NSString stringWithFormat:@"sleep 2; osascript \"%@\" \"%@\" \"%@\" \"%@\" \"%@\" ; open \"%@\"", upgradeScriptPath, dmgPath, mountPath, sourcePath, destinationPath, [[NSBundle mainBundle] bundlePath] ], nil]];
    [restartTask launch];
    [[NSApplication sharedApplication] terminate:nil];
	
}

#pragma mark - Appium Package Update

-(BOOL) checkForPackageUpdate
{
    // check github for the latest version
    NSString *stringURL = APPIUM_PACKAGE_VERSION_URL;
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if (!urlData)
    {
        return NO;
    }
    NSError *jsonError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:&jsonError];
    NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
    NSString *latestVersion = [jsonDictionary objectForKey:@"version"];
    NSString *myVersion;
    
    // check the local copy of appium
    NSString *packagePath = [[mainWindowController node] pathtoPackage:@"appium"];
    if ([[NSFileManager defaultManager] fileExistsAtPath: packagePath])
    {
        NSData *data = [NSData dataWithContentsOfFile:packagePath];
        jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        jsonDictionary = (NSDictionary *)jsonObject;
        myVersion = [jsonDictionary objectForKey:@"version"];
    }
    if (![myVersion isEqualToString:latestVersion])
    {
        [self performSelectorOnMainThread:@selector(doPackageUpgradeAlert:) withObject:[NSArray arrayWithObjects:myVersion, latestVersion, nil] waitUntilDone:NO];
		return YES;
    }
	return NO;
}

-(void)doPackageUpgradeAlert:(NSArray*)versions
{
    NSAlert *upgradeAlert = [NSAlert new];
    [upgradeAlert setMessageText:@"Appium Upgrade Available"];
    [upgradeAlert setInformativeText:[NSString stringWithFormat:@"Would you like to stop the server and download the latest version of Appium?\n\nYour Version:\t%@\nLatest Version:\t%@", [versions objectAtIndex:0], [versions objectAtIndex:1]]];
    [upgradeAlert addButtonWithTitle:@"No"];
    [upgradeAlert addButtonWithTitle:@"Yes"];
    if([upgradeAlert runModal] == NSAlertSecondButtonReturn)
    {
        [mainWindowController killServer];
        [self performSelectorInBackground:@selector(updateAppiumPackage) withObject:nil];
    }
}

-(void) updateAppiumPackage
{
    AppiumInstallationWindowController *installationWindow = [[AppiumInstallationWindowController alloc] initWithWindowNibName:@"AppiumInstallationWindow"];
    [installationWindow performSelectorOnMainThread:@selector(showWindow:) withObject:self waitUntilDone:YES];
    [[installationWindow window] makeKeyAndOrderFront:self];
    [[mainWindowController window] orderOut:self];
    [[installationWindow messageLabel] performSelectorOnMainThread:@selector(setStringValue:) withObject:@"Updating Appium Package" waitUntilDone:YES];

    [[mainWindowController node] installPackage:@"appium" forceInstall:YES];
    
    [[mainWindowController window] makeKeyAndOrderFront:self];
    [installationWindow close];
    NSAlert *upgradeCompleteAlert = [NSAlert new];
    [upgradeCompleteAlert setMessageText:@"Upgrade Complete"];
    [upgradeCompleteAlert setInformativeText:@"The package was installed successfully"];
    [upgradeCompleteAlert performSelectorOnMainThread:@selector(runModal) withObject:nil waitUntilDone:YES];
}
@end
