//
//  AppiumMonitorWindowController.m
//  Appium
//
//  Created by Dan Cuellar on 3/3/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumMonitorWindowController.h"
#import "NodeInstance.h"
#import "ANSIUtility.h"

NSTask *serverTask;

@interface AppiumMonitorWindowController ()

@end

@implementation AppiumMonitorWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        [self setIsServerRunning:[NSNumber numberWithBool:NO]];
        [self setIsAppCheckboxChecked:[NSNumber numberWithBool:NO]];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
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
    
    serverTask = [NSTask new];
    [serverTask setCurrentDirectoryPath:[[NSBundle mainBundle] resourcePath]];
    [serverTask setLaunchPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle]resourcePath], @"node/bin/node"]];
    
    NSArray *arguments = [NSMutableArray arrayWithObjects: @"appium.js", @"-a", [[self ipAddressTextField] stringValue], @"-p", [[self portTextField] stringValue], nil];
    arguments = [arguments arrayByAddingObject:@"-V"];
    arguments = ([[self verboseCheckBox] state] == NSOnState) ? [arguments arrayByAddingObject:@"1"] : [arguments arrayByAddingObject:@"0"];
    if ([[self appPathCheckBox]state] == NSOnState)
    {
        arguments = [arguments arrayByAddingObject:@"--app"];
        arguments = [arguments arrayByAddingObject:[[self appPathTextField] stringValue]];
    }
    
    [serverTask setArguments: arguments];
    
    NSPipe *pipe = [NSPipe pipe];
    [serverTask setStandardOutput: pipe];
    [serverTask setStandardInput:[NSPipe pipe]];
    
    [self setIsServerRunning:[NSNumber numberWithBool:YES]];
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
}

-(IBAction)chooseFile:(id)sender
{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setPrompt:@"Select"];
    NSURL *startingPath = [[[self appPathTextField] stringValue] isEqualToString:@""] ? [NSURL fileURLWithPath:NSHomeDirectory()] : [[self appPathTextField]stringValue];
    [openDlg setDirectoryURL:startingPath];
    if ([openDlg runModal] == NSOKButton)
    {
        [[self appPathTextField] setStringValue:[[[openDlg URLs] objectAtIndex:0] path]];
    }
}


@end
