//
//  AppiumInspectorWindowController.h
//  Appium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Selenium/SERemoteWebDriver.h>
#import "AppiumCodeMakerSwipePopOverViewController.h"
#import "AppiumInspector.h"
#import "AppiumInspectorScreenshotImageView.h"
#import "WebDriverElementNode.h"

@class AppiumInspector;
@class AppiumInspectorScreenshotImageView;
@class AppiumCodeMakerSwipePopOverViewController;
@class SERemoteWebDriver;

@interface AppiumInspectorWindowController : NSWindowController
    @property SERemoteWebDriver *driver;
    @property NSDrawer *bottomDrawer;
	@property IBOutlet NSView *bottomDrawerContentView;
	@property IBOutlet NSTextView *bottomDrawerContentTextView;
	@property IBOutlet NSBrowser *browser;
	@property IBOutlet NSTextView *detailsTextView;
	@property IBOutlet NSView *selectedElementHighlightView;
	@property IBOutlet AppiumInspector *inspector;
	@property IBOutlet AppiumInspectorScreenshotImageView *screenshotImageView;
	@property IBOutlet NSButton *recordButton;
    @property IBOutlet AppiumCodeMakerSwipePopOverViewController *swipePopoverViewController;
    @property IBOutlet NSPopover *swipePopover;
    @property IBOutlet NSButton *swipeButton;

@end
