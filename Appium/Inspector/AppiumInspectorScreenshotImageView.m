//
//  AppiumInspectorScreenshotImageView.m
//  Appium
//
//  Created by Dan Cuellar on 4/2/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumInspectorScreenshotImageView.h"

@interface AppiumInspectorScreenshotImageView ()

@property (readonly) AppiumInspector *inspector;
@property CGFloat screenshotScalar;
@property CGFloat xBorder;
@property CGFloat yBorder;
@property CGFloat maxWidth;
@property CGFloat maxHeight;

@end

@implementation AppiumInspectorScreenshotImageView

-(id)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-init is not a valid initializer for the class AppiumInspectorScreenshotImageView"
                                 userInfo:nil];
    return nil;
}

-(id) initWithFrame:(NSRect)frame
{
    self = [self init];
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

#pragma mark - Private Properties
-(AppiumInspector*) inspector { return _windowController.inspector; }

#pragma mark - NSImageView Overrides
-(void) drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
	// draw line from points tapped on screen
	if (_windowController.swipePopoverViewController.popover.isShown || _windowController.preciseTapPopoverViewController.popover.isShown)
	{
		if ((self.beginPoint != nil) && (self.endPoint != nil))
		{
			CGFloat beginX = self.beginPoint.pointValue.x+2.0f;
			CGFloat beginY = self.beginPoint.pointValue.y-2.0f;
			CGFloat endX = self.endPoint.pointValue.x+2.0f;
			CGFloat endY = self.endPoint.pointValue.y-2.0f;
			
			NSPoint beginPoint = NSMakePoint(beginX, beginY);
			NSPoint endPoint = NSMakePoint(endX, endY);
			NSBezierPath *line = [NSBezierPath bezierPath];
			[line moveToPoint:beginPoint];
			[line lineToPoint:endPoint];
			[[[NSColor blackColor] colorWithAlphaComponent:0.85f] set];
			[line setLineWidth:3.0f];
			[line setLineCapStyle:NSRoundLineCapStyle];
			[line stroke];
		}
		
		if (self.beginPoint != nil)
		{
			// draw a point at the end
			NSPoint beginPoint = [self.beginPoint pointValue];
			NSRect beginRect = NSMakeRect(beginPoint.x-3.0, beginPoint.y-3.0, 6.0, 6.0);
			NSBezierPath *beginPath = [NSBezierPath bezierPath];
			[beginPath appendBezierPathWithOvalInRect:beginRect];
			[[NSColor greenColor] set];
			[beginPath fill];
		}
		if (self.endPoint != nil)
		{
			// draw a point at the beginning
			NSPoint endPoint = [self.endPoint pointValue];
			NSRect endRect = NSMakeRect(endPoint.x-3.0f, endPoint.y-3.0f, 6.0f, 6.0f);
			NSBezierPath *endPath = [NSBezierPath bezierPath];
			[endPath appendBezierPathWithOvalInRect:endRect];
			[[NSColor redColor] set];
			[endPath fill];
		}
		if (self.endPoint != nil && self.beginPoint != nil)
		{
			// draw a line between the start and end
			double slope, cosy, siny;
			double halfWidth = 2;
			
			CGPoint start = CGPointMake(self.beginPoint.pointValue.x, self.beginPoint.pointValue.y);
			CGPoint end = CGPointMake(self.endPoint.pointValue.x, self.endPoint.pointValue.y);
			
			slope = atan2((start.y - end.y), (start.x - end.x));
			cosy = cos(slope);
			siny = sin(slope);
			
			CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
			
			CGGradientRef myGradient;
			CGColorSpaceRef myColorspace;
			size_t num_locations = 2;
			CGFloat locations[2] = { 0.0, 1.0 };
			CGFloat components[8] = { 0.0, 1.0, 0.0, 1.0,  // green
				1.0, 0.0, 0.0, 1.0 }; // red
			
			myColorspace = CGColorSpaceCreateDeviceRGB();
			myGradient = CGGradientCreateWithColorComponents (myColorspace, components, locations, num_locations);

			
			CGContextMoveToPoint(context, start.x - halfWidth*siny , start.y + halfWidth*cosy);
			CGContextAddLineToPoint(context, end.x - halfWidth*siny , end.y + halfWidth*cosy);
			CGContextAddLineToPoint(context, end.x + halfWidth*siny , end.y - halfWidth*cosy);
			CGContextAddLineToPoint(context, start.x + halfWidth*siny, start.y - halfWidth*cosy);
			CGContextAddLineToPoint(context, start.x - halfWidth*siny , start.y + halfWidth*cosy);
			CGContextClip(context);
			
			CGContextDrawLinearGradient (context, myGradient, start, end, 0);
			CGColorSpaceRelease( myColorspace );
			CGGradientRelease (myGradient);
		}
	}
}

-(void)setImage:(NSImage *)newImage
{
	[super setImage:newImage];
	
	self.screenshotScalar = self.bounds.size.height / newImage.size.height;
	self.maxWidth = self.bounds.size.width;
	self.maxHeight = self.bounds.size.height;
	self.xBorder = 0.0f;
	self.yBorder = 0.0f;
	
    // determine borders
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
    
    // add factor of 2 to screenshot scalar to account for retina display based coordinates
    if (self.inspector.model.isIOS && newImage.size.width > 480.0f)
    {
        self.screenshotScalar *= 2.0f;
    }
}

-(void)mouseUp:(NSEvent *)event
{
	NSPoint point = [event locationInWindow];
	[self.inspector handleClickAt:point seleniumPoint:[self convertWindowPointToSeleniumPoint:point]];
	[self setNeedsDisplay];
}

#pragma mark - Coordinate Conversion Methods
-(NSPoint)convertSeleniumPointToViewPoint:(NSPoint)point
{
	NSPoint viewPoint = NSMakePoint(0,0);
	viewPoint.x = self.xBorder + (point.x * self.screenshotScalar);
	viewPoint.y = self.maxHeight - (self.yBorder  + (point.y * self.screenshotScalar));
	return viewPoint;
}

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
