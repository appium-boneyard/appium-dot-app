//
//  AppiumMonitorWindowPopOverButton.h
//  Appium
//
//  Created by Dan Cuellar on 4/22/14.
//  Copyright (c) 2014 Appium. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppiumMainWindowPopOverViewController.h"

@interface AppiumMainWindowPopOverButton : NSButton

@property IBOutlet AppiumMainWindowPopOverViewController *popoverController;

@end

