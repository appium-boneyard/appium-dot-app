//
//  AppiumAppDelegate.h
//  Appium
//
//  Created by Dan Cuellar on 3/3/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppiumMonitorWindowController.h"
#import "AppiumModel.h"
#import "AppiumUpdater.h"

@class AppiumInspectorWindowController;
@class AppiumPreferencesWindowController;
@class AppiumUpdater;

@interface AppiumAppDelegate : NSObject <NSApplicationDelegate> {
    @private
    AppiumPreferencesWindowController *_preferencesWindow;
    AppiumUpdater *_updater;
}

@property (nonatomic, retain) IBOutlet AppiumMonitorWindowController *mainWindowController;
@property AppiumInspectorWindowController *inspectorWindow;
@property (nonatomic, retain) AppiumModel *model;

-(IBAction) checkForUpdates:(id)sender;
-(IBAction) displayPreferences:(id)sender;
-(IBAction) displayInspector:(id)sender;
-(void) restart;

@end
