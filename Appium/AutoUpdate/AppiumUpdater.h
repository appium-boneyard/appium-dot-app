//
//  AppiumUpgrader.h
//  Appium
//
//  Created by Dan Cuellar on 3/7/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppiumMainWindowController.h"

@interface AppiumUpdater : NSObject

-(id) initWithAppiumMainWindowController:(AppiumMainWindowController*)windowController;
-(void) checkForUpdates:(id)sender;

@end
