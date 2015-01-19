//
//  AppiumAndroidPreferencesPopOverControllerWindowController.m
//  Appium
//
//  Created by Dan Cuellar on 4/22/14.
//  Copyright (c) 2014 Appium. All rights reserved.
//

#import "AppiumAppDelegate.h"
#import "AppiumMainWindowController.h"
#import "AppiumMainWindowPopOverViewController.h"
#import "AppiumMainWindowPopOverButton.h"

@class AppiumAppDelegate;
@class AppiumMainWindowController;

@interface AppiumMainWindowPopOverViewController ()

@end

@implementation AppiumMainWindowPopOverViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		
    }
	
    return self;
}

-(AppiumModel*) model {
	return [(AppiumAppDelegate*)[NSApplication sharedApplication].delegate model];
}

-(void) close
{
	if (self.popover.isShown) {
		[self.popover close];
	}
}

-(IBAction)toggle:(id)sender
{
	if (!self.popover.isShown) {
		// close all popovers
		AppiumMainWindowController *mainWindow = ((AppiumAppDelegate*)[NSApplication sharedApplication].delegate).mainWindowController;
		[mainWindow closeAllPopovers];
		
		// open the popover
		[self.popover showRelativeToRect:[(NSView*)sender bounds]
								  ofView:sender
						   preferredEdge:NSMaxYEdge];
	} else {
		// close the popover
		[self.popover close];
	}
}

@end
