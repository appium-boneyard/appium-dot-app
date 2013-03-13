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
	}
	return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - %@", super.description, [_jsonDict valueForKey:@"name"]];
}

@dynamic displayName, children, isDirectory, icon, labelColor;

- (NSString *)displayName
{
    return [_jsonDict objectForKey:@"name"];
}

- (NSImage *)icon
{
	return [[NSApplication sharedApplication] applicationIconImage];
}

- (BOOL)isDirectory
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
