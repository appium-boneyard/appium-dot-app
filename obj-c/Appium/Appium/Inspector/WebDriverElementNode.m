//
//  UIAElementNode.m
//  Appium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "WebDriverElementNode.h"

@implementation WebDriverElementNode

-(id)initWithJSONDict:(NSDictionary *)jsonDict
{
	if (self = [super init])
	{
		_jsonDict = jsonDict;
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
	NSArray *children = (NSArray*)[_jsonDict objectForKey:@"children"];
    return children.count > 0;
}

- (NSColor *)labelColor
{
    return [NSColor blackColor];
}

- (NSArray *)children {
    if (_children == nil || _childrenDirty) {
        // This logic keeps the same pointers around, if possible.
        NSMutableDictionary *newChildren = [NSMutableDictionary new];
        
        NSArray *contentsAtPath = (NSArray*)[_jsonDict objectForKey:@"children"];
		
		if (contentsAtPath) {   // We don't deal with the error
			for (NSDictionary *contentJsonDict in contentsAtPath)
			{
				// Use the filename as a key and see if it was around and reuse it, if possible
				if (_children != nil)
				{
					WebDriverElementNode *oldChild = [_children objectForKey:contentJsonDict];
					if (oldChild != nil) {
						[newChildren setObject:oldChild forKey:contentJsonDict];
						continue;
					}
				}
				// We didn't find it, add a new one
				if (contentJsonDict != nil)
				{
					// Wrap the child url with our node
					WebDriverElementNode *node = [[WebDriverElementNode alloc] initWithJSONDict:contentJsonDict];
					[newChildren setObject:node forKey:contentJsonDict];
				}
			}
		}
        
        _children = newChildren;
        _childrenDirty = NO;
    }
    
    NSArray *result = [_children allValues];
    return result;
}

- (void)invalidateChildren {
    _childrenDirty = YES;
    for (WebDriverElementNode *child in [_children allValues]) {
        [child invalidateChildren];
    }
}

@end
