//
//  AppiumCodeMakerSwipePopOverViewController.m
//  Appium
//
//  Created by Dan Cuellar on 4/12/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumInspectorSwipePopOverViewController.h"

@interface AppiumInspectorSwipePopOverViewController ()

@end

@implementation AppiumInspectorSwipePopOverViewController

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
	[self setNumberOfFingersString:@"1"];
	[self setDuration:[NSNumber numberWithFloat:0.5f]];
	[self setBeginPointLabel:@"(click to select)"];
	[self setEndPointLabel:@"(click to select)"];
}

#pragma mark - Properties
-(NSString*) numberOfFingersString { return [NSString stringWithFormat:@"%li", _numberOfFingers]; }
-(void) setNumberOfFingersString:(NSString *)numberOfFingersString
{
	_numberOfFingers = [numberOfFingersString integerValue];
}

-(NSPoint) beginPoint { return _beginPoint; }
-(void) setBeginPoint:(NSPoint)beginPoint
{
	_beginPoint = beginPoint;
	[self setBeginPointLabel:[NSString stringWithFormat:@"(%.01f,%.01f)", _beginPoint.x, _beginPoint.y]];
	[self setBeginPointWasSetLast:YES];
	[_windowController.screenshotImageView setBeginPoint:[NSValue valueWithPoint:[_windowController.screenshotImageView convertSeleniumPointToViewPoint:beginPoint]]];
}

-(NSString*) beginPointLabel { return _beginPointLabel; }
-(void) setBeginPointLabel:(NSString *)beginPointLabel
{
	_beginPointLabel = beginPointLabel;
}

-(NSPoint) endPoint { return _endPoint; }
-(void) setEndPoint:(NSPoint)endPoint
{
	_endPoint = endPoint;
	[self setEndPointLabel:[NSString stringWithFormat:@"(%.01f,%.01f)", _endPoint.x, _endPoint.y]];
	[self setIsReady:[NSNumber numberWithBool:YES]];
	[self setBeginPointWasSetLast:NO];
	[_windowController.screenshotImageView setEndPoint:[NSValue valueWithPoint:[_windowController.screenshotImageView convertSeleniumPointToViewPoint:endPoint]]];
}

-(NSString*) endPointLabel { return _endPointLabel; }
-(void) setEndPointLabel:(NSString *)endPointLabel
{
	_endPointLabel = endPointLabel;
}

#pragma mark - Public Methods
-(IBAction)performSwipe:(id)sender
{
	// perform the swipe
	NSArray *args = [[NSArray alloc] initWithObjects:[[NSDictionary alloc] initWithObjectsAndKeys:
													  [NSNumber numberWithInteger:_windowController.swipePopoverViewController.numberOfFingers], @"touchCount",
													  [NSNumber numberWithInteger:_windowController.swipePopoverViewController.beginPoint.x], @"startX",
													  [NSNumber numberWithInteger:_windowController.swipePopoverViewController.beginPoint.y], @"startY",
													  [NSNumber numberWithInteger:_windowController.swipePopoverViewController.endPoint.x], @"endX",
													  [NSNumber numberWithInteger:_windowController.swipePopoverViewController.endPoint.y], @"endY",
													  [_windowController.swipePopoverViewController.duration copy], @"duration",
													  nil],nil];
	
	AppiumCodeMakerAction *action = [[AppiumCodeMakerActionSwipe alloc] initWithArguments:args];
	if ([_windowController.inspector.recorderViewController.codeMaker.isRecording boolValue])
	{
		[_windowController.inspector.recorderViewController.codeMaker addAction:action];
	}
	action.block(_windowController.driver);
	
	// reset for next iteration
	[_windowController.swipePopoverViewController.popover close];
	[_windowController.swipePopoverViewController reset];
	[_windowController.selectedElementHighlightView setHidden:NO];
	[_windowController.inspector refresh:sender];
}

-(void) reset
{
	[self setBeginPointWasSetLast:NO];
	[self setIsReady:[NSNumber numberWithBool:NO]];
	[self setNumberOfFingersString:@"1"];
	[self setDuration:[NSNumber numberWithFloat:0.5f]];
	[self setBeginPointLabel:@"(click to select)"];
	[self setEndPointLabel:@"(click to select)"];
	[_windowController.screenshotImageView setBeginPoint:nil];
	[_windowController.screenshotImageView setEndPoint:nil];
}

#pragma mark - NSPopoverDelegate Implementation
- (void)popoverDidShow:(NSNotification *)notification
{
	[_windowController.screenshotImageView display];
}

- (void)popoverDidClose:(NSNotification *)notification
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
