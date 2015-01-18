//
//  AppiumMonitorWindowController.h
//  Appium
//
//  Created by Dan Cuellar on 3/3/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppiumMainWindowPopOverViewController.h"
#import "AppiumMainWindowPopOverButton.h"
#import "AppiumInspectorWindowController.h"
#import "AppiumMenuBarManager.h"
#import "AppiumModel.h"
#import "NodeInstance.h"
#import "SocketIO.h"

@class AppiumMainWindowPopOverViewController;
@class AppiumInspectorWindowController;
@class AppiumMenuBarManager;
@class AppiumModel;
@class NodeInstance;

@interface AppiumMainWindowController : NSWindowController<NSWindowDelegate> {
    
	@private
	AppiumMenuBarManager *_menuBarManager;
    AppiumInspectorWindowController *_inspectorWindow;
	
	IBOutlet NSView *_buttonBarView;
	IBOutlet NSButtonCell *_androidRadioButton;
	IBOutlet NSButtonCell *_iOSRadioButton;
	IBOutlet AppiumMainWindowPopOverButton *_androidPrefsButton;
	IBOutlet AppiumMainWindowPopOverButton *_iOSPrefsButton;
	
	IBOutlet AppiumMainWindowPopOverViewController *_androidPrefsWindowController;
	IBOutlet AppiumMainWindowPopOverViewController *_developerPrefsWindowController;
	IBOutlet AppiumMainWindowPopOverViewController *_generalPrefsWindowController;
	IBOutlet AppiumMainWindowPopOverViewController *_iosPrefsWindowController;
	IBOutlet AppiumMainWindowPopOverViewController *_robotPrefsWindowController;
}

@property BOOL inspectorIsLaunching;
@property (unsafe_unretained) IBOutlet NSTextView *logTextView;
@property (readonly) AppiumModel *model;
@property (nonatomic, retain) NodeInstance *node;


-(IBAction) clearLog:(id)sender;
-(IBAction) launchButtonClicked:(id)sender;
-(void) appendToLog:(NSAttributedString *)string;

-(void) closeAllPopovers;

@end
