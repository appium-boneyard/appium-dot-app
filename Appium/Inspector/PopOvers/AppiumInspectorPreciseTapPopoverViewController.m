//
//  AppiumCodeMakerPreciseTapPopoverViewController.m
//  Appium
//
//  Created by Dan Cuellar on 4/18/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumInspectorPreciseTapPopoverViewController.h"
#import "AppiumCodeMakerActionPreciseTap.h"

@interface AppiumInspectorPreciseTapPopoverViewController ()

@end

@implementation AppiumInspectorPreciseTapPopoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self reset];
    }

    return self;
}

-(void)awakeFromNib
{
	[self setIsReady:[NSNumber numberWithBool:NO]];
	[self setNumberOfTapsString:@"1"];
	[self setNumberOfFingersString:@"1"];
	[self setDuration:[NSNumber numberWithFloat:0.5f]];
	[self setTouchPointLabel:@"(click to select)"];
}

#pragma mark - Properties

-(NSString*) numberOfTapsString { return [NSString stringWithFormat:@"%li", _numberOfTaps]; }
-(void) setNumberOfTapsString:(NSString *)numberOfTapsString
{
	_numberOfTaps = [numberOfTapsString integerValue];
}

-(NSString*) numberOfFingersString { return [NSString stringWithFormat:@"%li", _numberOfFingers]; }
-(void) setNumberOfFingersString:(NSString *)numberOfFingersString
{
	_numberOfFingers = [numberOfFingersString integerValue];
}


-(NSPoint) touchPoint { return _touchPoint; }

-(void) setTouchPoint:(NSPoint)beginPoint
{
	_touchPoint = beginPoint;
	[self setTouchPointLabel:[NSString stringWithFormat:@"(%.01f,%.01f)", _touchPoint.x, _touchPoint.y]];
	[_windowController.screenshotImageView setBeginPoint:[NSValue valueWithPoint:[_windowController.screenshotImageView convertSeleniumPointToViewPoint:beginPoint]]];
	[self setIsReady:[NSNumber numberWithBool:YES]];
}

-(NSString*) touchPointLabel { return _beginPointLabel; }
-(void) setTouchPointLabel:(NSString *)beginPointLabel
{
	_beginPointLabel = beginPointLabel;
}

#pragma mark - Public Methods
-(IBAction)performPreciseTap:(id)sender
{
	// perform the swipe
	NSArray *args = [[NSArray alloc] initWithObjects:[[NSDictionary alloc] initWithObjectsAndKeys:
													  [NSNumber numberWithInteger:_windowController.preciseTapPopoverViewController.numberOfTaps], @"tapCount",
													  [NSNumber numberWithInteger:_windowController.preciseTapPopoverViewController.numberOfFingers], @"touchCount",
													  [NSNumber numberWithInteger:_windowController.preciseTapPopoverViewController.touchPoint.x], @"x",
													  [NSNumber numberWithInteger:_windowController.preciseTapPopoverViewController.touchPoint.y], @"y",
													  [_windowController.preciseTapPopoverViewController.duration copy], @"duration",
													  nil],nil];
	
	AppiumCodeMakerAction *action = [[AppiumCodeMakerActionPreciseTap alloc] initWithArguments:args];
	if ([_windowController.inspector.recorderViewController.codeMaker.isRecording boolValue])
	{
		[_windowController.inspector.recorderViewController.codeMaker addAction:action];
	}
	action.block(_windowController.driver);
	
	// reset for next iteration
	[_windowController.preciseTapPopoverViewController.popover close];
	[_windowController.preciseTapPopoverViewController reset];
	[_windowController.selectedElementHighlightView setHidden:NO];
	[_windowController.inspector refresh:sender];
}

-(void) reset
{
	[self setIsReady:[NSNumber numberWithBool:NO]];
	[self setNumberOfTapsString:@"1"];
	[self setNumberOfFingersString:@"1"];
	[self setDuration:[NSNumber numberWithFloat:0.5f]];
	[self setTouchPointLabel:@"(click to select)"];
	[_windowController.screenshotImageView setBeginPoint:nil];
	[_windowController.screenshotImageView setEndPoint:nil];
}

#pragma mark - NSPopoverDelegate Implementation
-(void) popoverDidShow:(NSNotification *)notification
{
	[_windowController.screenshotImageView display];
}

-(void) popoverDidClose:(NSNotification *)notification
{
	[_windowController.screenshotImageView display];
}

-(void) popoverWillShow:(NSNotification *)notification
{

}

-(void) popoverWillClose:(NSNotification *)notification
{

}

@end
