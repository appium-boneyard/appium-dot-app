//
//  AppiumMonitorWindowController.m
//  Appium
//
//  Created by Dan Cuellar on 3/3/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumMainWindowController.h"
#import "AppiumAppDelegate.h"
#import "ANSIUtility.h"
#import "Utility.h"

@implementation AppiumMainWindowController

-(id)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-init is not a valid initializer for the class AppiumMainWindowController"
                                 userInfo:nil];
    return nil;
}

- (id)initWithWindow:(NSWindow *)window
{
	self = [super initWithWindow:window];
	
	if (self)
	{
		self.inspectorIsLaunching = NO;
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
	// Prevent startDoctor from being run for now due to issue #374
	[self.model startExternalDoctor];
	return;
	
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
	BOOL scrollToBottom;
	
	if (!self.model.general.forceScrollLog)
	{
		// Check if the scroll position is within 30 pixels of the bottom of the view
		scrollToBottom = (((self.logTextView.visibleRect.origin.y + self.logTextView.superview.frame.size.height) - self.logTextView.bounds.size.height) >= -30.0f);
	}
	else
	{
		scrollToBottom = YES;
	}
	
	NSTextStorage *textStorage = self.logTextView.textStorage;
	
    [textStorage beginEditing];
    [textStorage appendAttributedString:string];
	
	if ([textStorage length] > self.model.maxLogLength)
	{
		// Remove characters from the start of the log to make space
		[textStorage deleteCharactersInRange:NSMakeRange(0, [string length])];
	}
	
    [textStorage endEditing];
	
	if (scrollToBottom)
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

-(IBAction)clearLog:(id)sender
{
    [[self logTextView] setString:@""];
}

-(IBAction)displayInspector:(id)sender
{
	[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] displayInspector:nil];
}

-(void) closeAllPopovers
{
	for(NSView* button in [_buttonBarView subviews]) {
		if ([button isKindOfClass:[AppiumMainWindowPopOverButton class]]) {
			[((AppiumMainWindowPopOverButton*)button).popoverController close];
		}
	}
}

@end
