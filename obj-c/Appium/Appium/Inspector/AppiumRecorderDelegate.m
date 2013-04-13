//
//  AppiumRecorderDelegate.m
//  Appium
//
//  Created by Dan Cuellar on 4/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumRecorderDelegate.h"
#import "AppiumInspectorDelegate.h"
#import <Selenium/SERemoteWebDriver.h>
#import <QuartzCore/QuartzCore.h>

@class AppiumInspectorDelegate;
@class SERemoteWebDriver;
@class SEWebElement;

@interface AppiumRecorderDelegate ()
    @property (readonly) AppiumInspectorDelegate *inspector;
    @property (readonly) SERemoteWebDriver *driver;
@end

@implementation AppiumRecorderDelegate

-(id) init
{
    self = [super init];
    if (self) {
		_isRecording = NO;
        [self setKeysToSend:@""];
        _codeMaker = [AppiumCodeMaker new];
    }
    return self;
}

-(AppiumInspectorDelegate*)inspector { return _windowController.inspector; }
-(SERemoteWebDriver*)driver { return _windowController.driver; }

-(NSNumber*) isRecording { return [NSNumber numberWithBool:_isRecording]; }
-(void) setIsRecording:(NSNumber *)isRecording
{
	_isRecording = [isRecording boolValue];
}

-(IBAction)tap:(id)sender
{
    SEWebElement *element = [self.inspector elementForSelectedNode];
	if (_isRecording)
	{
		[_codeMaker addAction:[[AppiumCodeMakerAction alloc] initWithActionType:APPIUM_CODE_MAKER_ACTION_TAP params:[NSArray arrayWithObjects:[self.inspector locatorForSelectedNode], nil]]];
	}
    [element click];
    [self.inspector refresh:sender];
}

-(IBAction)sendKeys:(id)sender
{
    SEWebElement *element = [self.inspector elementForSelectedNode];
	if (_isRecording)
	{
		[_codeMaker addAction:[[AppiumCodeMakerAction alloc] initWithActionType:APPIUM_CODE_MAKER_ACTION_SEND_KEYS params:[NSArray arrayWithObjects:[self keysToSend], [self.inspector locatorForSelectedNode], nil]]];
	}
    [element sendKeys:self.keysToSend];
    [self.inspector refresh:sender];
}

-(IBAction)comment:(id)sender
{
	if (_isRecording)
	{
		[_codeMaker addAction:[[AppiumCodeMakerAction alloc] initWithActionType:APPIUM_CODE_MAKER_ACTION_COMMENT params:[NSArray arrayWithObjects:[self keysToSend], nil]]];
	}
}

-(IBAction)acceptAlert:(id)sender
{
	if (_isRecording)
	{
		[_codeMaker addAction:[[AppiumCodeMakerAction alloc] initWithActionType:APPIUM_CODE_MAKER_ACTION_ALERT_ACCEPT params:nil]];
	}
	[self.driver acceptAlert];
	[self.inspector refresh:sender];
}

-(IBAction)dismissAlert:(id)sender
{
	if (_isRecording)
	{
		[_codeMaker addAction:[[AppiumCodeMakerAction alloc] initWithActionType:APPIUM_CODE_MAKER_ACTION_ALERT_DISMISS params:nil]];
	}
	[self.driver dismissAlert];
	[self.inspector refresh:sender];
}

- (IBAction)toggleSwipePopover:(id)sender
{
	if (!_windowController.swipePopover.isShown) {
		[_windowController.selectedElementHighlightView setHidden:YES];
		[_windowController.swipePopover showRelativeToRect:[_windowController.swipeButton bounds]
                                                    ofView:_windowController.swipeButton
                                             preferredEdge:NSMaxYEdge];
	} else {
		[_windowController.swipePopover close];
		[_windowController.selectedElementHighlightView setHidden:NO];
	}
}

-(IBAction)performSwipe:(id)sender
{
	// perform the swipe
	NSArray *args = [[NSArray alloc] initWithObjects:[[NSDictionary alloc] initWithObjectsAndKeys:
													  [NSNumber numberWithInteger:_windowController.swipePopoverViewController.numberOfFingers], @"touchCount",
													  [NSNumber numberWithInteger:_windowController.swipePopoverViewController.beginPoint.x], @"startX",
													  [NSNumber numberWithInteger:_windowController.swipePopoverViewController.beginPoint.y], @"startY",
													  [NSNumber numberWithInteger:_windowController.swipePopoverViewController.endPoint.x], @"endX",
													  [NSNumber numberWithInteger:_windowController.swipePopoverViewController.endPoint.y], @"endY",
													  _windowController.swipePopoverViewController.duration, @"duration",
													  nil],nil];
	if (_isRecording)
	{
		[_codeMaker addAction:[[AppiumCodeMakerAction alloc] initWithActionType:APPIUM_CODE_MAKER_ACTION_SWIPE params:args]];
	}
	[self.driver executeScript:@"mobile: swipe" arguments:args];
	
	// reset for next iteration
	[_windowController.swipePopover close];
	[_windowController.swipePopoverViewController reset];
	[_windowController.selectedElementHighlightView setHidden:NO];
	[self.inspector refresh:sender];
}

-(IBAction)toggleRecording:(id)sender
{
	[self setIsRecording:[NSNumber numberWithBool:!_isRecording]];
	if (_isRecording)
	{
		[_windowController.bottomDrawer openOnEdge:NSMinYEdge];
        
        [_windowController.recordButton setWantsLayer:YES];
        CIFilter *filter = [CIFilter filterWithName:@"CIFalseColor"];
        [filter setDefaults];
        [filter setValue:[CIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] forKey:@"inputColor0"];
        [filter setValue:[CIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0] forKey:@"inputColor1"];
        [filter setName:@"pulseFilter"];
        [_windowController.recordButton.layer setFilters:[NSArray arrayWithObject:filter]];
        
        CABasicAnimation* pulseAnimation1 = [CABasicAnimation animation];
        pulseAnimation1.keyPath = @"filters.pulseFilter.inputColor1";
        pulseAnimation1.fromValue = [CIColor colorWithRed:0.8 green:0.0 blue:0.0 alpha:0.9];
        pulseAnimation1.toValue = [CIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
        pulseAnimation1.duration = 1.5;
        pulseAnimation1.repeatCount = HUGE_VALF;
        pulseAnimation1.autoreverses = YES;
        
        [_windowController.recordButton.layer addAnimation:pulseAnimation1 forKey:@"pulseAnimation1"];
	}
	else
	{
        [_windowController.recordButton.layer setFilters:[NSArray new]];
        [_windowController.recordButton.layer removeAllAnimations];
        [_windowController.recordButton setWantsLayer:NO];
		[_windowController.bottomDrawer close];
	}
}

-(IBAction)clearRecording:(id)sender
{
	[_codeMaker reset];
}

@end
