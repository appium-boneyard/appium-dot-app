//
//  WebDriverElementNode.m
//  Appium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "WebDriverElementNode.h"

@implementation WebDriverElementNode

-(id)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-init is not a valid initializer for the class WebDriverElementNode"
                                 userInfo:nil];
    return nil;
}

-(id) initWithJSONDict:(NSDictionary *)jsonDict parent:(WebDriverElementNode*) parent showDisabled:(BOOL)showDisabled showInvisible:(BOOL)showInvisible
{
	if (self = [super init])
	{
		if([jsonDict objectForKey:@"hierarchy"] != nil)
		{
			jsonDict = [[jsonDict objectForKey:@"hierarchy"] objectForKey:@"node"];
		}
		_jsonDict = jsonDict;
        _showDisabled = showDisabled;
        _showInvisible = showInvisible;
		[self setParent:parent];
		
		if ([_jsonDict.allKeys containsObject:@"node"])
		{
			// Android Node
			[self setEnabled:[[_jsonDict objectForKey:@"@enabled"] boolValue] ? YES : NO];
			[self setVisible:[[_jsonDict objectForKey:@"@clickable"] boolValue]];
			[self setType:[_jsonDict objectForKey:@"@class"]];
			[self setValue:[_jsonDict objectForKey:@"@text"]];
			NSString *bounds = [_jsonDict objectForKey:@"@bounds"];
			NSError *error;
			NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[(\\d+),(\\d+)\\]\\[(\\d+),(\\d+)\\]" options:NSRegularExpressionCaseInsensitive error:&error];
			NSTextCheckingResult *firstResult = [regex firstMatchInString:bounds options:0 range:NSMakeRange(0, [bounds length])];
			if ([firstResult numberOfRanges] == 5)
			{
				float x1 = [[[NSNumberFormatter new] numberFromString:[bounds substringWithRange:[firstResult rangeAtIndex:1]]] floatValue];
				float y1 = [[[NSNumberFormatter new] numberFromString:[bounds substringWithRange:[firstResult rangeAtIndex:2]]] floatValue];
				float x2 = [[[NSNumberFormatter new] numberFromString:[bounds substringWithRange:[firstResult rangeAtIndex:3]]] floatValue];
				float y2 = [[[NSNumberFormatter new] numberFromString:[bounds substringWithRange:[firstResult rangeAtIndex:4]]] floatValue];

			[self setRect:NSMakeRect(x1, y1, x2-x1, y2-y1)];
			}
			_children = [NSMutableArray new];
			_visibleChildren = [NSMutableArray new];
			NSObject *nodes = [_jsonDict objectForKey:@"node"];
			NSArray *jsonItems = [NSArray new];
			if([nodes isKindOfClass:[NSArray class]])
			{
				jsonItems = (NSArray*)nodes;
			}
			else if([nodes isKindOfClass:[NSDictionary class]])
			{
				jsonItems = [NSArray arrayWithObject:nodes];
			}
			
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
		else
		{
			// iOS Node
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
	}
	return self;
}

#pragma mark - NSBrowerCell Implementation
- (NSString*) displayName
{
    return [NSString stringWithFormat:@"[%@] %@", [self type], [self name]];
}

-(NSArray*) children
{
    return _children;
}

- (NSImage*) icon
{
	return [[NSApplication sharedApplication] applicationIconImage];
}

- (BOOL) isLeaf
{
    return _children.count < 1;
}

- (NSColor*) labelColor
{
    return [NSColor blackColor];
}

#pragma mark - Additional Properties
-(BOOL) shouldDisplay
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

-(NSArray*) visibleChildren { return _visibleChildren; }

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
