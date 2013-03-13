//
//  AppiumPreferencesWindowController.m
//  Appium
//
//  Created by Dan Cuellar on 3/12/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumPreferencesWindowController.h"
#import "AppiumAppDelegate.h"

@interface AppiumPreferencesWindowController ()

@end

@implementation AppiumPreferencesWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (AppiumModel*) model { return [(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] model]; }

@end
