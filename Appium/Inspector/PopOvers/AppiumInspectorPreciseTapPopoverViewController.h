//
//  AppiumCodeMakerPreciseTapPopoverViewController.h
//  Appium
//
//  Created by Dan Cuellar on 4/18/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppiumInspectorWindowController.h"

@class AppiumInspectorWindowController;

@interface AppiumInspectorPreciseTapPopoverViewController : NSViewController<NSPopoverDelegate> {
	@private
	NSPoint _touchPoint;
	NSString *_beginPointLabel;
	IBOutlet AppiumInspectorWindowController * _windowController;
}

@property IBOutlet NSPopover *popover;
@property (readonly) NSUInteger numberOfTaps;
@property NSString *numberOfTapsString;
@property (readonly) NSUInteger numberOfFingers;
@property NSString *numberOfFingersString;
@property NSNumber *duration;
@property NSPoint touchPoint;
@property NSString *touchPointLabel;
@property NSNumber *isReady;

-(void)reset;

@end
