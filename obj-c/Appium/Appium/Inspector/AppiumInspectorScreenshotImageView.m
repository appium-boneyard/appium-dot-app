//
//  AppiumInspectorScreenshotImageView.m
//  Appium
//
//  Created by Dan Cuellar on 4/2/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumInspectorScreenshotImageView.h"

@implementation AppiumInspectorScreenshotImageView

-(id)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-init is not a valid initializer for the class AppiumInspectorScreenshotImageView"
                                 userInfo:nil];
    return nil;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [self init];
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

#pragma mark - NSImageView Overrides
- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
}

-(void)setImage:(NSImage *)newImage
{
	[super setImage:newImage];
	
	self.screenshotScalar = self.bounds.size.height / newImage.size.height;
	self.maxWidth = self.bounds.size.width;
	self.maxHeight = self.bounds.size.height;
	self.xBorder = 0.0f;
	self.yBorder = 0.0f;
	
	if (newImage.size.width > newImage.size.height)
	{
		self.maxHeight = newImage.size.height * (self.bounds.size.width / newImage.size.width);
		self.yBorder  = (self.bounds.size.height - self.maxHeight) / 2.0f;
	}
	else
	{
		self.maxWidth = newImage.size.width * (self.bounds.size.height / newImage.size.height);
		self.xBorder = (self.bounds.size.width - self.maxWidth) / 2.0f;
	}
}

-(void)mouseDown:(NSEvent *)event
{
	NSPoint point = [event locationInWindow];
	[self.inspector handleClickAt:point seleniumPoint:[self convertWindowPointToSeleniumPoint:point]];
}

#pragma mark - Coordinate Conversion Methods
-(NSRect)convertSeleniumRectToViewRect:(NSRect)rect
{
	CGRect viewRect = rect;
	viewRect.size.width *= self.screenshotScalar;
	viewRect.size.height *= self.screenshotScalar;
	viewRect.origin.x = self.xBorder + (rect.origin.x * self.screenshotScalar);
	viewRect.origin.y = self.maxHeight - (self.yBorder  + ((rect.origin.y + rect.size.height) * self.screenshotScalar));
	return viewRect;
}

-(NSPoint)convertWindowPointToSeleniumPoint:(NSPoint)pointInWindow
{
	NSPoint newPoint = NSMakePoint(0.0f, 0.0f);
	NSPoint relativePoint = [self convertPoint:pointInWindow fromView:nil];
	newPoint.x = (relativePoint.x - self.xBorder) / self.screenshotScalar;
	newPoint.y = (self.maxHeight - (relativePoint.y - self.yBorder)) / self.screenshotScalar;
	return newPoint;
}
@end
