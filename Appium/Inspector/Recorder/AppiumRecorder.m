//
//  AppiumRecorderDelegate.m
//  Appium
//
//  Created by Dan Cuellar on 4/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumRecorder.h"

#import <Selenium/SERemoteWebDriver.h>
#import <QuartzCore/QuartzCore.h>
#import "AppiumInspector.h"
#import "AppiumCodeMakerActions.h"

@interface AppiumRecorder ()
@property (readonly) AppiumInspector *inspector;
@property (readonly) SERemoteWebDriver *driver;
@end

@implementation AppiumRecorder

-(id) init
{
    self = [super init];
    if (self) {
		_isRecording = NO;
        [self setKeysToSend:@""];
    }
    return self;
}

#pragma mark - Private Properties
-(AppiumInspector*)inspector { return _windowController.inspector; }
-(SERemoteWebDriver*)driver { return _windowController.driver; }

#pragma mark - Public Properties
-(NSNumber*) isRecording { return [NSNumber numberWithBool:_isRecording]; }
-(void) setIsRecording:(NSNumber *)isRecording
{
	_isRecording = [isRecording boolValue];
}

#pragma mark - Actions
-(IBAction) changeContext:(id)sender
{
	NSString *oldContext = _windowController.inspector.currentContext;
	NSString *newContext = _windowController.inspector.selectedContext;
	[_windowController.inspector setCurrentContext:newContext];

	if ([newContext isEqualToString:oldContext])
	{
		return;
	}
	if(([oldContext isEqualToString:@""] && [newContext isEqualToString:@"no context"])
	   || ([oldContext isEqualToString:@"no context"] && [newContext isEqualToString:@""]))
	{
		[self.inspector refresh:sender];
		return;
	}

	if ([newContext isEqualToString:@"no context"] || [newContext isEqualToString:@""])
	{
		[self.driver setContext:@"no context"];
	}
	else
	{
		[self.driver setContext:newContext];
	}
	[self.inspector refresh:sender];
}

-(IBAction) tap:(id)sender
{
    AppiumCodeMakerLocator *locator = [self.inspector locatorForSelectedNode];

    AppiumCodeMakerAction *action = [[AppiumCodeMakerActionTap alloc] initWithLocator:locator];
	if (_isRecording)
	{
		[_codeMaker addAction:action];
	}
    action.block(self.driver);
    [self.inspector refresh:sender];
}

-(IBAction) sendKeys:(id)sender
{

    AppiumCodeMakerLocator *locator = [self.inspector locatorForSelectedNode];

    NSString *keysToSend = [self.keysToSend copy];

    AppiumCodeMakerAction *action = [[AppiumCodeMakerActionSendKeys alloc] initWithLocator:locator keys:keysToSend];
	if (_isRecording)
	{
		[_codeMaker addAction:action];
	}
    action.block(self.driver);
    [self.inspector refresh:sender];
}

-(IBAction) executeScript:(id)sender
{
    NSString *script = [self.keysToSend copy];
    if (script.length < 1)
        return;
    AppiumCodeMakerAction *action = [[AppiumCodeMakerActionExecuteScript alloc] initWithScript:script];
	if (_isRecording)
	{
		[_codeMaker addAction:action];
	}
    action.block(self.driver);
    [self.inspector refresh:sender];
}

-(IBAction)comment:(id)sender
{
    NSString *comment = [self.keysToSend copy];
	if (_isRecording)
	{
		[_codeMaker addAction:[[AppiumCodeMakerActionComment alloc] initWithComment:comment]];
	}
}

-(IBAction)acceptAlert:(id)sender
{
    AppiumCodeMakerAction *action = [[AppiumCodeMakerActionAlertAccept alloc] init];
	if (_isRecording)
	{
		[_codeMaker addAction:action];
	}
	action.block(self.driver);
    [self.inspector refresh:sender];
}

-(IBAction)dismissAlert:(id)sender
{

    AppiumCodeMakerAction *action = [[AppiumCodeMakerActionAlertDismiss alloc] init];
	if (_isRecording)
	{
		[_codeMaker addAction:action];
	}
	action.block(self.driver);
    [self.inspector refresh:sender];
}

