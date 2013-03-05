//
//  AppiumMonitorWindowController.h
//  Appium
//
//  Created by Dan Cuellar on 3/3/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NodeInstance.h"

@interface AppiumMonitorWindowController : NSWindowController
@property (weak) IBOutlet NSTextField *ipAddressTextField;
@property (weak) IBOutlet NSTextField *portTextField;
@property (weak) IBOutlet NSButton *verboseCheckBox;
@property (weak) IBOutlet NSButton *launchButton;
@property (weak) IBOutlet NSButton *appPathCheckBox;
@property (weak) IBOutlet NSTextField *appPathTextField;
@property (weak) IBOutlet NSButton *appPathChooseButton;
@property (unsafe_unretained) IBOutlet NSTextView *logTextView;


@property (weak) NSNumber* isServerRunning;
@property (nonatomic, retain) NodeInstance *node;
@property (nonatomic, retain) NSNumber *isAppCheckboxChecked;


-(BOOL)killServer;
-(void) checkForUpdates;
-(IBAction)clearLog:(id)sender;

@end
