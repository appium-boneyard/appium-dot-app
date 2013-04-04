//
//  UIAElementNode.m
//  Appium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "WebDriverElementNode.h"

@implementation WebDriverElementNode

- (id)initWithJSONDict:(NSDictionary *)jsonDict parent:(WebDriverElementNode*) parent showDisabled:(BOOL)showDisabled showInvisible:(BOOL)showInvisible
{
	if (self = [super init])
	{
		_jsonDict = jsonDict;
        _showDisabled = showDisabled;
        _showInvisible = showInvisible;
		[self setParent:parent];
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
		_visibleChildren = [NSMutableArray new];
        NSArray *jsonItems = [_jsonDict objectForKey:@"children"];
        for(int i=0; i <jsonItems.count; i++)
        {
            WebDriverElementNode* child = [[WebDriverElementNode alloc] initWithJSONDict:[jsonItems objectAtIndex:i] parent:self showDisabled:_showDisabled showInvisible:_showInvisible];
			[_children addObject:child];
            if ( [child shouldDisplay])
            {
                [_visibleChildren addObject:child];
            }
        }
	}
	return self;
}

-(BOOL)shouldDisplay
{
	if ((_showInvisible || self.visible) && (_showDisabled || self.enabled))
		return YES;
    if ([self isLeaf])
		return NO;
	for(int i=0; i < self.visibleChildren.count; i++)
	{
		if ([(WebDriverElementNode*)[self.children objectAtIndex:i] shouldDisplay])
		{
			return YES;
		}
	}
	return NO;
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

-(NSArray *) children { return _children; }

-(NSArray *) visibleChildren { return _visibleChildren; }

-(NSString*) infoText
{
	NSString* info = [NSString stringWithFormat:@"name: %@\ntype: %@\nvalue: %@\nlabel: %@\nenabled: %@\nvisible: %@\nvalid: %@", self.name, self.type, self.value, self.label, (self.enabled ? @"true" : @"false"),(self.visible ? @"true" : @"false"),(self.valid ? @"true" : @"false")];
	return info;
}

-(NSString*) typeShortcut
{
    if ([self.type isEqualToString:@"UIAActionSheet"])
        return @"actionsheet";
    else if ([self.type isEqualToString:@"UIAActivityIndicator"])
        return @"activityIndicator";
    else if ([self.type isEqualToString:@"UIAAlert"])
        return @"alert";
    else if ([self.type isEqualToString:@"UIAButton"])
        return @"button";
    else if ([self.type isEqualToString:@"UIAElement"])
        return @"*";
    else if ([self.type isEqualToString:@"UIAImage"])
        return @"image";
    else if ([self.type isEqualToString:@"UIALink"])
        return @"link";
    else if ([self.type isEqualToString:@"UIAPageIndicator"])
        return @"pageIndicator";
    else if ([self.type isEqualToString:@"UIAPicker"])
        return @"picker";
    else if ([self.type isEqualToString:@"UIAPickerWheel"])
        return @"pickerwheel";
    else if ([self.type isEqualToString:@"UIAPopover"])
        return @"popover";
    else if ([self.type isEqualToString:@"UIAProgressIndicator"])
        return @"progress";
    else if ([self.type isEqualToString:@"UIAScrollView"])
        return @"scrollview";
    else if ([self.type isEqualToString:@"UIASearchBar"])
        return @"searchbar";
    else if ([self.type isEqualToString:@"UIASecureTextField"])
        return @"secure";
    else if ([self.type isEqualToString:@"UIASegmentedControl"])
        return @"segemented";
    else if ([self.type isEqualToString:@"UIASlider"])
        return @"slider";
    else if ([self.type isEqualToString:@"UIAStaticText"])
        return @"text";
    else if ([self.type isEqualToString:@"UIAStatusBar"])
        return @"statusbar";
    else if ([self.type isEqualToString:@"UIASwitch"])
        return @"switch";
    else if ([self.type isEqualToString:@"UIATabBar"])
        return @"tabbar";
    else if ([self.type isEqualToString:@"UIATableView"])
        return @"tableview";
    else if ([self.type isEqualToString:@"UIATableCell"])
        return @"cell";
    else if ([self.type isEqualToString:@"UIATableGroup"])
        return @"group";
    else if ([self.type isEqualToString:@"UIATextField"])
        return @"textfield";
    else if ([self.type isEqualToString:@"UIATextView"])
        return @"textview";
    else if ([self.type isEqualToString:@"UIAToolbar"])
        return @"toolbar";
    else if ([self.type isEqualToString:@"UIAWebView"])
        return @"webview";
    else if ([self.type isEqualToString:@"UIAWindow"])
        return @"window";
    else if ([self.type isEqualToString:@"UIANavigationBar"])
        return @"navigationBar";
    else
        return self.type;
}

@end
