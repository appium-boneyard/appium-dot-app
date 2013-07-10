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
		
		if ([_jsonDict.allKeys containsObject:@"@enabled"])
		{
			// Android Node
			[self setPlatform:Platform_Android];
			[self setEnabled:[[_jsonDict objectForKey:@"@enabled"] boolValue]];
			[self setVisible:[[_jsonDict objectForKey:@"@clickable"] boolValue]];
			[self setType:[_jsonDict objectForKey:@"@class"]];
			[self setValue:[_jsonDict objectForKey:@"@text"]];
			[self setText:[_jsonDict objectForKey:@"@text"]];
			[self setIndex:[(NSString*)[_jsonDict objectForKey:@"@index"] integerValue]];
			[self setName:[_jsonDict objectForKey:@"@content-desc"]];
			[self setContentDesc:[_jsonDict objectForKey:@"@content-desc"]];
			[self setCheckable:[[_jsonDict objectForKey:@"@checkable"] boolValue]];
			[self setPackage:[_jsonDict objectForKey:@"@package"]];
			[self setScrollable:[[_jsonDict objectForKey:@"@scrollable"] boolValue]];
			[self setPassword:[[_jsonDict objectForKey:@"@password"] boolValue]];
			[self setLongClickable:[[_jsonDict objectForKey:@"@long-clickable"] boolValue]];
			[self setSelected:[[_jsonDict objectForKey:@"@selected"] boolValue]];
			[self setClickable:[[_jsonDict objectForKey:@"@clickable"] boolValue]];
			[self setFocused:[[_jsonDict objectForKey:@"@focused"] boolValue]];
			[self setChecked:[[_jsonDict objectForKey:@"@checked"] boolValue]];
			
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
			[self setPlatform:Platform_iOS];
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
	NSString *label = @"";
	if (self.platform == Platform_iOS)
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
    return [NSString stringWithFormat:@"[%@] %@", self.typeShortcut, label];
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

-(NSArray*) visibleChildren { return _visibleChildren; }

-(NSString*) infoText
{
	if (self.platform == Platform_iOS)
	{
		return [NSString stringWithFormat:@"name: %@\ntype: %@\nvalue: %@\nlabel: %@\nenabled: %@\nvisible: %@\nvalid: %@", self.name, self.type, self.value, self.label, (self.enabled ? @"true" : @"false"),(self.visible ? @"true" : @"false"),(self.valid ? @"true" : @"false")];
	}
	else
	{
		return [NSString stringWithFormat:@"content-desc: %@\nclass: %@\ntext: %@\nindex: %@\nenabled: %@\nclickable: %@", self.contentDesc, self.type, self.text,[NSString stringWithFormat:@"%lu", (u_long)self.index], (self.enabled ? @"true" : @"false"),(self.clickable ? @"true" : @"false")];
	}
}

-(NSString*) typeShortcut
{
	if (self.platform == Platform_iOS)
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
	else
	{
		NSString *type = [self.type stringByReplacingOccurrencesOfString:@"android.widget." withString:@""];
		
		if ([type isEqualToString:@"AbsListView"])
			return @"abslist";
		else if ([type isEqualToString:@"AbsSeekBar"])
			return @"absseek";
		else if ([type isEqualToString:@"AbsSpinner"])
			return @"absspinner";
		else if ([type isEqualToString:@"AbsoluteLayout"])
			return @"absolute";
		else if ([type isEqualToString:@"AdapterViewAnimator"])
			return @"adapterviewanimator";
		else if ([type isEqualToString:@"AdapterViewFlipper"])
			return @"adapterviewflipper";
		else if ([type isEqualToString:@"AnalogClock"])
			return @"analogclock";
		else if ([type isEqualToString:@"AppWidgetHostView"])
			return @"appwidgethost";
		else if ([type isEqualToString:@"AutoCompleteTextView"])
			return @"autocomplete";
		else if ([type isEqualToString:@"Button"])
			return @"button";
		else if ([type isEqualToString:@"FragmentBreadCrumbs"])
			return @"breadcrumbs";
		else if ([type isEqualToString:@"CalendarView"])
			return @"calendar";
		else if ([type isEqualToString:@"CheckBox"])
			return @"checkbox";
		else if ([type isEqualToString:@"CheckedTextView"])
			return @"checked";
		else if ([type isEqualToString:@"Chronometer"])
			return @"chronometer";
		else if ([type isEqualToString:@"CompoundButton"])
			return @"compound";
		else if ([type isEqualToString:@"DatePicker"])
			return @"datepicker";
		else if ([type isEqualToString:@"DialerFilter"])
			return @"dialerfilter";
		else if ([type isEqualToString:@"DigitalClock"])
			return @"digitalclock";
		else if ([type isEqualToString:@"SlidingDrawer"])
			return @"drawer";
		else if ([type isEqualToString:@"ExpandableListView"])
			return @"expandable";
		else if ([type isEqualToString:@"ExtractEditText"])
			return @"extract";
		else if ([type isEqualToString:@"FragmentTabHost"])
			return @"fragmenttabhost";
		else if ([type isEqualToString:@"Gallery"])
			return @"gallery";
		else if ([type isEqualToString:@"GestureOverlayView"])
			return @"gesture";
		else if ([type isEqualToString:@"GLSurfaceView"])
			return @"glsurface";
		else if ([type isEqualToString:@"GridView"])
			return @"grid";
		else if ([type isEqualToString:@"GridLayout"])
			return @"gridlayout";
		else if ([type isEqualToString:@"HorizontalScrollView"])
			return @"horizontal";
		else if ([type isEqualToString:@"ImageView"])
			return @"image";
		else if ([type isEqualToString:@"ImageButton"])
			return @"imagebutton";
		else if ([type isEqualToString:@"ImageSwitcher"])
			return @"imageswitcher";
		else if ([type isEqualToString:@"KeyboardView"])
			return @"keyboard";
		else if ([type isEqualToString:@"LinearLayout"])
			return @"linear";
		else if ([type isEqualToString:@"ListView"])
			return @"list";
		else if ([type isEqualToString:@"MediaController"])
			return @"media";
		else if ([type isEqualToString:@"MediaRouteButton"])
			return @"mediaroutebutton";
		else if ([type isEqualToString:@"MultiAutoCompleteTextView"])
			return @"multiautocomplete";
		else if ([type isEqualToString:@"NumberPicker"])
			return @"numberpicker";
		else if ([type isEqualToString:@"PageTabStrip"])
			return @"pagetabstrip";
		else if ([type isEqualToString:@"PageTitleStrip"])
			return @"pagetitlestrip";
		else if ([type isEqualToString:@"ProgressBar"])
			return @"progress";
		else if ([type isEqualToString:@"QuickContactBadge"])
			return @"quickcontactbadge";
		else if ([type isEqualToString:@"RadioButton"])
			return @"radio";
		else if ([type isEqualToString:@"RadioGroup"])
			return @"radiogroup";
		else if ([type isEqualToString:@"RatingBar"])
			return @"rating";
		else if ([type isEqualToString:@"RelativeLayout"])
			return @"relative";
		else if ([type isEqualToString:@"TableRow"])
			return @"row";
		else if ([type isEqualToString:@"RSSurfaceView"])
			return @"rssurface";
		else if ([type isEqualToString:@"RSTextureView"])
			return @"rstexture";
		else if ([type isEqualToString:@"ScrollView"])
			return @"scroll";
		else if ([type isEqualToString:@"SearchView"])
			return @"search";
		else if ([type isEqualToString:@"SeekBar"])
			return @"seek";
		else if ([type isEqualToString:@"Space"])
			return @"space";
		else if ([type isEqualToString:@"Spinner"])
			return @"spinner";
		else if ([type isEqualToString:@"StackView"])
			return @"stack";
		else if ([type isEqualToString:@"SurfaceView"])
			return @"surface";
		else if ([type isEqualToString:@"Switch"])
			return @"switch";
		else if ([type isEqualToString:@"TabHost"])
			return @"tabhost";
		else if ([type isEqualToString:@"TabWidget"])
			return @"tabwidget";
		else if ([type isEqualToString:@"TableLayout"])
			return @"table";
		else if ([type isEqualToString:@"TextView"])
			return @"text";
		else if ([type isEqualToString:@"TextClock"])
			return @"textclock";
		else if ([type isEqualToString:@"TextSwitcher"])
			return @"textswitcher";
		else if ([type isEqualToString:@"TextureView"])
			return @"texture";
		else if ([type isEqualToString:@"EditText"])
			return @"textfield";
		else if ([type isEqualToString:@"TimePicker"])
			return @"timepicker";
		else if ([type isEqualToString:@"ToggleButton"])
			return @"toggle";
		else if ([type isEqualToString:@"TwoLineListItem"])
			return @"twolinelistitem";
		else if ([type isEqualToString:@"VideoView"])
			return @"video";
		else if ([type isEqualToString:@"ViewAnimator"])
			return @"viewanimator";
		else if ([type isEqualToString:@"ViewFlipper"])
			return @"viewflipper";
		else if ([type isEqualToString:@"ViewGroup"])
			return @"viewgroup";
		else if ([type isEqualToString:@"ViewPager"])
			return @"viewpager";
		else if ([type isEqualToString:@"ViewStub"])
			return @"viewstub";
		else if ([type isEqualToString:@"ViewSwitcher"])
			return @"viewswitcher";
		else if ([type isEqualToString:@"WebView"])
			return @"web";
		else if ([type isEqualToString:@"FrameLayout"])
			return @"window";
		else if ([type isEqualToString:@"ZoomButton"])
			return @"zoom";
		else if ([type isEqualToString:@"ZoomControls"])
			return @"zoomcontrols";
        else if ([type isEqualToString:@"AdapterView"])
            return @"adapterview";
        else if ([type isEqualToString:@"android.view.View"])
            return @"view";
		else
			return self.type;
	}
}

@end
