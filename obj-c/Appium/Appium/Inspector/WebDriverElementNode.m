//
//  UIAElementNode.m
//  Appium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "WebDriverElementNode.h"

@implementation WebDriverElementNode

- (id)initWithJSONDict:(NSDictionary *)jsonDict showDisabled:(BOOL)showDisabled showInvisible:(BOOL)showInvisible
{
	if (self = [super init])
	{
		_jsonDict = jsonDict;
        _showDisabled = showDisabled;
        _showInvisible = showInvisible;
		[self setEnabled:[[_jsonDict valueForKey:@"enabled"] boolValue]];
		[self setVisible:[[_jsonDict valueForKey:@"visible"] boolValue]];
		[self setValid:[[_jsonDict valueForKey:@"valid"] boolValue]];
		[self setLabel:[_jsonDict valueForKey:@"label"]];
		[self setType:[_jsonDict valueForKey:@"type"]];
		[self setValue:[_jsonDict valueForKey:@"value"]];
		[self setName:[_jsonDict valueForKey:@"name"]];
		NSDictionary *rect = [_jsonDict valueForKey:@"rect"];
		NSDictionary *origin = [rect valueForKey:@"origin"];
		NSDictionary *size = [rect valueForKey:@"size"];
		long x = [[origin valueForKey:@"x"] longValue];
		long y = [[origin valueForKey:@"y"] longValue];
		long width = [[size valueForKey:@"width"] longValue];
		long height = [[size valueForKey:@"height"] longValue];
		[self setRect:NSMakeRect((float)x, (float)y, (float)width, (float)height)];
        
        _children = [NSMutableArray new];
        NSArray *jsonItems = [_jsonDict objectForKey:@"children"];
        for(int i=0; i <jsonItems.count; i++)
        {
            WebDriverElementNode* child = [[WebDriverElementNode alloc] initWithJSONDict:[jsonItems objectAtIndex:i] showDisabled:_showDisabled showInvisible:_showInvisible];
            if ( ![child isLeaf] || ((_showInvisible || child.visible) && (_showDisabled || child.enabled)) )
            {
                [_children addObject:child];
            }
        }
	}
	return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - %@", super.description, [_jsonDict valueForKey:@"name"]];
}

@dynamic displayName, children, isLeaf, icon, labelColor;

- (NSString *)displayName
{
    return [NSString stringWithFormat:@"[%@] %@", [self type], [self name]];
}

- (NSImage *)icon
{
	return [[NSApplication sharedApplication] applicationIconImage];
}

- (BOOL)isLeaf
{
    return _children.count < 1;
}

- (NSColor *)labelColor
{
    return [NSColor blackColor];
}

- (NSArray *)children { return _children; }

-(NSString*) infoText
{
	NSString* info = [NSString stringWithFormat:@"name: %@\ntype: %@\nvalue: %@\nlabel: %@\nenabled: %@\nvisible: %@\nvalid: %@", self.name, self.type, self.value, self.label, (self.enabled ? @"true" : @"false"),(self.visible ? @"true" : @"false"),(self.valid ? @"true" : @"false")];
	return info;
}

@end
