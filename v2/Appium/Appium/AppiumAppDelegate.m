//
//  AppiumAppDelegate.m
//  Appium
//
//  Created by Dan Cuellar on 3/3/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumAppDelegate.h"
#import "Utility.h"
#import "ANSIUtility.h"
#import "NodeInstance.h"

NSTask *serverTask;
NodeInstance *node;

@implementation AppiumAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [self performSelectorInBackground:@selector(install) withObject:nil];
    
}

-(void)applicationWillTerminate:(NSNotification *)notification
{
    [self killServer];
}

-(void)killServer
{
    if (serverTask != nil && [serverTask isRunning])
    {
        [serverTask terminate];
    }
}

-(void) install
{
    [[self window] orderOut:self];
    [[self installationWindow] makeKeyAndOrderFront:self];
    [[self installationMessageLabel] performSelectorOnMainThread:@selector(setStringValue:) withObject:@"Installing NodeJS..." waitUntilDone:YES];
    node = [[NodeInstance alloc] initWithPath:[[NSBundle mainBundle] resourcePath]];
        [[self installationMessageLabel] performSelectorOnMainThread:@selector(setStringValue:) withObject:@"Installing Appium Prerequisites..." waitUntilDone:YES];
    [node installPackageWithNPM:@"argparse"];
    [[self installationMessageLabel] performSelectorOnMainThread:@selector(setStringValue:) withObject:@"Installing Appium..." waitUntilDone:YES];
    [node installPackageWithNPM:@"appium"];
    [[self installationWindow] close];
    [[self window] makeKeyAndOrderFront:self];
}

- (IBAction) launchAppium:(id)sender
{
    [self killServer];
    serverTask = [NSTask new];
    [serverTask setCurrentDirectoryPath:[[NSBundle mainBundle] resourcePath]];
    [serverTask setLaunchPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle]resourcePath], @"node/bin/node"]];
    
    NSArray *arguments = [NSMutableArray arrayWithObjects: @"appium.js", @"-a", [[self ipAddressTextField] stringValue], @"-p", [[self portTextField] stringValue], nil];
    arguments = [arguments arrayByAddingObject:@"-V"];
    arguments = ([[self verboseCheckBox] state] == NSOnState) ? [arguments arrayByAddingObject:@"1"] : [arguments arrayByAddingObject:@"0"];

    [serverTask setArguments: arguments];
    
    NSPipe *pipe = [NSPipe pipe];
    [serverTask setStandardOutput: pipe];
    [serverTask setStandardInput:[NSPipe pipe]];
    
    [serverTask launch];

    [self performSelectorInBackground:@selector(readLoop) withObject:nil];
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

@end
