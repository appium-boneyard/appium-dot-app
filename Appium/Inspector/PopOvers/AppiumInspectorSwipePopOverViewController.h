//
//  AppiumCodeMakerSwipePopOverViewController.h
//  Appium
//
//  Created by Dan Cuellar on 4/12/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppiumInspectorWindowController.h"

@class AppiumInspectorWindowController;

@interface AppiumInspectorSwipePopOverViewController : NSViewController<NSPopoverDelegate> {
	@private
	NSPoint _beginPoint;
	NSPoint _endPoint;
	NSString *_beginPointLabel;
	NSString *_endPointLabel;
	IBOutlet AppiumInspectorWindowController * _windowController;
}

@property IBOutlet NSPopover *popover;
@property (readonly) NSUInteger numberOfFingers;
@property NSString *numberOfFingersString;
@property NSNumber *duration;
@property NSPoint beginPoint;
@property NSString *beginPointLabel;
@property NSPoint endPoint;
@property NSString *endPointLabel;
@property NSNumber *isReady;
@property BOOL beginPointWasSetLast;

-(void)reset;

@end
