//
//  AppiumCodeMaker.m
//  Appium
//
//  Created by Dan Cuellar on 4/10/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMaker.h"
#import "AppiumCodeMakerAction.h"
#import "AppiumCodeMakerPluginCSharp.h"

@class AppiumCodeMakerAction;

@implementation AppiumCodeMaker

- (id)init
{
    self = [super init];
    if (self) {
		_actions =[NSMutableArray new];
		[self setPlugin:[AppiumCodeMakerPluginCSharp new]];
    }
    return self;
}

-(id<AppiumCodeMakerPlugin>) plugin { return _plugin; }
-(void) setPlugin:(id<AppiumCodeMakerPlugin>)plugin
{
	_plugin = plugin;
	_renderedActions = @"";
	[self renderAll];
}

-(void) reset
{
	[_actions removeAllObjects];
	_renderedActions = @"";
	
}

-(void) render
{
	[self setString:[NSString stringWithFormat:@"%@%@%@", _plugin.preCodeBoilerplate, _renderedActions,_plugin.postCodeBoilerplate]];
	[self setAttributedString:[[NSAttributedString alloc] initWithString:self.string]];
}

-(void) renderAll
{
	_renderedActions = @"";
	for(int i=0; i < _actions.count; i++)
	{
		AppiumCodeMakerAction *action = [_actions objectAtIndex:i];
		_renderedActions = [_renderedActions stringByAppendingString:[_plugin renderAction:action]];
	}
	[self render];

}

-(void) addAction:(AppiumCodeMakerAction*)action
{
	[_actions addObject:action];
	_renderedActions =[_renderedActions stringByAppendingString:[_plugin renderAction:action]];
	[self render];
}

@end
