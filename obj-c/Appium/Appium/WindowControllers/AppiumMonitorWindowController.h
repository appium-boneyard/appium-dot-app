//
//  AppiumMonitorWindowController.h
//  Appium
//
//  Created by Dan Cuellar on 3/3/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NodeInstance.h"
#import "AppiumModel.h"

@interface AppiumMonitorWindowController : NSWindowController
@property (weak) IBOutlet NSTextField *ipAddressTextField;
@property (weak) IBOutlet NSTextField *portTextField;
@property (weak) IBOutlet NSButton *launchButton;
@property (weak) IBOutlet NSButton *appPathCheckBox;
@property (weak) IBOutlet NSButton *appPathChooseButton;
@property (unsafe_unretained) IBOutlet NSTextView *logTextView;
@property (weak) IBOutlet NSPathControl *appPathControl;
@property (weak) IBOutlet NSTextField *udidTextField;
@property (weak) IBOutlet NSButton *udidCheckBox;

@property (nonatomic, retain) NodeInstance *node;
@property (readonly) AppiumModel *model;

-(BOOL)killServer;
-(IBAction)clearLog:(id)sender;
-(IBAction) launchButtonClicked:(id)sender;

@end
