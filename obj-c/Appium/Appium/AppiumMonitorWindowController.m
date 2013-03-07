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
#import "Constants.h"

NSTask *serverTask;
AppiumMenuBarManager *menuBarManager;

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
	menuBarManager = [AppiumMenuBarManager new];
	[self addObserver:menuBarManager forKeyPath:@"isServerRunning" options:NSKeyValueObservingOptionNew context:NULL];
}

-(BOOL)killServer
{
    if (serverTask != nil && [serverTask isRunning])
    {
        [serverTask terminate];
		[self setIsServerRunning:NO];
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
	if ([[NSUserDefaults standardUserDefaults] boolForKey:PLIST_PRELAUNCH])
    {
        arguments = [arguments arrayByAddingObject:@"--pre-launch"];
    }
	if (![[NSUserDefaults standardUserDefaults] boolForKey:PLIST_RESET_APPLICATION_STATE])
    {
        arguments = [arguments arrayByAddingObject:@"--no-reset"];
    }
	if ([[NSUserDefaults standardUserDefaults] boolForKey:PLIST_KEEP_ARTIFACTS])
    {
        arguments = [arguments arrayByAddingObject:@"--keep-artifacts"];
    }
	if ([[NSUserDefaults standardUserDefaults] boolForKey:PLIST_VERBOSE])
    {
        arguments = [arguments arrayByAddingObject:@"--verbose"];
    }
	if ([[NSUserDefaults standardUserDefaults] boolForKey:PLIST_USE_WARP])
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

-(IBAction)clearLog:(id)sender
{
    [[self logTextView] setString:@""];
}

@end
