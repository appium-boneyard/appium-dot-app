//
//  AppiumMonitorWindowController.h
//  Appium
//
//  Created by Dan Cuellar on 3/3/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppiumMonitorWindowPopOverViewController.h"
#import "AppiumMonitorWindowPopOverButton.h"
#import "AppiumInspectorWindowController.h"
#import "AppiumMenuBarManager.h"
#import "AppiumModel.h"
#import "NodeInstance.h"
#import "SocketIO.h"

@class AppiumMonitorWindowPopOverViewController;
@class AppiumInspectorWindowController;
@class AppiumMenuBarManager;
@class AppiumModel;
@class NodeInstance;

@interface AppiumMonitorWindowController : NSWindowController<NSWindowDelegate> {
    
	@private
    
	AppiumMenuBarManager *_menuBarManager;
    AppiumInspectorWindowController *_inspectorWindow;
	
	IBOutlet NSView *buttonBarView;
	IBOutlet AppiumMonitorWindowPopOverButton *androidPrefsButton;
	IBOutlet AppiumMonitorWindowPopOverButton *iOSPrefsButton;
	IBOutlet NSButtonCell *androidRadioButton;
	IBOutlet NSButtonCell *iOSRadioButton;
	IBOutlet AppiumMonitorWindowPopOverViewController *androidPrefsWindowController;
	IBOutlet AppiumMonitorWindowPopOverViewController *developerPrefsWindowController;
	IBOutlet AppiumMonitorWindowPopOverViewController *generalPrefsWindowController;
	IBOutlet AppiumMonitorWindowPopOverViewController *iosPrefsWindowController;
	IBOutlet AppiumMonitorWindowPopOverViewController *robotPrefsWindowController;
}

@property (unsafe_unretained) IBOutlet NSTextView *logTextView;
@property (nonatomic, retain) NodeInstance *node;
@property (readonly) AppiumModel *model;
@property BOOL inspectorIsLaunching;

-(IBAction) clearLog:(id)sender;
-(IBAction) launchButtonClicked:(id)sender;

- (void)appendToLog:(NSAttributedString *)string;
-(void) closeAllPopovers;

@end
