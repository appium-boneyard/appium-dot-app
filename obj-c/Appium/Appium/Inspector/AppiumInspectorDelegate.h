//
//  AppiumInspectorDelegate.h
//  Appium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebDriverElementNode.h"
#import "AppiumInspectorWindowController.h"
#import "AppiumCodeMaker.h"
#import "AppiumCodeMakerSwipePopOverViewController.h"
#import <Selenium/SERemoteWebDriver.h>

@class AppiumInspectorWindowController;
@class AppiumCodeMakerSwipePopOverViewController;
@class SERemoteWebDriver;
@class WebDriverElementNode;

@interface AppiumInspectorDelegate : NSObject {

@private
	IBOutlet AppiumInspectorWindowController *_windowController;
	BOOL _showDisabled;
    BOOL _showInvisible;
	BOOL _isRecording;
	WebDriverElementNode *_rootNode;
    WebDriverElementNode *_browserRootNode;
	WebDriverElementNode *_selection;
	NSMutableArray *_selectedIndexes;
	NSString *_lastPageSource;
}

@property NSNumber *showDisabled;
@property NSNumber *showInvisible;
@property NSNumber *isRecording;
@property NSString *keysToSend;
@property BOOL domIsPopulating;
@property AppiumCodeMaker *codeMaker;

-(void) handleClickAt:(NSPoint)windowPoint seleniumPoint:(NSPoint)seleniumPoint;

@end
