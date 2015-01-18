//
//  AppiumRecorderDelegate.m
//  Appium
//
//  Created by Dan Cuellar on 4/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumRecorderViewController.h"

#import <Selenium/SERemoteWebDriver.h>
#import "AppiumInspector.h"
#import "AppiumCodeMakerActions.h"

@implementation AppiumRecorderViewController

-(id) init
{
    self = [super init];
    if (self) {
        [self setKeysToSend:@""];
    }
    return self;
}

#pragma mark - Actions
-(IBAction) changeContext:(id)sender
{
	NSString *oldContext = _inspector.currentContext;
	NSString *newContext = _inspector.selectedContext;
	[_inspector setCurrentContext:newContext];

	if ([newContext isEqualToString:oldContext])
	{
		return;
	}
	if(([oldContext isEqualToString:@""] && [newContext isEqualToString:@"no context"])
	   || ([oldContext isEqualToString:@"no context"] && [newContext isEqualToString:@""]))
	{
		[_inspector refresh:sender];
		return;
	}

	if ([newContext isEqualToString:@"no context"] || [newContext isEqualToString:@""])
	{
		[_inspector.driver setContext:@"no context"];
	}
	else
	{
		[_inspector.driver setContext:newContext];
	}
	[_inspector refresh:sender];
}

-(IBAction) tap:(id)sender
{
    AppiumCodeMakerLocator *locator = [_inspector locatorForSelectedNode];

    AppiumCodeMakerAction *action = [[AppiumCodeMakerActionTap alloc] initWithLocator:locator];
	if ([self.codeMaker.isRecording boolValue])
	{
		[_codeMaker addAction:action];
	}
    action.block(_inspector.driver);
    [_inspector refresh:sender];
}

-(IBAction) sendKeys:(id)sender
{

    AppiumCodeMakerLocator *locator = [_inspector locatorForSelectedNode];

    NSString *keysToSend = [self.keysToSend copy];

    AppiumCodeMakerAction *action = [[AppiumCodeMakerActionSendKeys alloc] initWithLocator:locator keys:keysToSend];
	if ([self.codeMaker.isRecording boolValue])
	{
		[_codeMaker addAction:action];
	}
    action.block(_inspector.driver);
    [_inspector refresh:sender];
}

-(IBAction) executeScript:(id)sender
{
    NSString *script = [self.keysToSend copy];
    if (script.length < 1)
        return;
    AppiumCodeMakerAction *action = [[AppiumCodeMakerActionExecuteScript alloc] initWithScript:script];
	if ([self.codeMaker.isRecording boolValue])
	{
		[_codeMaker addAction:action];
	}
    action.block(_inspector.driver);
    [_inspector refresh:sender];
}

-(IBAction)comment:(id)sender
{
    NSString *comment = [self.keysToSend copy];
	if ([self.codeMaker.isRecording boolValue])
	{
		[_codeMaker addAction:[[AppiumCodeMakerActionComment alloc] initWithComment:comment]];
	}
}

-(IBAction)acceptAlert:(id)sender
{
    AppiumCodeMakerAction *action = [[AppiumCodeMakerActionAlertAccept alloc] init];
	if ([self.codeMaker.isRecording boolValue])
	{
		[_codeMaker addAction:action];
	}
	action.block(_inspector.driver);
    [_inspector refresh:sender];
}

-(IBAction)dismissAlert:(id)sender
{

    AppiumCodeMakerAction *action = [[AppiumCodeMakerActionAlertDismiss alloc] init];
	if ([self.codeMaker.isRecording boolValue])
	{
		[_codeMaker addAction:action];
	}
	action.block(_inspector.driver);
    [_inspector refresh:sender];
}

-(IBAction)scrollTo:(id)sender
{

    AppiumCodeMakerLocator *locator = [_inspector locatorForSelectedNode];

    AppiumCodeMakerAction *action = [[AppiumCodeMakerActionScrollTo alloc] initWithLocator:locator];
	if ([self.codeMaker.isRecording boolValue])
	{
		[_codeMaker addAction:action];
	}
    action.block(_inspector.driver);
    [_inspector refresh:sender];
}

-(IBAction)shake:(id)sender
{

    AppiumCodeMakerAction *action = [[AppiumCodeMakerActionShake alloc] init];
	if ([self.codeMaker.isRecording boolValue])
	{
		[_codeMaker addAction:action];
	}
	action.block(_inspector.driver);
    [_inspector refresh:sender];
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
    [_codeMaker replay:_inspector.driver];
    [_inspector refresh:sender];
}

- (IBAction)save:(id)sender
{
	NSSavePanel *savePanel = [NSSavePanel savePanel];
	NSString    *extension = self.codeMaker.activePlugin.fileExtension;
	
	if (extension != nil)
	{
		savePanel.nameFieldStringValue = [@"CodeMakerTest." stringByAppendingString:extension];
	}
	
	[savePanel beginSheetModalForWindow:_inspector.window
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
