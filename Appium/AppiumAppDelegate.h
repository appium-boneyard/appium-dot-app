//
//  AppiumAppDelegate.h
//  Appium
//
//  Created by Dan Cuellar on 3/3/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppiumMainWindowController.h"
#import "AppiumModel.h"
#import "AppiumUpdater.h"

@class AppiumInspectorWindowController;
@class AppiumPreferencesWindowController;
@class AppiumUpdater;

@interface AppiumAppDelegate : NSObject <NSApplicationDelegate> {
    @private
    AppiumPreferencesWindowController *_preferencesWindowController;
    AppiumUpdater *_updater;
}

@property (nonatomic, retain) IBOutlet AppiumMainWindowController *mainWindowController;
@property AppiumInspectorWindowController *inspectorWindowController;
@property (nonatomic, retain) AppiumModel *model;

-(IBAction) checkForUpdates:(id)sender;
-(IBAction) displayInspector:(id)sender;
-(void) closeInspector;
-(void) restart;

@end
