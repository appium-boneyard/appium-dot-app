//
//  AppiumInspectorDelegate.h
//  Appium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Selenium/SERemoteWebDriver.h>
#import "AppiumRecorderViewController.h"
#import "AppiumCodeMakerLocator.h"
#import "AppiumInspectorWindowController.h"
#import "WebDriverElementNode.h"


@class AppiumInspectorWindowController;
@class AppiumModel;
@class SERemoteWebDriver;
@class SEWebElement;
@class WebDriverElementNode;

@interface AppiumInspector : NSObject {
	
@private
	IBOutlet AppiumInspectorWindowController *_windowController;
	WebDriverElementNode *_rootNode;
    WebDriverElementNode *_browserRootNode;
	NSMutableArray *_selectedIndexes;
	SEScreenOrientation _orientation;
	NSString *_lastPageSource;
	NSString *_selectedContext;
}

@property IBOutlet AppiumRecorderViewController *recorderViewController;
@property IBOutlet NSWindow *window;
@property (readonly) SERemoteWebDriver *driver;

// dom hierarchy properties
@property (readonly) AppiumModel *model;
@property WebDriverElementNode *selection;
@property NSNumber *showDisabled;
@property NSNumber *showInvisible;
@property BOOL domIsPopulating;

// context properties
@property NSArray *contexts;
@property NSString *currentContext;
@property NSString *selectedContext;

// locator search properties
@property NSString *selectedLocatorStrategy;
@property NSString *suppliedLocator;
@property (readonly) NSArray *allLocatorStrategies;

// selected node properties
-(SEWebElement*) elementForSelectedNode;
-(NSString*) xPathForSelectedNode;
-(AppiumCodeMakerLocator*) locatorForSelectedNode;
-(BOOL) selectNodeWithRect:(NSRect)rect className:(NSString*)className fromNode:(WebDriverElementNode*)node;
-(void) updateDetailsDisplay;
-(void) handleClickAt:(NSPoint)windowPoint seleniumPoint:(NSPoint)seleniumPoint;
-(IBAction) refresh:(id)sender;
- (IBAction)copyXML:(id)sender;

@end
