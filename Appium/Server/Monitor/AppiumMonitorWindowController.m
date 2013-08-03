//
//  AppiumMonitorWindowController.m
//  Appium
//
//  Created by Dan Cuellar on 3/3/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumMonitorWindowController.h"

#import "AppiumAppDelegate.h"
#import "ANSIUtility.h"
#import "Utility.h"

@implementation AppiumMonitorWindowController

-(id)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-init is not a valid initializer for the class AppiumMonitorWindowController"
                                 userInfo:nil];
    return nil;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
		// initialization code here
    }

    return self;
}

-(void) windowDidLoad
{
    [super windowDidLoad];
	_menuBarManager = [AppiumMenuBarManager new];
	[[self model] addObserver:_menuBarManager forKeyPath:@"isServerRunning" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)windowWillClose:(NSNotification *)notification {
    [[NSApplication sharedApplication] terminate:self];
}

-(AppiumModel*) model { return [(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] model]; }

- (IBAction) launchButtonClicked:(id)sender
{
    if ([self.model startServer])
    {
        [self performSelectorInBackground:@selector(errorLoop) withObject:nil];
        [self performSelectorInBackground:@selector(readLoop) withObject:nil];
        [self performSelectorInBackground:@selector(exitWait) withObject:nil];
    }
}

-(void) readLoop
{
    NSFileHandle *serverStdOut = [self.model.serverTask.standardOutput fileHandleForReading];
    NSMutableDictionary *previousAttributes = [NSMutableDictionary new];
    while(self.model.serverTask.isRunning)
    {
        NSData *data = [serverStdOut availableData];

        NSString *string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
        NSAttributedString *attributedString = [ANSIUtility processIncomingStream:string withPreviousAttributes:&previousAttributes];
        [self performSelectorOnMainThread:@selector(appendToLog:) withObject:attributedString waitUntilDone:YES];
    }
	[serverStdOut closeFile];
}

-(void) errorLoop
{
	NSFileHandle *serverStdErr = [self.model.serverTask.standardError fileHandleForReading];
    NSMutableDictionary *previousAttributes = [NSMutableDictionary new];
	while(self.model.serverTask.isRunning)
    {
        NSData *data = [serverStdErr availableData];

        NSString *string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
        NSAttributedString *attributedString = [ANSIUtility processIncomingStream:string withPreviousAttributes:&previousAttributes];
        [self performSelectorOnMainThread:@selector(appendToLog:) withObject:attributedString waitUntilDone:YES];
    }
	[serverStdErr closeFile];
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
    [self.model.serverTask waitUntilExit];
    [self.model setIsServerRunning:NO];
}

-(IBAction)chooseFile:(id)sender
{
	NSString *selectedApp = [self.model appPath];

    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	[openDlg setShowsHiddenFiles:YES];
	[openDlg setAllowedFileTypes:[NSArray arrayWithObjects:@"app", @"apk", @"zip", @"ipa", nil]];
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
		[self.model setAppPath:selectedApp];
    }
}

-(IBAction)clearLog:(id)sender
{
    [[self logTextView] setString:@""];
}

-(IBAction)displayInspector:(id)sender
{
	[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] displayInspector:nil];
}

@end
