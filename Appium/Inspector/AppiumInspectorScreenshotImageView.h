//
//  AppiumInspectorScreenshotImageView.h
//  Appium
//
//  Created by Dan Cuellar on 4/2/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppiumInspector.h"
#import "AppiumInspectorWindowController.h"

@class AppiumInspectorWindowController;

@interface AppiumInspectorScreenshotImageView : NSImageView {
	@private IBOutlet AppiumInspectorWindowController *_windowController;
}

@property NSValue *beginPoint;
@property NSValue *endPoint;
@property (nonatomic) NSInteger rotation;

-(NSPoint) convertSeleniumPointToViewPoint:(NSPoint)point;
-(NSRect) convertSeleniumRectToViewRect:(NSRect)rect;
-(NSPoint) convertWindowPointToSeleniumPoint:(NSPoint)pointInWindow;

@end
