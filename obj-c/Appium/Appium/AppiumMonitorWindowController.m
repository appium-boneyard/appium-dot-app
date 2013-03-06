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
    NSPipe *pipe = [NSPipe pipe];
    [serverTask setStandardOutput: pipe];
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
    //[self checkForUpdate];
    [self checkForAppiumUpdate];
}

-(void) checkForUpdate
{
    // check github for the latest version
    NSString *stringURL = @"https://raw.github.com/appium/appium-dot-app/master/obj-c/Appium/Appium/Appium-Info.plist";
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if (!urlData)
    {
        return;
    }
    
    // parse plist
    NSString *error=nil;
    NSPropertyListFormat format;
    NSDictionary* plist = [NSPropertyListSerialization propertyListFromData:urlData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
    NSString *latestVersion = (NSString*)[plist objectForKey:@"CFBundleShortVersionString"];

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
        [self killServer];
        
        // TODO: add install upgrade code here
        
        [(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] restart];
    }
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
