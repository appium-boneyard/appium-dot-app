// from https://gist.github.com/Rm1210/10621763

#import "NSImage+Rotated.h"

@implementation NSImage (Rotated)

- (NSImage *)imageRotated:(float)degrees {
	
	degrees = fmod(degrees, 360.);
	if (0 == degrees) {
		return self;
	}
	NSSize size = [self size];
	NSSize maxSize;
	if (90. == degrees || 270. == degrees || -90. == degrees || -270. == degrees) {
		maxSize = NSMakeSize(size.height, size.width);
	} else if (180. == degrees || -180. == degrees) {
		maxSize = size;
	} else {
		maxSize = NSMakeSize(MAX(size.width, size.height), MAX(size.width, size.height));
	}
	NSAffineTransform *rot = [NSAffineTransform transform];
	[rot rotateByDegrees:degrees];
	NSAffineTransform *center = [NSAffineTransform transform];
	[center translateXBy:maxSize.width / 2. yBy:maxSize.height / 2.];
	[rot appendTransform:center];
	NSImage *image = [[NSImage alloc] initWithSize:maxSize];
	[image lockFocus];
	[rot concat];
	NSRect rect = NSMakeRect(0, 0, size.width, size.height);
	NSPoint corner = NSMakePoint(-size.width / 2., -size.height / 2.);
	[self drawAtPoint:corner fromRect:rect operation:NSCompositeCopy fraction:1.0];
	[image unlockFocus];
	return image;
}

- (CGImageRef)toCGImageRef
{
	//    NSData *imageData = [self TIFFRepresentation];
	
	NSBitmapImageRep *bmprep = [self bitmapImageRepresentation];
	
	NSData *imageData = [bmprep representationUsingType:NSPNGFileType properties:@{NSImageCompressionFactor: @(0.0)}];
	
	
	CGImageRef imageRef = NULL;
	if (imageData) {
		CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
		imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
	}
	return imageRef;
}

- (NSBitmapImageRep *)bitmapImageRepresentation {
	int width = [self size].width;
	int height = [self size].height;
	
	if(width < 1 || height < 1)
		return nil;
	
	NSBitmapImageRep *rep = [[NSBitmapImageRep alloc]
							 initWithBitmapDataPlanes: NULL
							 pixelsWide: width
							 pixelsHigh: height
							 bitsPerSample: 8
							 samplesPerPixel: 4
							 hasAlpha: YES
							 isPlanar: NO
							 colorSpaceName: NSDeviceRGBColorSpace
							 bytesPerRow: width * 4
							 bitsPerPixel: 32];
	
	NSGraphicsContext *ctx = [NSGraphicsContext graphicsContextWithBitmapImageRep: rep];
	[NSGraphicsContext saveGraphicsState];
	[NSGraphicsContext setCurrentContext: ctx];
	[self drawAtPoint: NSZeroPoint fromRect: NSZeroRect operation: NSCompositeCopy fraction: 1.0];
	[ctx flushGraphics];
	[NSGraphicsContext restoreGraphicsState];
	
	return rep;
}

@end