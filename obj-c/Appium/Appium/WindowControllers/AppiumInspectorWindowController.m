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
        if (sessions.count > 0)
        {
            [self.driver setSession:[sessions objectAtIndex:0]];
        }
        if (sessions.count == 0 || self.driver.session == nil || self.driver.session.capabilities.platform == nil)
        {
            SECapabilities *capabilities = [SECapabilities new];
            [capabilities setPlatform:@"Mac"];
            [capabilities setBrowserName:@"iOS"];
            [capabilities setVersion:@"6.1"];
            [self.driver startSessionWithDesiredCapabilities:capabilities requiredCapabilities:nil];
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
	[self.screenshotImageView setInspector:self.inspector];
    NSSize contentSize = NSMakeSize(self.window.frame.size.width, 200);
    self.bottomDrawer = [[NSDrawer alloc] initWithContentSize:contentSize preferredEdge:NSMinYEdge];
    [self.bottomDrawer setParentWindow:self.window];
    [self.bottomDrawer setMinContentSize:contentSize];
	
	[self.bottomDrawer setContentView:self.bottomDrawerContentView];
	[self.bottomDrawer.contentView setAutoresizingMask:NSViewHeightSizable];
	[self.recordButton setWantsLayer:NO];
}

@end
