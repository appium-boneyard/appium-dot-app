//
//  AppiumMenuBarManager.m
//  Appium
//
//  Created by Dan Cuellar on 3/7/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumMenuBarManager.h"
#import "AppiumAppDelegate.h"
#import "NSImage+Rotated.h"

#define ANIMATION_FPS 15.0f
#define ANIMATION_DEGREES_PER_FRAME 5.0f

@interface AppiumMenuBarManager() {
	@private
	NSTimer *_animationTimer;
	float _nextRotationInDegrees;
	NSImage *_serverOffIcon;
	NSImage *_serverOnIcon;
}

@end

@implementation AppiumMenuBarManager

- (id)init
{
    self = [super init];
    if (self) {
		_nextRotationInDegrees = 0.0f;
        _bar = [NSStatusBar systemStatusBar];
		_item = [_bar statusItemWithLength:NSVariableStatusItemLength];

		// create the off state icon
		_serverOffIcon = [NSImage imageNamed:@"menubar-icon"];
		NSSize newSize = [_serverOffIcon size];
		newSize.height = 18;
		newSize.width = 18;
		[_serverOffIcon setSize:newSize];
		[_item setImage:_serverOffIcon];
		[_item setHighlightMode:YES];
		
		// create the on state icon
		NSString* appPath = [[NSBundle mainBundle] bundlePath];
		_serverOnIcon = [[NSWorkspace sharedWorkspace] iconForFile:appPath];
		[_serverOnIcon setSize:newSize];


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

-(void) installServerOnMenu:(AppiumMainWindowController*)mainWindowController
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
	
	NSMenuItem *inspectorItem = [NSMenuItem new];
	inspectorItem.title       = @"Show Inspector";
	inspectorItem.action      = @selector(displayInspector:);
	inspectorItem.target      = mainWindowController;
	
	[[_item menu] removeAllItems];
	[[_item menu] addItem:stopServerItem];
	[[_item menu] addItem:[NSMenuItem separatorItem]];
	[[_item menu] addItem:addressItem];
	[[_item menu] addItem:portItem];
	[[_item menu] addItem:[NSMenuItem separatorItem]];
	[[_item menu] addItem:inspectorItem];
	[self startAnimating];
}

-(void) installServerOffMenu:(AppiumMainWindowController*)mainWindowController
{
    NSMenuItem *startServerItem = [NSMenuItem new];
	[startServerItem setTitle:@"Start Server"];
	[startServerItem setHidden:NO];
	[startServerItem setAction:@selector(launchButtonClicked:)];
    [startServerItem setTarget:mainWindowController];
	
    [[_item menu] removeAllItems];
    [[_item menu] addItem:startServerItem];
	[self stopAnimating];
}

#pragma mark - Animation

- (void)startAnimating
{
	_animationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/ANIMATION_FPS target:self selector:@selector(updateImage:) userInfo:nil repeats:YES];
}

- (void)stopAnimating
{
	[_animationTimer invalidate];
	[_item setImage:_serverOffIcon];
}

- (void)updateImage:(NSTimer*)timer
{
	// calculate next rotation
	_nextRotationInDegrees += ANIMATION_DEGREES_PER_FRAME;
	while (_nextRotationInDegrees >= 360) {
		_nextRotationInDegrees -= 360;
	}
	
	// update with the rotated image
	NSImage* image = [_serverOnIcon imageRotated:-1.0*_nextRotationInDegrees];
	[_item setImage:image];
}

@end
