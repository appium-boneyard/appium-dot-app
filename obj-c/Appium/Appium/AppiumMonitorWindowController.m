//
//  AppiumMonitorWindowController.m
//  Appium
//
//  Created by Dan Cuellar on 3/3/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumAppDelegate.h"
#import "AppiumMonitorWindowController.h"
#import "NodeInstance.h"
#import "ANSIUtility.h"
#import "Utility.h"
#import "AppiumInstallationWindowController.h"

NSTask *serverTask;
NSStatusItem *statusItem;

@interface AppiumMonitorWindowController ()

@end

@implementation AppiumMonitorWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        [self setIsServerRunning:[NSNumber numberWithBool:NO]];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self activateStatusMenu];
}

- (void)activateStatusMenu {
    
    // add icon
    NSStatusBar *bar = [NSStatusBar systemStatusBar];
    statusItem = [bar statusItemWithLength:NSVariableStatusItemLength];
    NSImage *iconImage = [[NSApplication sharedApplication] applicationIconImage];
    NSSize newSize = [iconImage size];
    newSize.height = 18;
    newSize.width = 18;
    [iconImage setSize:newSize];
    [statusItem setImage:iconImage];
    [statusItem setHighlightMode:YES];
    
    // add menu
    [statusItem setMenu:[NSMenu new]];
    [[statusItem menu] addItemWithTitle:@"Start Server" action:@selector(launchButtonClicked:) keyEquivalent:@""];
}

-(BOOL)killServer
{
    if (serverTask != nil && [serverTask isRunning])
    {
        [serverTask terminate];
        return YES;
    }
    return NO;
}

- (IBAction) launchButtonClicked:(id)sender
{
    if ([self killServer])
    {
        return;
    }
    
	// get binary path
    serverTask = [NSTask new];
    [serverTask setCurrentDirectoryPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle]resourcePath], @"node_modules/appium"]];
    [serverTask setLaunchPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle]resourcePath], @"node/bin/node"]];
    
	// build arguments
    NSArray *arguments = [NSMutableArray arrayWithObjects: @"server.js", nil];
	
	if (![[[self ipAddressTextField] stringValue] isEqualTo:@"127.0.0.1"])
    {
        arguments = [arguments arrayByAddingObject:@"--address"];
        arguments = [arguments arrayByAddingObject:[[self ipAddressTextField] stringValue]];
    }
	if (![[[self portTextField] stringValue] isEqualTo:@"4723"])
    {
        arguments = [arguments arrayByAddingObject:@"--port"];
        arguments = [arguments arrayByAddingObject:[[self portTextField] stringValue]];
    }
    if ([[self appPathCheckBox]state] == NSOnState)
    {
        arguments = [arguments arrayByAddingObject:@"--app"];
        arguments = [arguments arrayByAddingObject:[[self appPathControl] stringValue]];
    }
	if ([[self udidCheckBox]state] == NSOnState)
    {
        arguments = [arguments arrayByAddingObject:@"--udid"];
        arguments = [arguments arrayByAddingObject:[[self udidTextField] stringValue]];
    }
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Prelaunch"])
    {
        arguments = [arguments arrayByAddingObject:@"--pre-launch"];
    }
	if (![[NSUserDefaults standardUserDefaults] boolForKey:@"Clean Application State"])
    {
        arguments = [arguments arrayByAddingObject:@"--no-reset"];
    }
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Keep Artifacts"])
    {
        arguments = [arguments arrayByAddingObject:@"--keep-artifacts"];
    }
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Verbose"])
    {
        arguments = [arguments arrayByAddingObject:@"--verbose"];
    }
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Use Warp"])
    {
        arguments = [arguments arrayByAddingObject:@"--warp"];
        arguments = [arguments arrayByAddingObject:@"1"];
    }
    [serverTask setArguments: arguments];
    
	// redirect i/o
    [serverTask setStandardOutput:[NSPipe pipe]];
	[serverTask setStandardError:[NSPipe pipe]];
    [serverTask setStandardInput:[NSPipe pipe]];
    
    // set status
    [self setIsServerRunning:[NSNumber numberWithBool:YES]];
	
	// update menubar
	NSMenuItem *stopServerItem = [NSMenuItem new];
    [stopServerItem setTitle:@"Stop Server"];
    [stopServerItem setHidden:NO];
	[stopServerItem setAction:@selector(launchButtonClicked:)];
    NSMenuItem *addressItem = [NSMenuItem new];
    [addressItem setTitle:[NSString stringWithFormat:@"Address: %@", [[self ipAddressTextField] stringValue]]];
    [addressItem setHidden:NO];
    NSMenuItem *portItem = [NSMenuItem new];
    [portItem setTitle:[NSString stringWithFormat:@"Port: %@", [[self portTextField] stringValue]]];
    [portItem setHidden:NO];
    [[statusItem menu] removeAllItems];
    [[statusItem menu] addItem:stopServerItem];
	[[statusItem menu] addItem:[NSMenuItem separatorItem]];
    [[statusItem menu] addItem:addressItem];
    [[statusItem menu] addItem:portItem];
    
	// launch
    [serverTask launch];
	[self performSelectorInBackground:@selector(errorLoop) withObject:nil];
    [self performSelectorInBackground:@selector(readLoop) withObject:nil];
    [self performSelectorInBackground:@selector(exitWait) withObject:nil];
}

