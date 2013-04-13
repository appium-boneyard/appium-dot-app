//
//  AppiumInspectorDelegate.m
//  Appium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumInspectorDelegate.h"

#import <QuartzCore/QuartzCore.h>

@interface AppiumInspectorDelegate ()
    @property (readonly) SERemoteWebDriver *driver;
@end

@implementation AppiumInspectorDelegate

-(id) init
{
    self = [super init];
    if (self) {
        _showDisabled = YES;
        _showInvisible = YES;
        [self setDomIsPopulating:NO];
    }
    return self;
}

-(SERemoteWebDriver*) driver { return _windowController.driver; }

-(NSNumber*) showDisabled { return [NSNumber numberWithBool:_showDisabled]; }
-(NSNumber*) showInvisible { return [NSNumber numberWithBool:_showInvisible]; }

-(void) setShowDisabled:(NSNumber *)showDisabled
{
    _showDisabled = [showDisabled boolValue];
    [self performSelectorInBackground:@selector(populateDOM) withObject:nil];
}

-(void) setShowInvisible:(NSNumber *)showInvisible
{
    _showInvisible = [showInvisible boolValue];
    [self performSelectorInBackground:@selector(populateDOM) withObject:nil];
}

-(void)setDomIsPopulatingToYes
{
    [self setDomIsPopulating:YES];
}
-(void)setDomIsPopulatingToNo
{
    [self setDomIsPopulating:NO];
}

-(void)populateDOM
{
    [self performSelectorOnMainThread:@selector(setDomIsPopulatingToYes) withObject:nil waitUntilDone:YES];
	[self refreshPageSource];
    [self refreshScreenshot];
	NSError *e = nil;
	NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData: [_lastPageSource dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &e];
	_browserRootNode = [[WebDriverElementNode alloc] initWithJSONDict:jsonDict parent:nil showDisabled:[self.showDisabled boolValue] showInvisible:[self.showInvisible boolValue]];
    _rootNode = [[WebDriverElementNode alloc] initWithJSONDict:jsonDict parent:nil showDisabled:_showDisabled showInvisible:_showInvisible];
    [_windowController.browser performSelectorOnMainThread:@selector(loadColumnZero) withObject:nil waitUntilDone:YES];
	_selection = nil;
	_selectedIndexes = [NSMutableArray new];
    [self performSelectorOnMainThread:@selector(updateDetailsDisplay) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(setDomIsPopulatingToNo) withObject:nil waitUntilDone:YES];
}

-(IBAction)refresh:(id)sender
{
    [self performSelectorInBackground:@selector(populateDOM) withObject:nil];
}

-(void)refreshPageSource
{
	_lastPageSource = [self.driver pageSource];
}

-(void)refreshScreenshot
{
	NSImage *screenshot = [self.driver screenshot];
	[_windowController.screenshotImageView setImage:screenshot];
}

- (id)rootItemForBrowser:(NSBrowser *)browser {
    if (_browserRootNode == nil) {
        [self performSelectorInBackground:@selector(populateDOM) withObject:nil];
    }
    return _browserRootNode;
}

- (NSInteger)browser:(NSBrowser *)browser numberOfChildrenOfItem:(id)item {
    WebDriverElementNode *node = (WebDriverElementNode *)item;
    return node.visibleChildren.count;
}

- (id)browser:(NSBrowser *)browser child:(NSInteger)index ofItem:(id)item {
    WebDriverElementNode *node = (WebDriverElementNode *)item;
    return [node.visibleChildren objectAtIndex:index];
}

- (BOOL)browser:(NSBrowser *)browser isLeafItem:(id)item {
    WebDriverElementNode *node = (WebDriverElementNode *)item;
    return node.visibleChildren.count < 1;
}

- (id)browser:(NSBrowser *)browser objectValueForItem:(id)item {
    WebDriverElementNode *node = (WebDriverElementNode *)item;
    return node.displayName;
}

- (NSIndexSet *)browser:(NSBrowser *)browser selectionIndexesForProposedSelection:(NSIndexSet *)proposedSelectionIndexes inColumn:(NSInteger)column
{
    [self setSelectedNode:proposedSelectionIndexes inColumn:column];
    return proposedSelectionIndexes;
}

-(void)setSelectedNode:(NSIndexSet*)proposedSelectionIndexes inColumn:(NSInteger)column
{
    if ([proposedSelectionIndexes firstIndex] != NSNotFound)
	{
		// find the parent
		WebDriverElementNode *parentNode = _rootNode;
		for(int i=0; i < _selectedIndexes.count && i < column; i++)
		{
			parentNode = [parentNode.visibleChildren objectAtIndex:[[_selectedIndexes objectAtIndex:i] integerValue]];
		}
		
		// find the element
        _selection = [parentNode.visibleChildren objectAtIndex:[proposedSelectionIndexes firstIndex]];
		if (_selectedIndexes.count < column+1)
		{
			[_selectedIndexes addObject:[NSNumber numberWithInteger:[proposedSelectionIndexes firstIndex]]];
		}
		else
		{
			[_selectedIndexes replaceObjectAtIndex:column withObject:[NSNumber numberWithInteger:[proposedSelectionIndexes firstIndex]]];
		}
	}
    else
    {
		_selection = nil;
    }
	[self updateDetailsDisplay];
}

