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
#import "AppiumMenuBarManager.h"

NSTask *serverTask;
AppiumMenuBarManager *menuBarManager;

@interface AppiumMonitorWindowController ()

@end

@implementation AppiumMonitorWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
		// initialization code here
    }
    
    return self;
}

-(AppiumModel*) model { return [(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] model]; }

- (void)windowDidLoad
{
    [super windowDidLoad];
	menuBarManager = [AppiumMenuBarManager new];
	[[self model] addObserver:menuBarManager forKeyPath:@"isServerRunning" options:NSKeyValueObservingOptionNew context:NULL];
}

-(BOOL)killServer
{
    if (serverTask != nil && [serverTask isRunning])
    {
        [serverTask terminate];
		[[self model] setIsServerRunning:NO];
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
    [serverTask setLaunchPath:@"/bin/bash"];
    
	// build arguments
	NSString *nodeCommandString = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle]resourcePath], @"node/bin/node server.js"];
	
	if (![[[self model] ipAddress] isEqualTo:@"0.0.0.0"])
    {
		nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--address", [[self model] ipAddress]];
    }
	if (![[[self model] port] isEqualTo:@"4723"])
    {
		nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--port", [[[self model] port]stringValue]];
    }
    if ([[self model] useAppPath])
    {
		nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--app", [[[self model] appPath] stringByReplacingOccurrencesOfString:@" " withString:@"\\ "]];
    }
	if ([[self model] useUDID])
    {
		nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--udid", [[self model] udid]];
    }
	if ([[self model] prelaunchApp])
    {
		nodeCommandString = [nodeCommandString stringByAppendingString:@" --pre-launch"];
    }
	if ([[self model] resetApplicationState])
    {
		nodeCommandString = [nodeCommandString stringByAppendingString:@" --no-reset"];
    }
	if ([[self model] keepArtifacts])
    {
		nodeCommandString = [nodeCommandString stringByAppendingString:@" --keep-artifacts"];
    }
	if ([[self model] logVerbose])
    {
		nodeCommandString = [nodeCommandString stringByAppendingString:@" --verbose"];

    }
	if ([[self model] useWarp])
    {
		nodeCommandString = [nodeCommandString stringByAppendingString:@" --warp 1"];
    }
    
    // iOS Prefs
    if ([[self model] platform] == Platform_iOS)
    {
        if ([[self model] useInstrumentsWithoutDelay])
        {
			nodeCommandString = [nodeCommandString stringByAppendingString:@" --without-delay"];
        }
        if ([[self model] forceDevice])
        {
            if ([[self model] deviceToForce] == iOSAutomationDevice_iPhone)
            {
				nodeCommandString = [nodeCommandString stringByAppendingString:@" --force-iphone"];
            }
            else if ([[self model] deviceToForce] == iOSAutomationDevice_iPad)
            {
				nodeCommandString = [nodeCommandString stringByAppendingString:@" --force-ipad"];
            }
        }
    }
    
    // Android Prefs
    if ([[self model] platform] == Platform_Android)
    {
        if ([[self model] useAndroidPackage])
        {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%@\"", @"app-pkg", [[self model] androidPackage]];
        }
        if ([[self model] useAndroidActivity])
        {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%@\"", @"--app-activity", [[self model] androidActivity]];
        }
    }
    
    [serverTask setArguments: [NSMutableArray arrayWithObjects: @"-l",
							   @"-c", nodeCommandString, nil]];
    
	// redirect i/o
    [serverTask setStandardOutput:[NSPipe pipe]];
	[serverTask setStandardError:[NSPipe pipe]];
    [serverTask setStandardInput:[NSPipe pipe]];
    
    // set status
    [[self model] setIsServerRunning:YES];
	
	// launch
    [serverTask launch];
	[self performSelectorInBackground:@selector(errorLoop) withObject:nil];
    [self performSelectorInBackground:@selector(readLoop) withObject:nil];
    [self performSelectorInBackground:@selector(exitWait) withObject:nil];
}

-(void) readLoop
{
    NSFileHandle *serverStdOut = [[serverTask standardOutput] fileHandleForReading];
    NSMutableDictionary *previousAttributes = [NSMutableDictionary new];
    while([serverTask isRunning])
    {
        NSData *data = [serverStdOut availableData];
        
        NSString *string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
        NSAttributedString *attributedString = [ANSIUtility processIncomingStream:string withPreviousAttributes:&previousAttributes];
        [self performSelectorOnMainThread:@selector(appendToLog:) withObject:attributedString waitUntilDone:YES];
    }
}

-(void) errorLoop
{
	NSFileHandle *serverStdErr = [[serverTask standardError] fileHandleForReading];
    NSMutableDictionary *previousAttributes = [NSMutableDictionary new];
	while([serverTask isRunning])
    {
        NSData *data = [serverStdErr availableData];
        
        NSString *string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
        NSAttributedString *attributedString = [ANSIUtility processIncomingStream:string withPreviousAttributes:&previousAttributes];
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
    [[self model] setIsServerRunning:NO];
}

-(IBAction)chooseFile:(id)sender
{
	NSString *selectedApp = [[self model] appPath];
	
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	[openDlg setShowsHiddenFiles:YES];
	[openDlg setAllowedFileTypes:[NSArray arrayWithObjects:@"app", @"apk", nil]];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:NO];
    [openDlg setPrompt:@"Select"];
	if (selectedApp == nil || [selectedApp isEqualToString:@"/"])
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
		[[self model] setAppPath:selectedApp];
    }
}

-(IBAction)clearLog:(id)sender
{
    [[self logTextView] setString:@""];
}

@end
