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
	
	// launch the menu bar icon
	_menuBarManager = [AppiumMenuBarManager new];
	[[self model] addObserver:_menuBarManager forKeyPath:@"isServerRunning" options:NSKeyValueObservingOptionNew context:NULL];

}

- (void)windowWillClose:(NSNotification *)notification {
    [[NSApplication sharedApplication] terminate:self];
}

-(AppiumModel*) model { return [(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] model]; }

- (IBAction) launchButtonClicked:(id)sender
{
    if (!self.model.doctorSocketIsConnected && [self.model startServer])
    {
		[self closeAllPopovers];
        [self performSelectorInBackground:@selector(errorLoop) withObject:nil];
        [self performSelectorInBackground:@selector(readLoop) withObject:nil];
        [self performSelectorInBackground:@selector(exitWait) withObject:nil];
    }
}

-(IBAction)doctorButtonClicked:(id)sender
{
    if ([self.model startDoctor])
    {
		[self closeAllPopovers];
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
	// Check if the scroll position is within 30 pixels of the bottom of the view
	BOOL scrolledToBottom = (((self.logTextView.visibleRect.origin.y + self.logTextView.superview.frame.size.height) - self.logTextView.bounds.size.height) >= -30.0f);
	
    [[self.logTextView textStorage] beginEditing];
    [[self.logTextView textStorage] appendAttributedString:string];
    [[self.logTextView textStorage] endEditing];
	
	if (scrolledToBottom)
	{
		NSRange range = NSMakeRange ([[self.logTextView string] length], 0);
	
		[self.logTextView scrollRangeToVisible: range];
	}
}

-(void) exitWait
{
    [self.model.serverTask waitUntilExit];
    [self.model setIsServerRunning:NO];
}

-(IBAction)chooseAndroidApp:(id)sender
{
	NSString *selectedApp = self.model.android.appPath;

    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	[openDlg setShowsHiddenFiles:YES];
	[openDlg setAllowedFileTypes:[NSArray arrayWithObjects:@"apk", @"zip", nil]];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:NO];
    [openDlg setPrompt:@"Select Android Application"];
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
		[self.model.android setAppPath:selectedApp];
    }
}

-(IBAction)chooseiOSApp:(id)sender
{
	NSString *selectedApp = self.model.iOS.appPath;
	
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	[openDlg setShowsHiddenFiles:YES];
	[openDlg setAllowedFileTypes:[NSArray arrayWithObjects:@"app", @"zip", @"ipa", nil]];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:NO];
    [openDlg setPrompt:@"Select iOS Application"];
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
		[self.model.iOS setAppPath:selectedApp];
    }
}

-(IBAction)chooseiOSTraceTemplate:(id)sender
{
	NSString *selectedTemplate = self.model.iOS.customTraceTemplatePath;
	
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	[openDlg setShowsHiddenFiles:YES];
	[openDlg setAllowedFileTypes:[NSArray arrayWithObjects:@"tracetemplate", nil]];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:NO];
    [openDlg setPrompt:@"Select Instruments Trace Templates"];
	if (selectedTemplate == nil || [selectedTemplate isEqualToString:@"/"])
	{
	    [openDlg setDirectoryURL:[NSURL fileURLWithPath:NSHomeDirectory()]];
	}
	else
	{
		[openDlg setDirectoryURL:[NSURL fileURLWithPath:[selectedTemplate stringByDeletingLastPathComponent]]];
	}
	
    if ([openDlg runModal] == NSOKButton)
    {
		selectedTemplate = [[[openDlg URLs] objectAtIndex:0] path];
		[self.model.iOS setCustomTraceTemplatePath:selectedTemplate];
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

-(IBAction)chooseXcodePath:(id)sender
{
	NSString *selectedApp = self.model.iOS.xcodePath;
	
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	[openDlg setShowsHiddenFiles:YES];
	[openDlg setAllowedFileTypes:[NSArray arrayWithObjects:@"app", nil]];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:NO];
    [openDlg setPrompt:@"Select Xcode Application"];
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
		[self.model.iOS setXcodePath:selectedApp];
    }
}

-(void) closeAllPopovers
{
	for(NSView* button in [buttonBarView subviews]) {
		if ([button isKindOfClass:[AppiumMonitorWindowPopOverButton class]]) {
			[((AppiumMonitorWindowPopOverButton*)button).popoverController close];
		}
	}
}

@end
