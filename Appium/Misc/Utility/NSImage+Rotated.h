// from https://gist.github.com/Rm1210/10621763

#import <Cocoa/Cocoa.h>

@interface NSImage (Rotated)
- (NSImage *)imageRotated:(float)degrees;
- (CGImageRef)toCGImageRef;
@end