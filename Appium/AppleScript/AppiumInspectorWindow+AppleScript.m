//
//  AppiumInspectorWindowAppleScript.m
//  Appium
//
//  Created by Dan Cuellar on 5/10/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumInspectorWindow+AppleScript.h"

@implementation AppiumInspectorWindowController (AppleScriptSupport)

-(NSScriptObjectSpecifier*) objectSpecifier
{
	NSScriptClassDescription *containerClassDesc = (NSScriptClassDescription *)
    [NSScriptClassDescription classDescriptionForClass:[NSApp class]];
	return [[NSNameSpecifier alloc]
			initWithContainerClassDescription:containerClassDesc
			containerSpecifier:nil key:@"s_InspectorWindow"
			name:@"inspector window"];
}

-(NSString*) s_Details { return self.detailsTextView.string; }

@end