-(void) updateDetailsDisplay
{
	NSView *highlightView = _windowController.selectedElementHighlightView;
	
	if (_selection != nil)
	{
        NSString *newDetails = [NSString stringWithFormat:@"%@\nXPath string: %@", [_selection infoText], [self xPathForSelectedNode]];
        [_windowController.detailsTextView setString:newDetails];
	}
	else
	{
        [_windowController.detailsTextView setString:@""];
	}
	
	if (_selection != nil)
    {
        if (!highlightView.layer) {
            [highlightView setWantsLayer:YES];
            highlightView.layer.borderWidth = 2.0f;
            highlightView.layer.cornerRadius = 8.0f;
			//_highlightView.layer.borderColor = [NSColor redColor].CGColor; // Not allowed in 10.7
			NSColor* redColor = [NSColor redColor];
			CGColorRef redCGColor = NULL;
			CGColorSpaceRef genericRGBSpace = CGColorSpaceCreateWithName
			(kCGColorSpaceGenericRGB);
			if (genericRGBSpace != NULL)
			{
				CGFloat colorComponents[4] = {[redColor redComponent],
					[redColor greenComponent], [redColor blueComponent],
					[redColor alphaComponent]};
				redCGColor = CGColorCreate(genericRGBSpace, colorComponents);
				CGColorSpaceRelease(genericRGBSpace);
			}
            highlightView.layer.borderColor = redCGColor;
        }
		
        CGRect viewRect = [_windowController.screenshotImageView convertSeleniumRectToViewRect:[_selection rect]];
        highlightView.frame = viewRect;
        [highlightView setHidden:NO];
    }
    else
    {
        [highlightView setHidden:YES];
    }
}

-(void)setSelectedNode:(WebDriverElementNode*)node
{
	// get the tree from the node to the root
	NSMutableArray *nodes = [NSMutableArray new];
	WebDriverElementNode *currentNode = node;
	[nodes addObject:currentNode];
	while(currentNode.parent != nil)
	{
		currentNode = currentNode.parent;
		[nodes addObject:currentNode];
	}
	
	// get the indexes from the root to the node
	NSMutableArray *nodePath = [NSMutableArray new];
	for(NSInteger i=nodes.count-1; i > 0; i--)
	{
		currentNode = [nodes objectAtIndex:i];
		WebDriverElementNode *nodeToFind = [nodes objectAtIndex:i-1];
		BOOL foundNode = NO;
		for(int j=0; j < currentNode.visibleChildren.count && !foundNode; j++)
		{
			if ([currentNode.visibleChildren objectAtIndex:j] == nodeToFind)
			{
				[nodePath addObject:[NSNumber numberWithInt:j]];
			}
		}
	}
	
	// build index set
	NSIndexPath *indexPath = [NSIndexPath new];
	for(int i=0; i <nodePath.count; i++)
	{
		indexPath = [indexPath indexPathByAddingIndex:[[nodePath objectAtIndex:i] integerValue]];
		if (_selectedIndexes.count < i+1)
		{
			[_selectedIndexes addObject:[NSNumber numberWithInteger:[[nodePath objectAtIndex:i] integerValue]]];
		}
		else
		{
			[_selectedIndexes replaceObjectAtIndex:i withObject:[nodePath objectAtIndex:i]];
		}
		[self setSelectedNode:[NSIndexSet indexSetWithIndex:[[nodePath objectAtIndex:i] integerValue]] inColumn:i];
	}
	
	// select
	_selection = node;
	[_windowController.browser setSelectionIndexPath:indexPath];
	[self updateDetailsDisplay];
}

-(WebDriverElementNode*)findDisplayedNodeForPoint:(NSPoint)point node:(WebDriverElementNode*)node
{
	// DFS for element inside rect
	for(int i=0; i< node.visibleChildren.count; i++)
	{
		WebDriverElementNode *child = [node.visibleChildren objectAtIndex:i];
		WebDriverElementNode *result = [self findDisplayedNodeForPoint:point node:child];
		if (result != nil)
			return result;
	}
	
	if (NSPointInRect(point, node.rect))
		return node;
	
	return nil;
}

