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
NSImage *lastScreenshot;
NSString *lastPageSource;
WebDriverElementNode *browserSelection;
WebDriverElementNode *selection;
NSMutableArray *browserSelectedIndexes;
NSMutableArray *selectedIndexes;

- (id)init
{
    self = [super init];
    if (self) {
        _showDisabled = YES;
        _showInvisible = YES;
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

-(void)populateDOM
{
	if (driver == nil)
	{
		AppiumModel *model = [(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] model];
		SECapabilities *capabilities = [SECapabilities new];
		[capabilities setPlatform:@"Mac"];
		[capabilities setBrowserName:@"iOS"];
		[capabilities setVersion:@"6.1"];
        NSError *error;
		driver = [[SERemoteWebDriver alloc] initWithServerAddress:[model ipAddress] port:[[model port] integerValue] desiredCapabilities:capabilities requiredCapabilities:nil error:&error];
        [self refreshScreenshot];
        [self refreshPageSource];
	}
	NSError *e = nil;
	NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData: [lastPageSource dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &e];
	_browserRootNode = [[WebDriverElementNode alloc] initWithJSONDict:jsonDict showDisabled:[self.showDisabled boolValue] showInvisible:[self.showInvisible boolValue]];
    _rootNode = [[WebDriverElementNode alloc] initWithJSONDict:jsonDict showDisabled:YES showInvisible:YES];
    [_browser loadColumnZero];
	browserSelectedIndexes = [NSMutableArray new];
	selectedIndexes = [NSMutableArray new];
}

-(void)refreshPageSource
{
	lastPageSource = [driver pageSource];
}

-(void)refreshScreenshot
{
	lastScreenshot = [driver screenshot];
	[_screenshotView setImage:lastScreenshot];
}

- (id)rootItemForBrowser:(NSBrowser *)browser {
    if (_browserRootNode == nil) {
        [self populateDOM];
    }
    return _browserRootNode;
}

- (NSInteger)browser:(NSBrowser *)browser numberOfChildrenOfItem:(id)item {
    WebDriverElementNode *node = (WebDriverElementNode *)item;
    return node.children.count;
}

- (id)browser:(NSBrowser *)browser child:(NSInteger)index ofItem:(id)item {
    WebDriverElementNode *node = (WebDriverElementNode *)item;
    return [node.children objectAtIndex:index];
}

- (BOOL)browser:(NSBrowser *)browser isLeafItem:(id)item {
    WebDriverElementNode *node = (WebDriverElementNode *)item;
    return node.children.count < 1;
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
		// browser selection
		if (browserSelectedIndexes.count < column+1)
		{
			[browserSelectedIndexes addObject:[NSNumber numberWithInteger:[proposedSelectionIndexes firstIndex]]];
		}
		else
		{
			[browserSelectedIndexes replaceObjectAtIndex:column withObject:[NSNumber numberWithInteger:[proposedSelectionIndexes firstIndex]]];
		}
        
		WebDriverElementNode *node = _browserRootNode;
		for(int i=0; i < browserSelectedIndexes.count && i < column+1; i++)
		{
			node = [node.children objectAtIndex:[[browserSelectedIndexes objectAtIndex:i] integerValue]];
		}
        browserSelection = node;
        [self setHighlightBox];
        //NSString *newDetails = [NSString stringWithFormat:@"%@\nid string: %@", _detailsTextView.string, [self xPathForSelectedNode]];
        //[_detailsTextView setString:newDetails];
		
		
		// actual selection
		node = _rootNode;
		for(int i=0; i < selectedIndexes.count && i < column; i++)
		{
			node = [node.children objectAtIndex:[[selectedIndexes objectAtIndex:i] integerValue]];
		}
		int indexMapping = 0;
		int actualIndex = 0;
		for(; actualIndex < node.children.count && indexMapping < [[browserSelectedIndexes objectAtIndex:column] intValue]; actualIndex++)
		{
			WebDriverElementNode* child = [node.children objectAtIndex:actualIndex];
			if ([child shouldDisplayifInvisible:_showInvisible disabled:_showDisabled])
			{
				indexMapping++;
			}
		}
		
		if (selectedIndexes.count < column+1)
		{
			[selectedIndexes addObject:[NSNumber numberWithInteger:indexMapping]];
		}
		else
		{
			[selectedIndexes replaceObjectAtIndex:column withObject:[NSNumber numberWithInteger:indexMapping]];
		}
		
		node = _rootNode;
		for(int i=0; i < selectedIndexes.count && i < column+1; i++)
		{
			node = [node.children objectAtIndex:[[selectedIndexes objectAtIndex:i] integerValue]];
		}
        selection = node;
		
	}
    else
    {
        browserSelection = nil;
		selection = nil;
        [_detailsTextView setString:@""];
    }
}

-(void)setHighlightBox
{
    if (browserSelection != nil)
    {
        [_detailsTextView setString:[browserSelection infoText]];
        if (!_highlightView.layer) {
            [_highlightView setWantsLayer:YES];
            _highlightView.layer.borderColor = [NSColor redColor].CGColor;
            _highlightView.layer.borderWidth = 2.0f;
            _highlightView.layer.cornerRadius = 8.0f;
        }
        
        CGRect viewRect = [browserSelection rect];
        CGFloat scalar = 320.0 / lastScreenshot.size.height;
        CGFloat maxX = 240.0;
        CGFloat maxY = 320.0;
        CGFloat xOffset = 0.0;
        CGFloat yOffset = 0.0;
        
        if (lastScreenshot.size.width > lastScreenshot.size.height)
        {
            maxY = lastScreenshot.size.height * (240.0 / lastScreenshot.size.width);
            yOffset = (320.0 - maxY) / 2.0;
        }
        else
        {
            maxX = lastScreenshot.size.width * (320.0 / lastScreenshot.size.height);
            xOffset = (240.0 - maxX) / 2.0;
        }
        viewRect.size.width *= scalar;
        viewRect.size.height *= scalar;
        viewRect.origin.x = xOffset + (browserSelection.rect.origin.x * scalar);
        viewRect.origin.y = maxY - (yOffset + ((browserSelection.rect.origin.y + browserSelection.rect.size.height) * scalar));
        _highlightView.frame = viewRect;
        [_highlightView setHidden:NO];
    }
    else
    {
        [_highlightView setHidden:YES];
    }
}

/*
-(NSString*) xPathForSelectedNode
{
    WebDriverElementNode *parentNode = _rootNode;
    WebDriverElementNode *browserParentNode = _browserRootNode;
    NSMutableString *xPath = [NSMutableString stringWithString:@"/"];
    BOOL foundNode = NO;
    for(int i=0; i < browserSelectedIndexes.count && !foundNode; i++)
    {
        // find current browser node
        WebDriverElementNode *currentBrowserNode = [browserParentNode.children objectAtIndex:[[browserSelectedIndexes objectAtIndex:i] integerValue]];
        if (currentBrowserNode == browserSelection)
            foundNode = YES;
        
        // find current node
        WebDriverElementNode *currentNode = nil;
        NSInteger nodeCount = -1;
        for(int j=0; j < parentNode.children.count && currentNode == nil; j++)
        {
            WebDriverElementNode *node = [parentNode.children objectAtIndex:j];
            if ([node shouldDisplay])
            {
                nodeCount++;
            }
            if (nodeCount == [[browserSelectedIndexes objectAtIndex:i] integerValue])
            {
                currentNode = node;
            }
        }
        
        // build xpath
        [xPath appendString:@"/"];
        [xPath appendString:currentBrowserNode.typeShortcut];
        NSInteger nodeTypeCount = 1;
        for(int j=0; j < parentNode.children.count; j++)
        {
            WebDriverElementNode *node = [parentNode.children objectAtIndex:j];
            if ( [node.type isEqualToString:browserSelection.type] && j <= nodeCount)
            {
                nodeTypeCount++;
            }
        }
        
        [xPath appendString:[NSString stringWithFormat:@"[%ld]", nodeTypeCount]];
        browserParentNode = currentBrowserNode;
        parentNode = currentNode;
    }
    return xPath;
} */

-(IBAction)tap:(id)sender
{
    //SEWebElement *element = [driver findElementBy:[SEBy xPath:[self xPathForSelectedNode]]];
    //[element click];
    //[self refreshScreenshot];
    //[self refreshPageSource];
    //[self populateDOM];
	NSLog(@"NYI");
}

@end
