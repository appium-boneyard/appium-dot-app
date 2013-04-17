//
//  AppiumCodeMakerSwipePopOverViewController.m
//  Appium
//
//  Created by Dan Cuellar on 4/12/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerSwipePopOverViewController.h"

@interface AppiumCodeMakerSwipePopOverViewController ()

@end

@implementation AppiumCodeMakerSwipePopOverViewController

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
	[self.popover setDelegate:self];
}

- (void)popoverDidShow:(NSNotification *)notification
{
	[_screenshotView display];
}

- (void)popoverDidClose:(NSNotification *)notification
{
	[_screenshotView display];
}

-(NSUInteger) numberOfFingers {	return _numberOfFingers; }

-(NSString*) numberOfFingersString { return [NSString stringWithFormat:@"%li", _numberOfFingers]; }
-(void) setNumberOfFingersString:(NSString *)numberOfFingersString
{
	_numberOfFingers = [numberOfFingersString integerValue];
}

-(NSNumber*) duration {	return [NSNumber numberWithFloat:_duration]; }
-(void) setDuration:(NSNumber *)duration
{
	_duration = [duration floatValue];
}

-(NSPoint) beginPoint { return _beginPoint; }
-(void) setBeginPoint:(NSPoint)beginPoint
{
	_beginPoint = beginPoint;
	[self setBeginPointLabel:[NSString stringWithFormat:@"(%.01f,%.01f)", _beginPoint.x, _beginPoint.y]];
	[self setBeginPointWasSetLast:YES];
	[_screenshotView setBeginPoint:[NSValue valueWithPoint:[_screenshotView convertSeleniumPointToViewPoint:beginPoint]]];
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
	[_screenshotView setEndPoint:[NSValue valueWithPoint:[_screenshotView convertSeleniumPointToViewPoint:endPoint]]];
}

-(NSString*) endPointLabel { return _endPointLabel; }
-(void) setEndPointLabel:(NSString *)endPointLabel
{
	_endPointLabel = endPointLabel;
}

-(NSNumber*) isReady { return [NSNumber numberWithBool:_isReady]; }
-(void) setIsReady:(NSNumber *)isReady
{
	_isReady = [isReady boolValue];
}

-(void) reset
{
	[self setBeginPointWasSetLast:NO];
	[self setIsReady:[NSNumber numberWithBool:NO]];
	[self setNumberOfFingersString:@"1"];
	[self setDuration:[NSNumber numberWithFloat:0.5f]];
	[self setBeginPointLabel:@"(click to select)"];
	[self setEndPointLabel:@"(click to select)"];
	[_screenshotView setBeginPoint:nil];
	[_screenshotView setEndPoint:nil];
}

@end
