//
//  AppiumMenuBarManager.m
//  Appium
//
//  Created by Dan Cuellar on 3/7/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumMenuBarManager.h"

#import "AppiumAppDelegate.h"

@implementation AppiumMenuBarManager

- (id)init
{
    self = [super init];
    if (self) {
        _bar = [NSStatusBar systemStatusBar];
		_item = [_bar statusItemWithLength:NSVariableStatusItemLength];
		NSImage *iconImage = [[NSApplication sharedApplication] applicationIconImage];
		NSSize newSize = [iconImage size];
		newSize.height = 18;
		newSize.width = 18;
		[iconImage setSize:newSize];
		[_item setImage:iconImage];
		[_item setHighlightMode:YES];
		
		// add menu
		[_item setMenu:[NSMenu new]];
		[self installServerOffMenu:[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] mainWindowController]];

    }
    return self;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	AppiumAppDelegate *delegate = (AppiumAppDelegate*)[[NSApplication sharedApplication] delegate];
	if([object isServerRunning])
	{
		[self installServerOnMenu:[delegate mainWindowController]];
	}
	else
	{
		[self installServerOffMenu:[delegate mainWindowController]];
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

	[[_item menu] removeAllItems];
	[[_item menu] addItem:stopServerItem];
	[[_item menu] addItem:[NSMenuItem separatorItem]];
	[[_item menu] addItem:addressItem];
	[[_item menu] addItem:portItem];
}

-(void) installServerOffMenu:(AppiumMonitorWindowController*)mainWindowController
{
    NSMenuItem *startServerItem = [NSMenuItem new];
	[startServerItem setTitle:@"Start Server"];
	[startServerItem setHidden:NO];
	[startServerItem setAction:@selector(launchButtonClicked:)];
    [startServerItem setTarget:mainWindowController];
	
    [[_item menu] removeAllItems];
    [[_item menu] addItem:startServerItem];
}
@end
