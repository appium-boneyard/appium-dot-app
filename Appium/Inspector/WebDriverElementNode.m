//
//  WebDriverElementNode.m
//  Appium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "WebDriverElementNode.h"

@implementation WebDriverElementNode

#define BOLD_FONT [NSFont boldSystemFontOfSize:12.0f]
#define REGULAR_FONT [NSFont systemFontOfSize:12.0f]

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
		while([jsonDict objectForKey:@"hierarchy"] != nil || [@"hierarchy" isEqualToString:[jsonDict objectForKey:@"tag"]])
		{
			jsonDict = [(NSArray*)[jsonDict objectForKey:@"children"] objectAtIndex:0];
		}

		_jsonDict = jsonDict;
        _showDisabled = showDisabled;
        _showInvisible = showInvisible;
		[self setParent:parent];

		if ([_jsonDict.allKeys containsObject:@"content-desc"])
		{
			// Android Node
			[self setPlatform:AppiumAndroidPlatform];
			[self setEnabled:[[_jsonDict objectForKey:@"enabled"] boolValue]];
			[self setVisible:YES];
			[self setType:[_jsonDict objectForKey:@"tag"]];
			[self setValue:[_jsonDict objectForKey:@"text"]];
			[self setText:[_jsonDict objectForKey:@"text"]];
			[self setIndex:[(NSString*)[_jsonDict objectForKey:@"index"] integerValue]];
			[self setName:[_jsonDict objectForKey:@"content-desc"]];
			[self setContentDesc:[_jsonDict objectForKey:@"content-desc"]];
			[self setCheckable:[[_jsonDict objectForKey:@"checkable"] boolValue]];
			[self setPackage:[_jsonDict objectForKey:@"package"]];
			[self setScrollable:[[_jsonDict objectForKey:@"scrollable"] boolValue]];
			[self setPassword:[[_jsonDict objectForKey:@"password"] boolValue]];
			[self setLongClickable:[[_jsonDict objectForKey:@"long-clickable"] boolValue]];
			[self setSelected:[[_jsonDict objectForKey:@"selected"] boolValue]];
			[self setClickable:[[_jsonDict objectForKey:@"clickable"] boolValue]];
			[self setFocused:[[_jsonDict objectForKey:@"focused"] boolValue]];
			[self setChecked:[[_jsonDict objectForKey:@"checked"] boolValue]];
			[self setFocusable:[[_jsonDict objectForKey:@"focusable"] boolValue]];
			[self setResourceId:[_jsonDict objectForKey:@"resource-id"]];

			NSString *bounds = [_jsonDict objectForKey:@"bounds"];
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
			NSObject *nodes = [_jsonDict objectForKey:@"children"];
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
			[self setPlatform:AppiumiOSPlatform];
			[self setEnabled:[[_jsonDict valueForKey:@"enabled"] boolValue]];
			[self setVisible:[[_jsonDict valueForKey:@"visible"] boolValue]];
			[self setValid:[[_jsonDict valueForKey:@"valid"] boolValue]];
			[self setLabel:[_jsonDict valueForKey:@"label"]];
			[self setType:[_jsonDict valueForKey:@"tag"]];
			[self setPath:[_jsonDict valueForKey:@"path"]];
			[self setValue:[_jsonDict valueForKey:@"value"]];
			[self setName:[_jsonDict valueForKey:@"name"]];
			float x = [[_jsonDict valueForKey:@"x"] floatValue];
			float y = [[_jsonDict valueForKey:@"y"] floatValue];
			float width = [[_jsonDict valueForKey:@"width"] floatValue];
			float height = [[_jsonDict valueForKey:@"height"] floatValue];
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
	NSString *label = @"";
	if (self.platform == AppiumiOSPlatform)
	{
		label = self.name;
		if (label == nil || [label isKindOfClass:[NSNull class]] || label.length < 1)
		{
			label = self.label;
		}
		if (label == nil || [label isKindOfClass:[NSNull class]] || label.length < 1)
		{
			label = self.value;
		}
    }
	else
	{
		label = self.name;
		if (label == nil || label.length < 1)
		{
			label = self.text;
		}
	}
    return [NSString stringWithFormat:@"[%@] %@", self.type, label];
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
	if ((_showInvisible || self.visible || self.platform == AppiumAndroidPlatform) && (_showDisabled || self.enabled))
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

-(NSArray*) visibleChildren { return _visibleChildren; }

-(NSAttributedString*) infoText
{
	NSArray* items;
	if (self.platform == AppiumiOSPlatform)
	{
		items = [NSArray arrayWithObjects:
				 @"name:", [NSString stringWithFormat:@" %@\n", self.name],
				 @"type:", [NSString stringWithFormat:@" %@\n", self.type],
				 @"value:", [NSString stringWithFormat:@" %@\n", self.value],
				 @"label:", [NSString stringWithFormat:@" %@\n", self.label],
 				 @"enabled:", [NSString stringWithFormat:@" %@\n", (self.enabled ? @"true" : @"false")],
 				 @"visible:", [NSString stringWithFormat:@" %@\n", (self.clickable ? @"true" : @"false")],
  				 @"valid:", [NSString stringWithFormat:@" %@\n", (self.valid ? @"true" : @"false")],
  				 @"location:", [NSString stringWithFormat:@" %@\n", NSStringFromPoint(self.rect.origin)],
  				 @"size:", [NSString stringWithFormat:@" %@\n", NSStringFromSize(self.rect.size)],
				 nil];
	}
	else
	{
		items = [NSArray arrayWithObjects:
				 @"content-desc:", [NSString stringWithFormat:@" %@\n", self.contentDesc],
				 @"type:", [NSString stringWithFormat:@" %@\n", self.type],
				 @"text:", [NSString stringWithFormat:@" %@\n", self.text],
				 @"index:", [NSString stringWithFormat:@" %@\n", [NSString stringWithFormat:@"%lu", (u_long)self.index]],
 				 @"enabled:", [NSString stringWithFormat:@" %@\n", (self.enabled ? @"true" : @"false")],
  				 @"location:", [NSString stringWithFormat:@" %@\n", NSStringFromPoint(self.rect.origin)],
  				 @"size:", [NSString stringWithFormat:@" %@\n", NSStringFromSize(self.rect.size)],
  				 @"checkable:", [NSString stringWithFormat:@" %@\n", (self.checkable ? @"true" : @"false")],
  				 @"checked:", [NSString stringWithFormat:@" %@\n", (self.checked ? @"true" : @"false")],
  				 @"focusable:", [NSString stringWithFormat:@" %@\n", (self.focusable ? @"true" : @"false")],
				 @"clickable:", [NSString stringWithFormat:@" %@\n", (self.clickable ? @"true" : @"false")],
				 @"long-clickable:", [NSString stringWithFormat:@" %@\n", (self.longClickable ? @"true" : @"false")],
 				 @"package:", [NSString stringWithFormat:@" %@\n", self.package],
 				 @"password:", [NSString stringWithFormat:@" %@\n", (self.password ? @"true" : @"false")],
 				 @"resource-id:", [NSString stringWithFormat:@" %@\n", self.resourceId],
 				 @"scrollable:", [NSString stringWithFormat:@" %@\n", (self.scrollable ? @"true" : @"false")],
 				 @"selected:", [NSString stringWithFormat:@" %@\n", (self.selected ? @"true" : @"false")],
				 nil];
	}

	NSMutableAttributedString *infoText = [NSMutableAttributedString new];
	for (int i=0; i < [items count]; i++)
	{

		NSMutableAttributedString *newPiece = [[NSMutableAttributedString alloc] initWithString:[items objectAtIndex:i]];
		[newPiece addAttribute:NSFontAttributeName value:((i%2 == 0) ? BOLD_FONT : REGULAR_FONT) range:NSMakeRange(0, [newPiece length])];
		[infoText appendAttributedString:newPiece];
	}
	return infoText;
}

-(NSAttributedString*) infoTextWithXPath:(NSString*)xpath
{

	NSMutableAttributedString *infoText = [[NSMutableAttributedString alloc] initWithAttributedString:[self infoText]];
	NSMutableAttributedString *xPathLabel = [[NSMutableAttributedString alloc] initWithString:@"xpath:"];
	NSMutableAttributedString *xPathValue = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@\n", xpath]];
	
	[xPathLabel addAttribute:NSFontAttributeName value:BOLD_FONT range:NSMakeRange(0, [xPathLabel length])];
	[xPathValue addAttribute:NSFontAttributeName value:REGULAR_FONT range:NSMakeRange(0, [xPathValue length])];
	[xPathLabel appendAttributedString:xPathValue];
	[infoText appendAttributedString:xPathLabel];
	return infoText;
	
}

@end
