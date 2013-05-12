//
//  AppiumMonitorWindowController.h
//  Appium
//
//  Created by Dan Cuellar on 3/3/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppiumInspectorWindowController.h"
#import "AppiumMenuBarManager.h"
#import "AppiumModel.h"
#import "NodeInstance.h"

@class AppiumInspectorWindowController;
@class AppiumMenuBarManager;
@class AppiumModel;
@class NodeInstance;

@interface AppiumMonitorWindowController : NSWindowController {
    @private
    AppiumMenuBarManager *_menuBarManager;
    AppiumInspectorWindowController *_inspectorWindow;
}

@property (unsafe_unretained) IBOutlet NSTextView *logTextView;
@property (nonatomic, retain) NodeInstance *node;
@property (readonly) AppiumModel *model;

-(IBAction) clearLog:(id)sender;
-(IBAction) launchButtonClicked:(id)sender;
-(IBAction) displayInspector:(id)sender;

@end
