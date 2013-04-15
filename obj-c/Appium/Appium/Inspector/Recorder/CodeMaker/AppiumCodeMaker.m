//
//  AppiumCodeMaker.m
//  Appium
//
//  Created by Dan Cuellar on 4/10/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMaker.h"

#import "AppiumPreferencesFile.h"
#import "AppiumCodeMakerPlugins.h"

@class AppiumCodeMakerAction;

@implementation AppiumCodeMaker

- (id)init
{
    self = [super init];
    if (self) {
		_actions =[NSMutableArray new];
		_plugins = [[NSDictionary alloc] initWithObjectsAndKeys:
						[[AppiumCodeMakerCSharpPlugin alloc] initWithCodeMaker:self], @"C#",
						[[AppiumCodeMakerJavaPlugin alloc] initWithCodeMaker:self], @"Java",
						[[AppiumCodeMakerPythonPlugin alloc] initWithCodeMaker:self], @"Python",
						[[AppiumCodeMakerRubyPlugin alloc] initWithCodeMaker:self], @"Ruby",
						nil];
		[self setSelectedPluginString:[[NSUserDefaults standardUserDefaults] stringForKey:APPIUM_PLIST_CODEMAKER_LANGUAGE]];
    }
    return self;
}

#pragma mark - Properties

-(AppiumCodeMakerPlugin*) activePlugin { return _activePlugin; }
-(NSArray*) allPlugins { return [_plugins allKeys]; }
-(NSString*) selectedPluginString { return _activePlugin.name; }
-(NSNumber*) useBoilerPlate { return [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:APPIUM_PLIST_USE_CODEMAKER_BOILERPLATE]]; }
-(NSNumber*) useXPathOnly { return [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:APPIUM_PLIST_USE_XPATH_ONLY]]; }


-(void) setActivePlugin:(AppiumCodeMakerPlugin*)plugin
{
	_activePlugin = plugin;
	_renderedActions = @"";
	[self renderAll];
}

-(void)setSelectedPluginString:(NSString *)selectedPluginString
{
	[self setActivePlugin:(AppiumCodeMakerPlugin*)[_plugins objectForKey:selectedPluginString]];
	[[NSUserDefaults standardUserDefaults] setObject:selectedPluginString forKey:APPIUM_PLIST_CODEMAKER_LANGUAGE];
	
}

-(void) setUseBoilerPlate:(NSNumber *)useBoilerPlate
{
	[[NSUserDefaults standardUserDefaults] setBool:[useBoilerPlate boolValue] forKey:APPIUM_PLIST_USE_CODEMAKER_BOILERPLATE];
	[self renderAll];
}

-(void) setUseXPathOnly:(NSNumber *)useXPathOnly
{
	[[NSUserDefaults standardUserDefaults] setBool:[useXPathOnly boolValue] forKey:APPIUM_PLIST_USE_XPATH_ONLY];
	[self renderAll];
}

#pragma mark - Private Methods

-(void) render
{
	[self setString:[NSString stringWithFormat:@"%@%@%@", ([self.useBoilerPlate boolValue] ? _activePlugin.preCodeBoilerplate : @""), _renderedActions,([self.useBoilerPlate boolValue] ?_activePlugin.postCodeBoilerplate : @"")]];
	[self setAttributedString:[[NSAttributedString alloc] initWithString:self.string]];
}

-(void) renderAll
{
	_renderedActions = @"";
	for(int i=0; i < _actions.count; i++)
	{
		AppiumCodeMakerAction *action = [_actions objectAtIndex:i];
		_renderedActions = [_renderedActions stringByAppendingString:[_activePlugin renderAction:action]];
	}
	[self render];
}

#pragma mark - Public Methods

-(void) reset
{
	[_actions removeAllObjects];
	[self renderAll];
	
}

-(void) addAction:(AppiumCodeMakerAction*)action
{
	[_actions addObject:action];
	_renderedActions =[_renderedActions stringByAppendingString:[_activePlugin renderAction:action]];
	[self render];
}

-(void) replay:(SERemoteWebDriver*)driver
{
  	for(int i=0; i < _actions.count; i++)
	{
        AppiumCodeMakerAction *action = [_actions objectAtIndex:i];
        action.block(driver);
    }
}

#pragma mark - NSCoding Implementation
-(id) initWithCoder:(NSCoder *)aDecoder
{
    if(self = [self init])
    {
        _actions = [aDecoder decodeObjectForKey:@"actions"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_actions forKey:@"actions"];
}

@end
