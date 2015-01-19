//
//  AppiumInspectorWindowController.h
//  Appium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Selenium/SERemoteWebDriver.h>
#import "AppiumInspectorPreciseTapPopoverViewController.h"
#import "AppiumInspectorSwipePopOverViewController.h"
#import "AppiumInspector.h"
#import "AppiumInspectorScreenshotImageView.h"
#import "WebDriverElementNode.h"

@class AppiumInspector;
@class AppiumInspectorLocationPopOverViewController;
@class AppiumInspectorScreenshotImageView;
@class AppiumInspectorPreciseTapPopoverViewController;
@class AppiumInspectorSwipePopOverViewController;
@class SERemoteWebDriver;

@interface AppiumInspectorWindowController : NSWindowController
    @property SERemoteWebDriver *driver;
    @property NSDrawer *bottomDrawer;
	@property IBOutlet NSBrowser *browser;
	@property IBOutlet NSTextView *detailsTextView;
	@property IBOutlet NSView *selectedElementHighlightView;
	@property IBOutlet AppiumInspector *inspector;
	@property IBOutlet AppiumInspectorScreenshotImageView *screenshotImageView;
	@property IBOutlet NSButton *recordButton;
    @property IBOutlet AppiumInspectorPreciseTapPopoverViewController *preciseTapPopoverViewController;
    @property IBOutlet NSButton *preciseTapButton;
	@property NSNumber *searchLocatorsFromCurrentElement;
    @property IBOutlet AppiumInspectorSwipePopOverViewController *swipePopoverViewController;
    @property IBOutlet NSButton *swipeButton;
	@property IBOutlet NSButton *findElementButton;
	@property NSString *syntaxDefinition;
@end