-(void) handleClickAt:(NSPoint)windowPoint seleniumPoint:(NSPoint)seleniumPoint
{
	if (_windowController.swipePopover.isShown)
	{
		if (_windowController.swipePopoverViewController.beginPointWasSetLast)
		{
			[_windowController.swipePopoverViewController setEndPoint:seleniumPoint];
		}
		else
		{
			[_windowController.swipePopoverViewController setBeginPoint:seleniumPoint];
		}
	}
	else
	{
		[self selectNodeNearestPoint:seleniumPoint];
	}
}

-(void) selectNodeNearestPoint:(NSPoint)point
{
	WebDriverElementNode *node = [self findDisplayedNodeForPoint:point node:_rootNode];
	if (node != nil)
	{
		[self setSelectedNode:node];
	}
}

-(SEWebElement*) elementForSelectedNode
{
    SEWebElement *result = nil;
    NSString *xPath = [[self xPathForSelectedNode] stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    NSArray *tags = [xPath componentsSeparatedByString:@"/"];
    for(int i=0; i < tags.count; i++)
    {
        NSError *error;
        NSString *component = [tags objectAtIndex:i];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"([^\\[]+)\\[([^\\]]+)\\]" options:NSRegularExpressionCaseInsensitive error:&error];
        NSTextCheckingResult *firstResult = [regex firstMatchInString:component options:0 range:NSMakeRange(0, [component length])];
        if ([firstResult numberOfRanges] == 3)
        {
            NSString *tagString = [component substringWithRange:[firstResult rangeAtIndex:1]];
            NSString *indexString = [component substringWithRange:[firstResult rangeAtIndex:2]];
            NSInteger index = [[[NSNumberFormatter new] numberFromString:indexString] integerValue] - 1;
            NSArray *elements = (result == nil) ?
			[self.driver findElementsBy:[SEBy tagName:tagString]] :
			[result findElementsBy:[SEBy tagName:tagString]];
            if (elements.count > index)
            {
                result = [elements objectAtIndex:index];
            }
            else
            {
                return nil;
            }
			
        }
    }
    return result;
}

-(NSString*) xPathForSelectedNode
{
    WebDriverElementNode *parentNode = _rootNode;
    NSMutableString *xPath = [NSMutableString stringWithString:@"/"];
    BOOL foundNode = NO;
    for(int i=0; i < _selectedIndexes.count && !foundNode; i++)
    {
        // find current node
        WebDriverElementNode *currentNode = [parentNode.visibleChildren objectAtIndex:[[_selectedIndexes objectAtIndex:i] integerValue]];
        if (currentNode == _selection)
            foundNode = YES;

        // build xpath
        [xPath appendString:@"/"];
        [xPath appendString:currentNode.typeShortcut];
        NSInteger nodeTypeCount = 0;
        for(int j=0; j < parentNode.children.count ; j++)
        {
            WebDriverElementNode *node = [parentNode.children objectAtIndex:j];
			WebDriverElementNode *selectedNodeAtLevel = _rootNode;
			for(int k=0; k < _selectedIndexes.count && k <= i; k++)
				selectedNodeAtLevel = [selectedNodeAtLevel.visibleChildren objectAtIndex:[[_selectedIndexes objectAtIndex:k] intValue]];
            if ( [node.type isEqualToString:selectedNodeAtLevel.type])
            {
                nodeTypeCount++;
            }
			if (node == selectedNodeAtLevel)
				break;
        }
        
        [xPath appendString:[NSString stringWithFormat:@"[%ld]", nodeTypeCount]];
        parentNode = currentNode;
    }
    return xPath;
}

-(BOOL) selectedNodeNameIsUniqueInTree:(WebDriverElementNode*)node
{
	if (node == _selection)
	{
		if ((id)node.name == [NSNull null] || node.name == nil)
		{
			return NO;
		}
	}
	else
	{
		if ((id)node.name != [NSNull null] && node.name != nil)
		{
			if ([node.name isEqualToString:_selection.name])
				return NO;
		}
	}
	for(int i=0; i < node.children.count; i++)
	{
		if (![self selectedNodeNameIsUniqueInTree:[node.children objectAtIndex:i]])
		{
			return NO;
		}
	}
	return YES;
}

-(AppiumCodeMakerLocator*) locatorForSelectedNode
{
	AppiumCodeMakerLocator *locator;
	if ([self selectedNodeNameIsUniqueInTree:_rootNode])
	{
		locator = [[AppiumCodeMakerLocator alloc] initWithLocatorType:APPIUM_CODE_MAKER_LOCATOR_TYPE_NAME locatorString:_selection.name];
	}
	else
	{
		locator = [[AppiumCodeMakerLocator alloc] initWithLocatorType:APPIUM_CODE_MAKER_LOCATOR_TYPE_XPATH locatorString:[self xPathForSelectedNode]];
	}
	locator.xPath = [self xPathForSelectedNode];
	return locator;
}

@end
