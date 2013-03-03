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
#import "AppiumInstallationWindowController.h"

NSTask *serverTask;
NodeInstance *node;

@implementation AppiumAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    [self setIsServerRunning:[NSNumber numberWithBool:NO]];
    [self performSelectorInBackground:@selector(install) withObject:nil];
    
}

-(void)applicationWillTerminate:(NSNotification *)notification
{
    [self killServer];
}

-(BOOL)killServer
{
    if (serverTask != nil && [serverTask isRunning])
    {
        [serverTask terminate];
        [self setIsServerRunning:[NSNumber numberWithBool:NO]];
        return YES;
    }
    return NO;
}

-(void) install
{
    AppiumInstallationWindowController *installationWindow = [[AppiumInstallationWindowController alloc] initWithWindowNibName:@"AppiumInstallationWindow"];
    [installationWindow performSelectorOnMainThread:@selector(showWindow:) withObject:self waitUntilDone:YES];
    [[self mainWindow ]performSelectorOnMainThread:@selector(orderOut:) withObject:self waitUntilDone:YES];
    [[installationWindow window] performSelectorOnMainThread:@selector(makeKeyAndOrderFront:) withObject:self waitUntilDone:YES];
    [[installationWindow messageLabel] performSelectorOnMainThread:@selector(setStringValue:) withObject:@"Installing NodeJS..." waitUntilDone:YES];
    node = [[NodeInstance alloc] initWithPath:[[NSBundle mainBundle] resourcePath]];
        [[installationWindow messageLabel] performSelectorOnMainThread:@selector(setStringValue:) withObject:@"Installing Appium Prerequisites..." waitUntilDone:YES];
    [node installPackageWithNPM:@"argparse"];
    [[installationWindow messageLabel] performSelectorOnMainThread:@selector(setStringValue:) withObject:@"Installing Appium..." waitUntilDone:YES];
    [node installPackageWithNPM:@"appium"];
    [[installationWindow window] performSelectorOnMainThread:@selector(close) withObject:nil waitUntilDone:YES];
    [[self mainWindow] performSelectorOnMainThread:@selector(makeKeyAndOrderFront:) withObject:self waitUntilDone:YES];
}

- (IBAction) launchButtonClicked:(id)sender
{
    if ([self killServer])
    {
        [[self launchButton] setTitle:@"Launch"];
        return;
    }
    else
    {
        [self setIsServerRunning:[NSNumber numberWithBool:YES]];
        [[self launchButton] setTitle:@"Stop"];
    }
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
