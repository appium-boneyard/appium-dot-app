//
//  AppiumInspectorDelegate.m
//  Appium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumInspectorDelegate.h"
#import "AppiumModel.h"
#import "AppiumAppDelegate.h"
#import <Selenium/SERemoteWebDriver.h>
#import <QuartzCore/QuartzCore.h>

@implementation AppiumInspectorDelegate

SERemoteWebDriver *driver;
NSString *lastPageSource;
WebDriverElementNode *selection;
NSMutableArray *selectedIndexes;

- (id)init
{
    self = [super init];
    if (self) {
        _showDisabled = YES;
        _showInvisible = YES;
        [self setKeysToSend:@""];
        [self setDomIsPopulating:NO];
    }
    return self;
}

-(NSNumber*) showDisabled { return [NSNumber numberWithBool:_showDisabled]; }
-(NSNumber*) showInvisible { return [NSNumber numberWithBool:_showInvisible]; }

-(void) setShowDisabled:(NSNumber *)showDisabled
{
    _showDisabled = [showDisabled boolValue];
    [self populateDOM];
}
-(void) setShowInvisible:(NSNumber *)showInvisible
{
    _showInvisible = [showInvisible boolValue];
    [self populateDOM];
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
	if (driver == nil)
	{
		AppiumModel *model = [(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] model];
		SECapabilities *capabilities = [SECapabilities new];
		[capabilities setPlatform:@"Mac"];
		[capabilities setBrowserName:@"iOS"];
		[capabilities setVersion:@"6.1"];
		driver = [[SERemoteWebDriver alloc] initWithServerAddress:[model ipAddress] port:[[model port] integerValue]];
		NSArray *sessions = [driver allSessions];
		if (sessions.count > 0)
		{
			[driver setSession:[sessions objectAtIndex:0]];
		}
		if (sessions.count == 0 || driver.session == nil || driver.session.capabilities.platform == nil)
		{
			[driver startSessionWithDesiredCapabilities:capabilities requiredCapabilities:nil];
		}
		[self refreshScreenshot];
        [self refreshPageSource];
	}
	NSError *e = nil;
	NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData: [lastPageSource dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &e];
	_browserRootNode = [[WebDriverElementNode alloc] initWithJSONDict:jsonDict parent:nil showDisabled:[self.showDisabled boolValue] showInvisible:[self.showInvisible boolValue]];
    _rootNode = [[WebDriverElementNode alloc] initWithJSONDict:jsonDict parent:nil showDisabled:_showDisabled showInvisible:_showInvisible];
    [_browser performSelectorOnMainThread:@selector(loadColumnZero) withObject:nil waitUntilDone:YES];
	selection = nil;
	selectedIndexes = [NSMutableArray new];
    [self performSelectorOnMainThread:@selector(updateDetailsDisplay) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(setDomIsPopulatingToNo) withObject:nil waitUntilDone:YES];
}

-(void)refreshPageSource
{
	lastPageSource = [driver pageSource];
}

-(void)refreshScreenshot
{
	NSImage *screenshot = [driver screenshot];
	[_screenshotView setImage:screenshot];
	[_screenshotView setInspector:self];
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
		for(int i=0; i < selectedIndexes.count && i < column; i++)
		{
			parentNode = [parentNode.visibleChildren objectAtIndex:[[selectedIndexes objectAtIndex:i] integerValue]];
		}
		
		// find the element
        selection = [parentNode.visibleChildren objectAtIndex:[proposedSelectionIndexes firstIndex]];
		if (selectedIndexes.count < column+1)
		{
			[selectedIndexes addObject:[NSNumber numberWithInteger:[proposedSelectionIndexes firstIndex]]];
		}
		else
		{
			[selectedIndexes replaceObjectAtIndex:column withObject:[NSNumber numberWithInteger:[proposedSelectionIndexes firstIndex]]];
		}
	}
    else
    {
		selection = nil;
    }
	[self updateDetailsDisplay];
}

-(void) updateDetailsDisplay
{
	if (selection != nil)
	{
        NSString *newDetails = [NSString stringWithFormat:@"%@\nXPath string: %@", [selection infoText], [self xPathForSelectedNode]];
        [_detailsTextView setString:newDetails];
	}
	else
	{
        [_detailsTextView setString:@""];
	}
	
	if (selection != nil)
    {
        if (!_highlightView.layer) {
            [_highlightView setWantsLayer:YES];
            _highlightView.layer.borderWidth = 2.0f;
            _highlightView.layer.cornerRadius = 8.0f;
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
            _highlightView.layer.borderColor = redCGColor;
        }
		
        CGRect viewRect = [_screenshotView convertSeleniumRectToViewRect:[selection rect]];
        _highlightView.frame = viewRect;
        [_highlightView setHidden:NO];
    }
    else
    {
        [_highlightView setHidden:YES];
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
		if (selectedIndexes.count < i+1)
		{
			[selectedIndexes addObject:[NSNumber numberWithInteger:[[nodePath objectAtIndex:i] integerValue]]];
		}
		else
		{
			[selectedIndexes replaceObjectAtIndex:i withObject:[nodePath objectAtIndex:i]];
		}
		[self setSelectedNode:[NSIndexSet indexSetWithIndex:[[nodePath objectAtIndex:i] integerValue]] inColumn:i];
	}
	
	// select
	selection = node;
	[_browser setSelectionIndexPath:indexPath];
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

-(void)selectNodeNearestPoint:(NSPoint)point
{
	WebDriverElementNode *node = [self findDisplayedNodeForPoint:point node:_rootNode];
	if (node != nil)
	{
		[self setSelectedNode:node];
	}
}

-(NSString*) xPathForSelectedNode
{
    WebDriverElementNode *parentNode = _rootNode;
    NSMutableString *xPath = [NSMutableString stringWithString:@"/"];
    BOOL foundNode = NO;
    for(int i=0; i < selectedIndexes.count && !foundNode; i++)
    {
        // find current node
        WebDriverElementNode *currentNode = [parentNode.visibleChildren objectAtIndex:[[selectedIndexes objectAtIndex:i] integerValue]];
        if (currentNode == selection)
            foundNode = YES;

        // build xpath
        [xPath appendString:@"/"];
        [xPath appendString:currentNode.typeShortcut];
        NSInteger nodeTypeCount = 0;
        for(int j=0; j < parentNode.children.count ; j++)
        {
            WebDriverElementNode *node = [parentNode.children objectAtIndex:j];
			WebDriverElementNode *selectedNodeAtLevel = _rootNode;
			for(int k=0; k < selectedIndexes.count && k <= i; k++)
				selectedNodeAtLevel = [selectedNodeAtLevel.visibleChildren objectAtIndex:[[selectedIndexes objectAtIndex:k] intValue]];
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
                      [driver findElementsBy:[SEBy tagName:tagString]] :
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

-(IBAction)tap:(id)sender
{
    SEWebElement *element = [self elementForSelectedNode];
    [element click];
    [self refresh:sender];
}

-(IBAction)refresh:(id)sender
{
    [self performSelectorInBackground:@selector(refreshAll) withObject:nil];
}

-(void)refreshAll
{
    [self performSelectorOnMainThread:@selector(setDomIsPopulatingToYes) withObject:nil waitUntilDone:YES];
    [self refreshScreenshot];
    [self refreshPageSource];
    [self populateDOM];
}

-(IBAction)sendKeys:(id)sender
{
    SEWebElement *element = [self elementForSelectedNode];
    [element sendKeys:self.keysToSend];
    [self refresh:sender];
}

@end
