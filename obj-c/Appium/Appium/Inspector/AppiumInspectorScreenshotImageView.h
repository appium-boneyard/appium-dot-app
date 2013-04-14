//
//  AppiumInspectorScreenshotImageView.h
//  Appium
//
//  Created by Dan Cuellar on 4/2/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppiumInspector.h"

@class AppiumInspector;

@interface AppiumInspectorScreenshotImageView : NSImageView

@property AppiumInspector *inspector;
@property CGFloat screenshotScalar;
@property CGFloat xBorder;
@property CGFloat yBorder;
@property CGFloat maxWidth;
@property CGFloat maxHeight;

-(NSRect) convertSeleniumRectToViewRect:(NSRect)rect;
-(NSPoint) convertWindowPointToSeleniumPoint:(NSPoint)pointInWindow;

@end
