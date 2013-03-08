//
//  AppiumMenuBarManager.m
//  Appium
//
//  Created by Dan Cuellar on 3/7/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumMenuBarManager.h"
#import "AppiumAppDelegate.h"
#import "AppiumMonitorWindowController.h"

NSStatusBar *bar;
NSStatusItem *item;

@implementation AppiumMenuBarManager

- (id)init
{
    self = [super init];
    if (self) {
        bar = [NSStatusBar systemStatusBar];
		item = [bar statusItemWithLength:NSVariableStatusItemLength];
		NSImage *iconImage = [[NSApplication sharedApplication] applicationIconImage];
		NSSize newSize = [iconImage size];
		newSize.height = 18;
		newSize.width = 18;
		[iconImage setSize:newSize];
		[item setImage:iconImage];
		[item setHighlightMode:YES];
		
		// add menu
		[item setMenu:[NSMenu new]];
		[self installServerOffMenu:[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] mainWindowController]];

    }
    return self;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if([(AppiumMonitorWindowController*)object isServerRunning])
	{
		[self installServerOnMenu:object];
	}
	else
	{
		[self installServerOffMenu:object];
	}
}

-(void) installServerOnMenu:(AppiumMonitorWindowController*)mainWindowController
{
	NSMenuItem *stopServerItem = [NSMenuItem new];
	[stopServerItem setTitle:@"Stop Server"];
	[stopServerItem setHidden:NO];
	[stopServerItem setAction:@selector(launchButtonClicked:)];
    [stopServerItem setTarget:mainWindowController];
	NSMenuItem *addressItem = [NSMenuItem new];
	[addressItem setTitle:[NSString stringWithFormat:@"Address: %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"Server Address"]]];
	[addressItem setHidden:NO];
	NSMenuItem *portItem = [NSMenuItem new];
	[portItem setTitle:[NSString stringWithFormat:@"Port: %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"Server Port"]]];
	[portItem setHidden:NO];

	[[item menu] removeAllItems];
	[[item menu] addItem:stopServerItem];
	[[item menu] addItem:[NSMenuItem separatorItem]];
	[[item menu] addItem:addressItem];
	[[item menu] addItem:portItem];
}

-(void) installServerOffMenu:(AppiumMonitorWindowController*)mainWindowController
{
    NSMenuItem *startServerItem = [NSMenuItem new];
	[startServerItem setTitle:@"Start Server"];
	[startServerItem setHidden:NO];
	[startServerItem setAction:@selector(launchButtonClicked:)];
    [startServerItem setTarget:mainWindowController];
	
    [[item menu] removeAllItems];
    [[item menu] addItem:startServerItem];
}
@end
