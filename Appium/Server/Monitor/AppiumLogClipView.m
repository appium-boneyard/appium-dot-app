//
//  AppiumLogTextView.m
//  Appium
//
//  Created by Dan Cuellar on 5/11/14.
//  Copyright (c) 2014 Appium. All rights reserved.
//

#import "AppiumLogClipView.h"

@implementation AppiumLogClipView

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
    NSImage *image = [NSImage imageNamed:@"logTextViewBg"];
	[image setFlipped:YES];
	
	NSTextView *textView =((NSTextView*)[self.subviews objectAtIndex:0]);
	NSRect subRect = textView.frame;
	CGFloat x = self.frame.origin.x + (self.frame.size.width/2) - (image.size.width/2);
	CGFloat y = (subRect.size.height - (image.size.height/2)) - (self.frame.origin.y + (self.frame.size.height/2) );
	NSRect rect = NSMakeRect(x, y, self.frame.size.width, self.frame.size.height);
	
	[[NSColor blackColor] set];
	NSRectFill(dirtyRect);
    [image drawInRect:rect fromRect:self.frame operation:NSCompositeSourceOver fraction:1.0];
}

@end
