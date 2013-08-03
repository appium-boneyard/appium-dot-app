//
//  AppiumCodeMakerPreciseTapPopoverViewController.m
//  Appium
//
//  Created by Dan Cuellar on 4/18/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerPreciseTapPopoverViewController.h"

@interface AppiumCodeMakerPreciseTapPopoverViewController ()

@end

@implementation AppiumCodeMakerPreciseTapPopoverViewController

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
-(NSUInteger) numberOfTaps { return _numberOfTaps; }

-(NSString*) numberOfTapsString { return [NSString stringWithFormat:@"%li", _numberOfTaps]; }
-(void) setNumberOfTapsString:(NSString *)numberOfTapsString
{
	_numberOfTaps = [numberOfTapsString integerValue];
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
