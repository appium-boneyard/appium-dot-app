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
    [serverTask setLaunchPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle]resourcePath], @"node/bin/node"]];
    
	// build arguments
    NSArray *arguments = [NSMutableArray arrayWithObjects: @"server.js", nil];
	
	if (![[[self model] ipAddress] isEqualTo:@"0.0.0.0"])
    {
        arguments = [arguments arrayByAddingObject:@"--address"];
        arguments = [arguments arrayByAddingObject:[[self model] ipAddress]];
    }
	if (![[[self model] port] isEqualTo:@"4723"])
    {
        arguments = [arguments arrayByAddingObject:@"--port"];
        arguments = [arguments arrayByAddingObject:[[[self model] port]stringValue]];
    }
    if ([[self model] useAppPath])
    {
        arguments = [arguments arrayByAddingObject:@"--app"];
        arguments = [arguments arrayByAddingObject:[[self model] appPath]];
    }
	if ([[self model] useUDID])
    {
        arguments = [arguments arrayByAddingObject:@"--udid"];
        arguments = [arguments arrayByAddingObject:[[self model] udid]];
    }
	if ([[self model] prelaunchApp])
    {
        arguments = [arguments arrayByAddingObject:@"--pre-launch"];
    }
	if ([[self model] resetApplicationState])
    {
        arguments = [arguments arrayByAddingObject:@"--no-reset"];
    }
	if ([[self model] keepArtifacts])
    {
        arguments = [arguments arrayByAddingObject:@"--keep-artifacts"];
    }
	if ([[self model] logVerbose])
    {
        arguments = [arguments arrayByAddingObject:@"--verbose"];
    }
	if ([[self model] useWarp])
    {
        arguments = [arguments arrayByAddingObject:@"--warp"];
        arguments = [arguments arrayByAddingObject:@"1"];
    }
    
    // iOS Prefs
    if ([[self model] platform] == Platform_iOS)
    {
        if ([[self model] useInstrumentsWithoutDelay])
        {
            arguments = [arguments arrayByAddingObject:@"--without-delay"];
        }
        if ([[self model] forceDevice])
        {
            if ([[self model] deviceToForce] == iOSAutomationDevice_iPhone)
            {
                arguments = [arguments arrayByAddingObject:@"--force-iphone"];
            }
            else if ([[self model] deviceToForce] == iOSAutomationDevice_iPad)
            {
                arguments = [arguments arrayByAddingObject:@"--force-ipad"];
            }
        }
    }
    
    // Android Prefs
    if ([[self model] platform] == Platform_Android)
    {
        if ([[self model] skipAndroidInstall])
        {
            arguments = [arguments arrayByAddingObject:@"--skip-install"];
        }
        if ([[self model] useAndroidPackage])
        {
            arguments = [arguments arrayByAddingObject:@"--app-pkg"];
			arguments = [arguments arrayByAddingObject:[[self model] androidPackage]];
        }
        if ([[self model] useAndroidActivity])
        {
            arguments = [arguments arrayByAddingObject:@"--app-activity"];
            arguments = [arguments arrayByAddingObject:[[self model] androidActivity]];
        }
    }
    
    [serverTask setArguments: arguments];
    
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
    [[self model] setIsServerRunning:NO];
}

-(IBAction)chooseFile:(id)sender
{
	NSString *selectedApp = [[self appPathControl] stringValue];
	
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	[openDlg setShowsHiddenFiles:YES];
	[openDlg setAllowedFileTypes:[NSArray arrayWithObjects:@"app", @"apk", nil]];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:NO];
    [openDlg setPrompt:@"Select Mobile Application"];
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
		[[self appPathControl] setStringValue:selectedApp];
    }
}

-(IBAction)clearLog:(id)sender
{
    [[self logTextView] setString:@""];
}

@end
