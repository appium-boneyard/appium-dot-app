//
//  AppiumInspectorWindowController.h
//  Appium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WebDriverElementNode.h"
#import "AppiumInspectorDelegate.h"
#import "AppiumInspectorScreenshotImageView.h"

@class AppiumInspectorDelegate;
@class AppiumInspectorScreenshotImageView;

@interface AppiumInspectorWindowController : NSWindowController
	@property NSDrawer *bottomDrawer;
	@property IBOutlet NSView *bottomDrawerContentView;
	@property IBOutlet NSTextView *bottomDrawerContentTextView;
	@property IBOutlet NSBrowser *browser;
	@property IBOutlet NSTextView *detailsTextView;
	@property IBOutlet NSView *selectedElementHighlightView;
	@property IBOutlet AppiumInspectorDelegate *inspector;
	@property IBOutlet AppiumInspectorScreenshotImageView *screenshotImageView;
	@property IBOutlet NSButton *recordButton;
@end
