//
//  AppiumAppDelegate.h
//  Appium
//
//  Created by Dan Cuellar on 3/3/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppiumMonitorWindowController.h"

@interface AppiumAppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, retain) IBOutlet AppiumMonitorWindowController *mainWindowController;

-(IBAction) displayPreferences:(id)sender;
-(IBAction)checkForUpdates:(id)sender;

-(void) restart;

@end
