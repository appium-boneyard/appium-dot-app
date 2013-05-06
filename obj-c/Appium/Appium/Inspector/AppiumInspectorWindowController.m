//
//  AppiumInspectorWindowController.m
//  Appium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumInspectorWindowController.h"

#import "AppiumAppDelegate.h"
#import "AppiumModel.h"

@implementation AppiumInspectorWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];

    if (self) {

        AppiumModel *model = [(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] model];
        self.driver = [[SERemoteWebDriver alloc] initWithServerAddress:[model ipAddress] port:[[model port] integerValue]];
        NSArray *sessions = [self.driver allSessions];
        
		// get session to use
		if (sessions.count > 0)
        {
			// use the existing session
            [self.driver setSession:[sessions objectAtIndex:0]];
        }
        if (sessions.count == 0 || self.driver.session == nil || self.driver.session.capabilities.platform == nil)
        {
			// create a new session if one does not already exist
            SECapabilities *capabilities = [SECapabilities new];
            [self.driver startSessionWithDesiredCapabilities:capabilities requiredCapabilities:nil];
        }
		
		// set 15 minute timeout so Appium will not close prematurely
		NSArray *timeoutArgs = [[NSArray alloc] initWithObjects:[[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInteger:900], @"timeout", nil],nil];
		[_driver executeScript:@"mobile: setCommandTimeout" arguments:timeoutArgs];
        
        // detect the current platform
        if ([[self.driver.session.capabilities.browserName lowercaseString] isEqualToString:@"ios"])
        {
            [model setPlatform:Platform_iOS];
        }
        if ([[self.driver.session.capabilities.browserName lowercaseString] isEqualToString:@"android"])
        {
            [model setPlatform:Platform_Android];
        }
        if ([[self.driver.session.capabilities.browserName lowercaseString] isEqualToString:@"selendroid"])
        {
            [model setPlatform:Platform_Android];
        }
        if ([[[self.driver.session.capabilities getCapabilityForKey:@"device"] lowercaseString] isEqualToString:@"android"])
        {
            [model setPlatform:Platform_Android];
        }
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(void) awakeFromNib
{
	// setup drawer
    NSSize contentSize = NSMakeSize(self.window.frame.size.width, 200);
    self.bottomDrawer = [[NSDrawer alloc] initWithContentSize:contentSize preferredEdge:NSMinYEdge];
    [self.bottomDrawer setParentWindow:self.window];
    [self.bottomDrawer setMinContentSize:contentSize];
	[self.bottomDrawer setContentView:self.bottomDrawerContentView];
	[self.bottomDrawer.contentView setAutoresizingMask:NSViewHeightSizable];
}

@end
