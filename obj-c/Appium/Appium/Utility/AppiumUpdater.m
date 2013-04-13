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

#define UPDATE_INFO_URL @"https://raw.github.com/appium/appium.io/master/autoupdate/update.json"
#define APPIUM_PACKAGE_VERSION_URL @"https://raw.github.com/appium/appium/master/package.json"

#pragma mark - Appium Updater

AppiumMonitorWindowController *mainWindowController;
NSString* upgradeUrl;

@implementation AppiumUpdater

- (id)initWithAppiumMonitorWindowController:(AppiumMonitorWindowController*)windowController
{
    self = [super init];
    if (self) {
        mainWindowController = windowController;
		upgradeUrl = @"https://bitbucket.org/appium/appium.app/downloads/appium.dmg";
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
    NSString *stringURL = UPDATE_INFO_URL;
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if (!urlData)
    {
        return NO;
    }
    NSError *jsonError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:&jsonError];
    NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
    NSString *myVersion = (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *latestVersion = [jsonDictionary objectForKey:@"latest"];
    upgradeUrl = [jsonDictionary objectForKey:@"url"];
	NSArray *notUpgradableVersions = [jsonDictionary objectForKey:@"do-not-upgrade"];
	
	// check if this version is currently the latest
    if (![myVersion isEqualToString:latestVersion])
    {
		// check for non-upgradable versions
		for(int i=0; i < notUpgradableVersions.count; i++)
		{
			if ([myVersion isEqualToString:(NSString*)[notUpgradableVersions objectAtIndex:i]])
			{
				NSAlert *cannotUpgradeAlert = [NSAlert new];
				[cannotUpgradeAlert setMessageText:@"Cannot Upgrade This App"];
				[cannotUpgradeAlert setInformativeText:@"A new version of Appium.app is available but this version of Appium.app cannot be upgraded.\n\nPlease download the latest version from http://appium.io"];
				[cannotUpgradeAlert runModal];
				return NO;
			}
		}
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
    [mainWindowController.model killServer];
    
    AppiumInstallationWindowController *installationWindow = [[AppiumInstallationWindowController alloc] initWithWindowNibName:@"AppiumInstallationWindow"];
    [[mainWindowController window] close];
    [installationWindow performSelectorOnMainThread:@selector(showWindow:) withObject:self waitUntilDone:YES];
    [[installationWindow window] makeKeyAndOrderFront:self];
    [[installationWindow messageLabel] performSelectorOnMainThread:@selector(setStringValue:) withObject:@"Downloading Appium.app..." waitUntilDone:YES];
    
    // download latest appium.app
    NSLog(@"Downloading Appium app from \"%@.\"", upgradeUrl);
    NSURL  *url = [NSURL URLWithString:upgradeUrl];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if (!urlData)
    {
        return;
    }
    
	NSString *dmgPath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],@"appium.dmg"];
	NSString *destinationPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [urlData writeToFile:dmgPath atomically:YES];
    
	NSString *upgradeScriptPath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Upgrade.applescript"];
    NSTask *restartTask = [NSTask new];
    [restartTask setLaunchPath:@"/bin/sh"];
    [restartTask setArguments:[NSArray arrayWithObjects: @"-c",[NSString stringWithFormat:@"sleep 2; rm -f /tmp/appium-updater /tmp/appium-upgrade.applescript /tmp/appium.dmg; cp \"%@\" /tmp/appium-upgrade.applescript; cp \"%@\" /tmp/appium.dmg; cp /usr/bin/osascript /tmp/appium-updater; /tmp/appium-updater /tmp/appium-upgrade.applescript \"/tmp/appium.dmg\" \"/Volumes/Appium\" \"/Volumes/Appium/Appium.app\" \"%@\" \"%@\" ; open \"%@\"", upgradeScriptPath, dmgPath, [[NSBundle mainBundle] bundlePath], destinationPath, [[NSBundle mainBundle] bundlePath] ], nil]];
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
    NSString *packagePath = [NSString stringWithFormat:@"%@/%@", [[mainWindowController node] pathtoPackage:@"appium"], @"package.json"];
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
        [mainWindowController.model killServer];
        [self performSelectorInBackground:@selector(updateAppiumPackage) withObject:nil];
    }
}

-(void) updateAppiumPackage
{
    AppiumInstallationWindowController *installationWindow = [[AppiumInstallationWindowController alloc] initWithWindowNibName:@"AppiumInstallationWindow"];
    [installationWindow performSelectorOnMainThread:@selector(showWindow:) withObject:self waitUntilDone:YES];
    [[installationWindow window] makeKeyAndOrderFront:self];
    [[mainWindowController window] orderOut:self];
    [[installationWindow messageLabel] performSelectorOnMainThread:@selector(setStringValue:) withObject:@"Updating Appium Package..." waitUntilDone:YES];

    [[mainWindowController node] installPackage:@"appium" forceInstall:YES];
    
	NSString *iwdPath = [NSString stringWithFormat:@"%@/submodules/instruments-without-delay/build", [[mainWindowController node] pathtoPackage:@"appium"]];
	if (![[NSFileManager defaultManager] fileExistsAtPath:iwdPath])
    {
		NSString *submodulesPath = [NSString stringWithFormat:@"%@/submodules", [[mainWindowController node] pathtoPackage:@"appium"]];
		[[installationWindow messageLabel] performSelectorOnMainThread:@selector(setStringValue:) withObject:@"Building \"Instruments Without Delay\"..." waitUntilDone:YES];
		[Utility runTaskWithBinary:@"/bin/sh" arguments:[NSArray arrayWithObjects:@"./build.sh", nil] path:[NSString stringWithFormat:@"%@/%@", submodulesPath, @"instruments-without-delay"]];
    }
	
    [[mainWindowController window] makeKeyAndOrderFront:self];
    [installationWindow close];
    NSAlert *upgradeCompleteAlert = [NSAlert new];
    [upgradeCompleteAlert setMessageText:@"Upgrade Complete"];
    [upgradeCompleteAlert setInformativeText:@"The package was installed successfully"];
    [upgradeCompleteAlert performSelectorOnMainThread:@selector(runModal) withObject:nil waitUntilDone:YES];
}

@end
