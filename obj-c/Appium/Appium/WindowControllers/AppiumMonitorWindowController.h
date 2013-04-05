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

@property (unsafe_unretained) IBOutlet NSTextView *logTextView;
@property (nonatomic, retain) NodeInstance *node;
@property (readonly) AppiumModel *model;

-(IBAction) clearLog:(id)sender;
-(IBAction) launchButtonClicked:(id)sender;
-(IBAction) displayInspector:(id)sender;

@end