-(void) readLoop
{
    NSFileHandle *serverStdOut = [[serverTask standardOutput] fileHandleForReading];
    NSString *buffer = [NSString new];
    NSMutableDictionary *previousAttributes = [NSMutableDictionary new];
    while([serverTask isRunning])
    {
        NSData *data = [serverStdOut readDataOfLength:1];
        
        NSString *string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
        buffer = [buffer stringByAppendingString:string];
        if ([string isEqualToString:@"\n"])
        {
            NSAttributedString *attributedString = [ANSIUtility processIncomingStream:buffer withPreviousAttributes:&previousAttributes];
            [self performSelectorOnMainThread:@selector(appendToLog:) withObject:attributedString waitUntilDone:YES];
            buffer = [NSString new];
        }
    }
}

-(void) errorLoop
{
	NSFileHandle *serverStdErr = [[serverTask standardError] fileHandleForReading];
	NSData *errorData = [serverStdErr readDataToEndOfFile];
	NSString *string = [[NSString alloc] initWithData: errorData encoding: NSUTF8StringEncoding];
	if (string != nil && [string length] > 0)
	{
		NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
		[attributedString addAttribute:NSForegroundColorAttributeName value:[NSColor redColor] range:NSMakeRange(0,[string length]-1)];
		[self performSelectorOnMainThread:@selector(appendToLog:) withObject:attributedString waitUntilDone:YES];
	}
}

-(void) appendToLog:(NSAttributedString*)string
{
    [[self.logTextView textStorage] beginEditing];
    [[self.logTextView textStorage] appendAttributedString:string];
    [[self.logTextView textStorage] endEditing];
    
    NSRange range = NSMakeRange ([[self.logTextView string] length], 0);
    
    [self.logTextView scrollRangeToVisible: range];
}

-(void) exitWait
{
    [serverTask waitUntilExit];
    [self setIsServerRunning:NO];
    [[statusItem menu] removeAllItems];
    [[statusItem menu] addItemWithTitle:@"Start Server" action:@selector(launchButtonClicked:) keyEquivalent:@""];
}

-(IBAction)chooseFile:(id)sender
{
	NSString *selectedApp = [[self appPathControl] stringValue];
	
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	[openDlg setShowsHiddenFiles:YES];
	[openDlg setAllowedFileTypes:[NSArray arrayWithObjects:@"app",nil]];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:NO];
    [openDlg setPrompt:@"Select"];
	if ([selectedApp isEqualTo:@"/"])
	{
	    [openDlg setDirectoryURL:[NSURL fileURLWithPath:NSHomeDirectory()]];
	}
	else
	{
		[openDlg setDirectoryURL:[NSURL fileURLWithPath:[selectedApp stringByDeletingLastPathComponent]]];
	}
	

    if ([openDlg runModal] == NSOKButton)
    {
		selectedApp = [[[openDlg URLs] objectAtIndex:0] path];
		[[self appPathControl] setStringValue:selectedApp];
    }
}

-(void) checkForUpdates
{
    [self checkForUpdate];
    [self checkForAppiumUpdate];
}

-(void) checkForUpdate
{
    // check github for the latest version
    NSString *stringURL = @"https://raw.github.com/appium/appium.github.com/master/autoupdate/Appium.app.version";
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if (!urlData)
    {
        return;
    }
    NSString *latestVersion = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];

    // check the local copy of appium
    NSString *myVersion = (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if (![myVersion isEqualToString:latestVersion])
    {
        [self performSelectorOnMainThread:@selector(doUpgradeAlert:) withObject:[NSArray arrayWithObjects:myVersion, latestVersion, nil] waitUntilDone:NO];
    }
}

