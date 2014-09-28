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
@property IBOutlet NSButton *rotationButton;
@property NSImage *originalImage;
@property CGFloat screenshotScalar;
@property CGFloat xBorder;
@property CGFloat yBorder;
@property CGFloat maxWidth;
@property CGFloat maxHeight;

-(NSImage*) rotateImage:(NSImage *)image byAngle:(NSInteger)degrees;

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
		self.rotation = 0;
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
	[self setOriginalImage:newImage];
	[self setUpScreenshotView:newImage];
}

-(void) setUpScreenshotView:(NSImage *)newImage
{
	if (newImage != nil)
	{
		[super setImage:[self rotateImage:newImage byAngle:self.rotation]];
	}

	self.maxWidth = self.bounds.size.width;
	self.maxHeight = self.bounds.size.height;
	self.xBorder = 0.0f;
	self.yBorder = 0.0f;
	
	float scalarMultiplier = 0.0f;
	
	// add factor of 2 to screenshot scalar to account for retina display based coordinates
    if (self.inspector.model.isIOS)
    {
        // check for retina devices
        if (self.image.size.width == 640 && self.image.size.height == 960)
        {
            // portrait 3.5" iphone with retina display
            scalarMultiplier = 2.0f;
        }
        else if (self.image.size.width == 960 && self.image.size.height == 640)
        {
            // landscape 3.5" iphone with retina display
            scalarMultiplier = 2.0f;
        }
        else if (self.image.size.width == 640 && self.image.size.height == 1136)
        {
            // portrait 4" iphone with retina display
            scalarMultiplier = 2.0f;
        }
        else if (self.image.size.width == 1136 && self.image.size.height == 640)
        {
            // landscape 4" iphone with retina display
            scalarMultiplier = 2.0f;
        }
        else if (self.image.size.width == 1536 && self.image.size.height == 2048)
        {
            // portrait ipad with retina display
            scalarMultiplier = 2.0f;
        }
        else if (self.image.size.width == 2048 && self.image.size.height == 1536)
        {
            // landscape ipad with retina display
            scalarMultiplier = 2.0f;
        }
    }
	
    // determine borders
	if (self.image.size.width > (self.bounds.size.width * scalarMultiplier))
	{
		self.screenshotScalar = self.image.size.width > 0 ? self.bounds.size.width / self.image.size.width : .0f;
		self.maxHeight = self.image.size.height * self.screenshotScalar;
		self.yBorder  = (self.bounds.size.height - self.maxHeight) / 2.0f;
	}
	else
	{
		self.screenshotScalar = self.image.size.width > 0 ? self.bounds.size.width / self.image.size.width : .0f;
		self.maxWidth = self.image.size.width * self.screenshotScalar;
		self.xBorder = (self.bounds.size.width - self.maxWidth) / 2.0f;
	}
	
	if (scalarMultiplier != 0.0f)
	{
		self.screenshotScalar *= scalarMultiplier;
	}
}

-(void)mouseUp:(NSEvent *)event
{
	NSPoint point = [event locationInWindow];
	
	// Update the values used when drawing layers in case the image frame changed
	if (self.image != nil)
	{
		[self setUpScreenshotView:nil];
	}
	
	[self.inspector handleClickAt:point seleniumPoint:[self convertWindowPointToSeleniumPoint:point]];
	[self setNeedsDisplay];
}

#pragma mark - Coordinate Conversion Methods
-(NSPoint)convertSeleniumPointToViewPoint:(NSPoint)point
{
	NSPoint viewPoint = NSMakePoint(0,0);
	viewPoint.x = self.xBorder + (point.x * self.screenshotScalar);
	viewPoint.y = self.yBorder + (self.maxHeight - point.y * self.screenshotScalar);
	return viewPoint;
}

-(NSRect)convertSeleniumRectToViewRect:(NSRect)rect
{
	CGRect viewRect = rect;
	viewRect.size.width *= self.screenshotScalar;
	viewRect.size.height *= self.screenshotScalar;
	viewRect.origin.x = self.xBorder + (rect.origin.x * self.screenshotScalar);
	viewRect.origin.y = self.yBorder + (self.maxHeight - (rect.origin.y + rect.size.height) * self.screenshotScalar);
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

#pragma mark - Helpers
-(IBAction) toggleRotation:(id)sender
{
	self.rotation += 90;
	if (self.rotation >= 360)
	{
		self.rotation = 0;
	}
	
	_windowController.inspector.selection = nil;
	[_windowController.inspector updateDetailsDisplay];
}

- (void)setRotation:(NSInteger)rotation
{
	_rotation = rotation;
	
	[self.rotationButton setTitle:[NSString stringWithFormat:@"%ldº", self.rotation]];
	[self setUpScreenshotView:self.originalImage];
}

-(NSImage*) rotateImage:(NSImage *)image byAngle:(NSInteger)degrees
{
	if (degrees == 0)
	{
		return image;
	}
	else
	{
		NSSize beforeSize = [image size];
		NSSize afterSize = degrees == 90 || degrees == 270 ? NSMakeSize(beforeSize.height, beforeSize.width) : beforeSize;
		NSImage* newImage = [[NSImage alloc] initWithSize:afterSize];
		NSAffineTransform* trans = [NSAffineTransform transform];

		[newImage lockFocus];
		[trans translateXBy:afterSize.width * 0.5 yBy:afterSize.height * 0.5];
		[trans rotateByDegrees:degrees];
		[trans translateXBy:-beforeSize.width * 0.5 yBy:-beforeSize.height * 0.5];
		[trans set];
		[image drawAtPoint:NSZeroPoint
				  fromRect:NSMakeRect(0, 0, beforeSize.width, beforeSize.height)
				 operation:NSCompositeCopy
				  fraction:1.0];
		[newImage unlockFocus];
		return newImage;
	}
}
@end
