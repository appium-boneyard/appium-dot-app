//
//  AppiumInspectorScreenshotImageView.m
//  Appium
//
//  Created by Dan Cuellar on 4/2/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumInspectorScreenshotImageView.h"

@implementation AppiumInspectorScreenshotImageView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
}

-(void)setImage:(NSImage *)newImage
{
	[super setImage:newImage];
	self.actualScreenshotSize = newImage.size;
	self.screenshotScalar = 320.0 / newImage.size.height;
	self.maxWidth = 240.0;
	self.maxHeight = 320.0;
	self.xBorder = 0.0;
	self.yBorder = 0.0;
	
	if (newImage.size.width > newImage.size.height)
	{
		self.maxHeight = newImage.size.height * (240.0 / newImage.size.width);
		self.yBorder  = (320.0 - self.maxHeight) / 2.0;
	}
	else
	{
		self.maxWidth = newImage.size.width * (320.0 / newImage.size.height);
		self.xBorder = (240.0 - self.maxWidth) / 2.0;
	}
	
}

-(NSRect)translateSeleniumRect:(NSRect)rect
{
	CGRect viewRect = rect;
	viewRect.size.width *= self.screenshotScalar;
	viewRect.size.height *= self.screenshotScalar;
	viewRect.origin.x = self.xBorder + (rect.origin.x * self.screenshotScalar);
	viewRect.origin.y = self.maxHeight - (self.yBorder  + ((rect.origin.y + rect.size.height) * self.screenshotScalar));
	return viewRect;
}

-(NSPoint)translatePoint:(NSPoint)point
{
	return point;
}

-(void)mouseDown:(NSEvent *)event
{
	NSPoint point = [event locationInWindow];
	NSLog( @"mouseDown location: %@", NSStringFromPoint(point) );
}

@end