-(void) checkForAppiumUpdate
{
    // check github for the latest version
    NSString *stringURL = @"https://raw.github.com/appium/appium/master/package.json";
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if (!urlData)
    {
        return;
    }
    NSError *jsonError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:&jsonError];
    NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
    NSString *latestVersion = [jsonDictionary objectForKey:@"version"];
    NSString *myVersion;
    
    // check the local copy of appium
    NSString *packagePath = [[self node] pathtoPackage:@"appium"];
    if ([[NSFileManager defaultManager] fileExistsAtPath: packagePath])
    {
        NSData *data = [NSData dataWithContentsOfFile:packagePath];
        jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        jsonDictionary = (NSDictionary *)jsonObject;
        myVersion = [jsonDictionary objectForKey:@"version"];
    }
    if (![myVersion isEqualToString:latestVersion])
    {
        [self performSelectorOnMainThread:@selector(doAppiumUpgradeAlert:) withObject:[NSArray arrayWithObjects:myVersion, latestVersion, nil] waitUntilDone:NO];
    }
}

-(void)doUpgradeAlert:(NSArray*)versions
{
    NSAlert *upgradeAlert = [NSAlert new];
    [upgradeAlert setMessageText:@"Appium.app Upgrade Available"];
    [upgradeAlert setInformativeText:[NSString stringWithFormat:@"Would you like to stop the server and download the latest version of Appium.app?\n\nYour Version:\t%@\nLatest Version:\t%@", [versions objectAtIndex:0], [versions objectAtIndex:1]]];
    [upgradeAlert addButtonWithTitle:@"No"];
    [upgradeAlert addButtonWithTitle:@"Yes"];
    if([upgradeAlert runModal] == NSAlertSecondButtonReturn)
    {
        [self performSelectorInBackground:@selector(doUpgradeInstall) withObject:nil];
    }
}

-(void)doUpgradeInstall
{
    [self killServer];
    
    AppiumInstallationWindowController *installationWindow = [[AppiumInstallationWindowController alloc] initWithWindowNibName:@"AppiumInstallationWindow"];
    [[self window] close];
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
    [urlData writeToFile:dmgPath atomically:YES];
    
    // install appium.app
    [[installationWindow messageLabel] performSelectorOnMainThread:@selector(setStringValue:) withObject:@"Mounting DiskImage..." waitUntilDone:YES];
    [Utility runTaskWithBinary:@"/usr/bin/hdiutil" arguments:[NSArray arrayWithObjects: @"attach", dmgPath, nil]];
    
    NSString *sourcePath = @"/Volumes/Appium/Appium.app";
    NSString *destinationPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    
    NSDictionary *error = [NSDictionary new];
    NSString *script =  [NSString stringWithFormat:@"do shell script \"sudo cp -rvp \\\"%@\\\" \\\"%@\\\"\" with administrator privileges", sourcePath, destinationPath];
    NSAppleScript *appleScript = [[NSAppleScript new] initWithSource:script];
    [[installationWindow messageLabel] performSelectorOnMainThread:@selector(setStringValue:) withObject:@"Installing Appium.app..." waitUntilDone:YES];
    if (![appleScript executeAndReturnError:&error])
    {
        NSAlert *alert = [NSAlert new];
        [alert setMessageText:@"Installation Failed"];
        [alert setInformativeText:@"Could not Install Appium"];
        [alert runModal];
        return;
    }
    
        [[installationWindow messageLabel] performSelectorOnMainThread:@selector(setStringValue:) withObject:@"Unmounting DiskImage..." waitUntilDone:YES];
    [Utility runTaskWithBinary:@"/usr/bin/hdiutil" arguments:[NSArray arrayWithObjects: @"detach", @"/Volumes/Appium", nil]];
    [installationWindow close];
    NSAlert *alert = [NSAlert new];
    [alert setMessageText:@"Restart Required"];
    [alert setInformativeText:@"Appium has been updated. The app will restart after you click\"OK\""];
    [alert performSelectorOnMainThread:@selector(runModal) withObject:nil waitUntilDone:YES];
    [(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] performSelectorOnMainThread:@selector(restart) withObject:nil waitUntilDone:YES];
}

-(void)doAppiumUpgradeAlert:(NSArray*)versions
{
    NSAlert *upgradeAlert = [NSAlert new];
    [upgradeAlert setMessageText:@"Appium Upgrade Available"];
    [upgradeAlert setInformativeText:[NSString stringWithFormat:@"Would you like to stop the server and download the latest version of Appium?\n\nYour Version:\t%@\nLatest Version:\t%@", [versions objectAtIndex:0], [versions objectAtIndex:1]]];
    [upgradeAlert addButtonWithTitle:@"No"];
    [upgradeAlert addButtonWithTitle:@"Yes"];
    if([upgradeAlert runModal] == NSAlertSecondButtonReturn)
    {
        [self killServer];
        [[self node] installPackage:@"appium" forceInstall:YES];
    }
}

-(IBAction)clearLog:(id)sender
{
    [[self logTextView] setString:@""];
}

@end
