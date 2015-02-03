//
//  AppiumAndroidSettingsPopOverViewController.m
//  Appium
//
//  Created by Dan Cuellar on 17/01/2015.
//  Copyright (c) 2015 Appium. All rights reserved.
//

#import "AppiumAndroidSettingsPopOverViewController.h"

@interface AppiumAndroidSettingsPopOverViewController ()

@end

@implementation AppiumAndroidSettingsPopOverViewController

-(IBAction)chooseAndroidApp:(id)sender
{
	NSString *selectedApp = self.model.android.appPath;
	
	NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	[openDlg setShowsHiddenFiles:YES];
	[openDlg setAllowedFileTypes:[NSArray arrayWithObjects:@"apk", @"zip", nil]];
	[openDlg setCanChooseFiles:YES];
	[openDlg setCanChooseDirectories:NO];
	[openDlg setPrompt:@"Select Android Application"];
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
		[self.model.android setAppPath:selectedApp];
	}
}

@end
