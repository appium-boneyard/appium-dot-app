//
//  AppiumiOSSettingsPopOverViewController.m
//  Appium
//
//  Created by Dan Cuellar on 17/01/2015.
//  Copyright (c) 2015 Appium. All rights reserved.
//

#import "AppiumiOSSettingsPopOverViewController.h"

@interface AppiumiOSSettingsPopOverViewController ()

@end

@implementation AppiumiOSSettingsPopOverViewController

-(IBAction)chooseiOSApp:(id)sender
{
	NSString *selectedApp = self.model.iOS.appPath;
	
	NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	[openDlg setShowsHiddenFiles:YES];
	[openDlg setAllowedFileTypes:[NSArray arrayWithObjects:@"app", @"zip", @"ipa", nil]];
	[openDlg setCanChooseFiles:YES];
	[openDlg setCanChooseDirectories:NO];
	[openDlg setPrompt:@"Select iOS Application"];
	if (selectedApp == nil || [selectedApp isEqualToString:@"/"])
	{
		[openDlg setDirectoryURL:[NSURL fileURLWithPath:NSHomeDirectory()]];
	}
	else
	{
		[openDlg setDirectoryURL:[NSURL fileURLWithPath:[selectedApp stringByDeletingLastPathComponent]]];
	}
	
	if ([openDlg runModal] == NSOKButton)
	{
		selectedApp = [[[openDlg URLs] objectAtIndex:0] path];
		[self.model.iOS setAppPath:selectedApp];
	}
}

-(IBAction)chooseiOSTraceTemplate:(id)sender
{
	NSString *selectedTemplate = self.model.iOS.customTraceTemplatePath;
	
	NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	[openDlg setShowsHiddenFiles:YES];
	[openDlg setAllowedFileTypes:[NSArray arrayWithObjects:@"tracetemplate", nil]];
	[openDlg setCanChooseFiles:YES];
	[openDlg setCanChooseDirectories:NO];
	[openDlg setPrompt:@"Select Instruments Trace Templates"];
	if (selectedTemplate == nil || [selectedTemplate isEqualToString:@"/"])
	{
		[openDlg setDirectoryURL:[NSURL fileURLWithPath:NSHomeDirectory()]];
	}
	else
	{
		[openDlg setDirectoryURL:[NSURL fileURLWithPath:[selectedTemplate stringByDeletingLastPathComponent]]];
	}
	
	if ([openDlg runModal] == NSOKButton)
	{
		selectedTemplate = [[[openDlg URLs] objectAtIndex:0] path];
		[self.model.iOS setCustomTraceTemplatePath:selectedTemplate];
	}
}

- (IBAction)chooseiOSTraceDirectory:(id)sender
{
	NSString *selectedPath = self.model.iOS.traceDirectory;
	NSString *firstCharacter = ([selectedPath length] > 0) ? [selectedPath substringWithRange:NSMakeRange(0, 1)] : nil;
	
	NSOpenPanel *panel = [NSOpenPanel openPanel];
	panel.showsHiddenFiles = YES;
	panel.canChooseDirectories = YES;
	panel.canChooseFiles = NO;
	panel.prompt = @"Select Trace Directory";
	
	if (selectedPath == nil || [selectedPath length] < 1 || [selectedPath isEqualToString:@"/"] || !([firstCharacter isEqualToString:@"/"] || [firstCharacter isEqualToString:@"~"]))
	{
		panel.directoryURL = [NSURL fileURLWithPath:NSHomeDirectory()];
	}
	else
	{
		panel.directoryURL = [NSURL fileURLWithPath:[selectedPath stringByExpandingTildeInPath]];
	}
	
	if ([panel runModal] == NSOKButton)
	{
		self.model.iOS.traceDirectory = [[[panel URLs] objectAtIndex:0] path];
	}
}

-(IBAction)chooseXcodePath:(id)sender
{
	NSString *selectedApp = self.model.iOS.xcodePath;
	
	NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	[openDlg setShowsHiddenFiles:YES];
	[openDlg setAllowedFileTypes:[NSArray arrayWithObjects:@"app", nil]];
	[openDlg setCanChooseFiles:YES];
	[openDlg setCanChooseDirectories:NO];
	[openDlg setPrompt:@"Select Xcode Application"];
	if (selectedApp == nil || [selectedApp isEqualToString:@"/"])
	{
		[openDlg setDirectoryURL:[NSURL fileURLWithPath:NSHomeDirectory()]];
	}
	else
	{
		[openDlg setDirectoryURL:[NSURL fileURLWithPath:[selectedApp stringByDeletingLastPathComponent]]];
	}
	
	if ([openDlg runModal] == NSOKButton)
	{
		selectedApp = [[[openDlg URLs] objectAtIndex:0] path];
		[self.model.iOS setXcodePath:selectedApp];
	}
}

@end