-(IBAction)scrollTo:(id)sender
{

    AppiumCodeMakerLocator *locator = [self.inspector locatorForSelectedNode];

    AppiumCodeMakerAction *action = [[AppiumCodeMakerActionScrollTo alloc] initWithLocator:locator];
	if (_isRecording)
	{
		[_codeMaker addAction:action];
	}
    action.block(self.driver);
    [self.inspector refresh:sender];
}

-(IBAction)shake:(id)sender
{

    AppiumCodeMakerAction *action = [[AppiumCodeMakerActionShake alloc] init];
	if (_isRecording)
	{
		[_codeMaker addAction:action];
	}
	action.block(self.driver);
    [self.inspector refresh:sender];
}

- (IBAction)togglePreciseTapPopover:(id)sender
{
	if (!_windowController.preciseTapPopoverViewController.popover.isShown) {
		[_windowController.selectedElementHighlightView setHidden:YES];
		[_windowController.preciseTapPopoverViewController.popover showRelativeToRect:[_windowController.preciseTapButton bounds]
																			   ofView:_windowController.preciseTapButton
																		preferredEdge:NSMaxYEdge];
	} else {
		[_windowController.preciseTapPopoverViewController.popover close];
		[_windowController.selectedElementHighlightView setHidden:NO];
	}
}

- (IBAction)toggleSwipePopover:(id)sender
{
	if (!_windowController.swipePopoverViewController.popover.isShown) {
		[_windowController.selectedElementHighlightView setHidden:YES];
		[_windowController.swipePopoverViewController.popover showRelativeToRect:[_windowController.swipeButton bounds]
																		  ofView:_windowController.swipeButton
																   preferredEdge:NSMaxYEdge];
	} else {
		[_windowController.swipePopoverViewController.popover close];
		[_windowController.selectedElementHighlightView setHidden:NO];
	}
}

-(IBAction)toggleRecording:(id)sender
{
	[self setIsRecording:[NSNumber numberWithBool:!_isRecording]];
	if (_isRecording)
	{
		_windowController.bottomDrawer.contentSize = CGSizeMake(_windowController.window.frame.size.width, _windowController.bottomDrawer.contentSize.height);
		[_windowController.bottomDrawer openOnEdge:NSMinYEdge];

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
		NSShadow * shadow = [NSShadow new];
		[shadow setShadowColor:[[NSColor blackColor] colorWithAlphaComponent:0.95f]];
		[_windowController.recordButton setShadow:shadow];
	}
	else
	{
		[_windowController.recordButton setShadow:nil];
        [_windowController.recordButton.layer setFilters:[NSArray new]];
        [_windowController.recordButton.layer removeAllAnimations];
		[_windowController.bottomDrawer close];
	}
}

-(IBAction)undoLast:(id)sender
{
	[_codeMaker undoLast];
}

-(IBAction)redoLast:(id)sender
{
	[_codeMaker redoLast];
}

-(IBAction)clearRecording:(id)sender
{
	[_codeMaker reset];
}

-(IBAction)replay:(id)sender
{
    [_codeMaker replay:self.driver];
    [self.inspector refresh:sender];
}

- (IBAction)save:(id)sender
{
	NSSavePanel *savePanel = [NSSavePanel savePanel];
	NSString    *extension = self.codeMaker.activePlugin.fileExtension;
	
	if (extension != nil)
	{
		savePanel.nameFieldStringValue = [@"CodeMakerTest." stringByAppendingString:extension];
	}
	
	[savePanel beginSheetModalForWindow:_windowController.window
					  completionHandler:^(NSInteger result) {
		if (result == NSFileHandlingPanelOKButton)
		{
			if (![[NSFileManager defaultManager] createFileAtPath:savePanel.URL.path
														contents:[self.codeMaker.string dataUsingEncoding:NSUTF8StringEncoding]
													  attributes:nil])
			{
				NSAlert *errorAlert = [NSAlert alertWithMessageText:@"Code Maker Save Error"
													  defaultButton:@"OK"
													alternateButton:nil
														otherButton:nil
										  informativeTextWithFormat:@"The file could not be saved. Please check your directory write permissions and ensure that the disk is not full."];
				[errorAlert runModal];
			}
		}
	}];
}

@end
