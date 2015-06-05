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

@property (readonly) CGFloat scalar;
@property CGFloat scalarMultiplier;

- (CGFloat)multipliedScalar:(CGFloat)scalar;
- (CGSize)offsetForScaledSize:(CGSize)scaled;
- (CGSize)scaledImageSizeForScalar:(CGFloat)scalar;

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
    self = [super initWithFrame:frame];
	
    if (self)
	{
		// BUG: THIS IS NOT CALLED
		self.rotation         = 0;
		self.scalarMultiplier = 1.0;
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
		
		// Update screenshot scalar
		// add factor of 2 to screenshot scalar to account for retina display based coordinates
		self.scalarMultiplier = 1.0f;
		if (self.inspector.model.isIOS)
		{
			// check for retina devices
			if (self.image.size.width == 640 && self.image.size.height == 960)
			{
				// portrait 3.5" iphone with retina display
				self.scalarMultiplier = 2.0f;
			}
			else if (self.image.size.width == 960 && self.image.size.height == 640)
			{
				// landscape 3.5" iphone with retina display
				self.scalarMultiplier = 2.0f;
			}
			else if (self.image.size.width == 640 && self.image.size.height == 1136)
			{
				// portrait 4" iphone with retina display
				self.scalarMultiplier = 2.0f;
			}
			else if (self.image.size.width == 1136 && self.image.size.height == 640)
			{
				// landscape 4" iphone with retina display
				self.scalarMultiplier = 2.0f;
			}
			else if (self.image.size.width == 750 && self.image.size.height == 1334)
			{
				// portrait iphone 6
				self.scalarMultiplier = 2.0f;
			}
			else if (self.image.size.width == 1334 && self.image.size.height == 750)
			{
				// landscape iphone 6
				self.scalarMultiplier = 2.0f;
			}
			else if (self.image.size.width == 1242 && self.image.size.height == 2208)
			{
				// portrait iphone 6 plus
				self.scalarMultiplier = 3.0f;
			}
			else if (self.image.size.width == 2208 && self.image.size.height == 1242)
			{
				// landscape iphone 6 plus
				self.scalarMultiplier = 3.0f;
			}
			else if (self.image.size.width == 1536 && self.image.size.height == 2048)
			{
				// portrait ipad with retina display
				self.scalarMultiplier = 2.0f;
			}
			else if (self.image.size.width == 2048 && self.image.size.height == 1536)
			{
				// landscape ipad with retina display
				self.scalarMultiplier = 2.0f;
			}
		}
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
- (NSPoint)convertSeleniumPointToViewPoint:(NSPoint)point
{
	// Get the scalar value
	CGFloat scalar = self.scalar;
	
	// Calculate the multiplied scalar
	CGFloat multipliedScalar = [self multipliedScalar:scalar];
	
	// Calculate the scaled image size
	CGSize scaled = [self scaledImageSizeForScalar:scalar];
	
	// Calculate the offset size
	CGSize offset = [self offsetForScaledSize:scaled];
	
	// Create a new point
	NSPoint viewPoint = NSZeroPoint;
	
	// Map the point onto the view using the offset and scalar
	viewPoint.x = offset.width + (point.x * multipliedScalar);
	viewPoint.y = (self.bounds.size.height - (point.y * multipliedScalar)) - offset.height;
	
	return viewPoint;
}

- (NSRect)convertSeleniumRectToViewRect:(NSRect)rect
{
	// Get the scalar value
	CGFloat scalar = self.scalar;
	
	// Calculate the multiplied scalar
	CGFloat multipliedScalar = [self multipliedScalar:scalar];
	
	// Calculate the scaled image size
	CGSize scaled = [self scaledImageSizeForScalar:scalar];
	
	// Calculate the offset size
	CGSize offset = [self offsetForScaledSize:scaled];
	
	// Copy the provided rect
	CGRect viewRect = rect;
	
	// Update the size using the scalar
	viewRect.size.width  *= multipliedScalar;
	viewRect.size.height *= multipliedScalar;
	
	// Update the origin
	viewRect.origin.x = offset.width + (rect.origin.x * multipliedScalar);
	viewRect.origin.y = (self.bounds.size.height - (rect.origin.y + rect.size.height) * multipliedScalar) - offset.height;
	
	return viewRect;
}

- (NSPoint)convertWindowPointToSeleniumPoint:(NSPoint)pointInWindow
{
	// Get the scalar value
	CGFloat scalar = self.scalar;
	
	// Calculate the multiplied scalar
	CGFloat multipliedScalar = [self multipliedScalar:scalar];
	
	// Calculate the scaled image size
	CGSize scaled = [self scaledImageSizeForScalar:scalar];
	
	// Calculate the offset size
	CGSize offset = [self offsetForScaledSize:scaled];
	
	// Convert the point to the view
	NSPoint relativePoint = [self convertPoint:pointInWindow fromView:nil];
	
	// Create a new point
	NSPoint newPoint = NSZeroPoint;
	
	// Map the point onto the view using the offset and scalar
	newPoint.x = (relativePoint.x - offset.width) / multipliedScalar;
	newPoint.y = (self.bounds.size.height - (relativePoint.y + offset.height)) / multipliedScalar;
	
	return newPoint;
}

- (CGFloat)scalar
{
	return fminf(self.bounds.size.width / self.image.size.width, self.bounds.size.height / self.image.size.height);
}

- (CGFloat)multipliedScalar:(CGFloat)scalar
{
	return scalar * self.scalarMultiplier;
}

- (CGSize)offsetForScaledSize:(CGSize)scaled
{
	return CGSizeMake((self.bounds.size.width - scaled.width) / 2, (self.bounds.size.height - scaled.height) / 2);
}

- (CGSize)scaledImageSizeForScalar:(CGFloat)scalar
{
	return CGSizeMake(self.image.size.width * scalar, self.image.size.height * scalar);
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

	NSSize beforeSize = [image size];
	NSSize afterSize = degrees == 90 || degrees == 270 ? NSMakeSize(beforeSize.height, beforeSize.width) : beforeSize;

	NSImage* newImage = [[NSImage alloc] initWithSize:afterSize];

	NSAffineTransform* trans = [NSAffineTransform transform];
	[trans rotateByDegrees:degrees];

	NSAffineTransform *center = [NSAffineTransform transform];
	[center translateXBy:afterSize.width / 2.0 yBy:afterSize.height / 2.0];

	[trans appendTransform:center];

	[newImage lockFocus];
	[trans concat];
	NSRect rect = NSMakeRect(0, 0, beforeSize.width, beforeSize.height);
	NSPoint corner = NSMakePoint(-beforeSize.width / 2., -beforeSize.height / 2.0);
	[image drawAtPoint:corner fromRect:rect operation:NSCompositeCopy fraction:1.0];
	[newImage unlockFocus];

	return newImage;
}
@end
