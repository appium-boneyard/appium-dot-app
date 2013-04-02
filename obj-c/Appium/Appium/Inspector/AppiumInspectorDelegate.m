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
        NSError *error;
		driver = [[SERemoteWebDriver alloc] initWithServerAddress:[model ipAddress] port:[[model port] integerValue] desiredCapabilities:capabilities requiredCapabilities:nil error:&error];
        [self refreshScreenshot];
        [self refreshPageSource];
	}
	NSError *e = nil;
	NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData: [lastPageSource dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &e];
	_browserRootNode = [[WebDriverElementNode alloc] initWithJSONDict:jsonDict showDisabled:[self.showDisabled boolValue] showInvisible:[self.showInvisible boolValue]];
    _rootNode = [[WebDriverElementNode alloc] initWithJSONDict:jsonDict showDisabled:YES showInvisible:YES];
    [_browser performSelectorOnMainThread:@selector(loadColumnZero) withObject:nil waitUntilDone:YES];
	browserSelectedIndexes = [NSMutableArray new];
	selectedIndexes = [NSMutableArray new];
    [self performSelectorOnMainThread:@selector(setDomIsPopulatingToNo) withObject:nil waitUntilDone:YES];
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
        [self performSelectorInBackground:@selector(populateDOM) withObject:nil];
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
		
		// update display
		[self setHighlightBox];
        NSString *newDetails = [NSString stringWithFormat:@"%@\nXPath string: %@", _detailsTextView.string, [self xPathForSelectedNode]];
        [_detailsTextView setString:newDetails];
		
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
		
        CGRect viewRect = [_screenshotView translateSeleniumRect:[browserSelection rect]];
        _highlightView.frame = viewRect;
        [_highlightView setHidden:NO];
    }
    else
    {
        [_highlightView setHidden:YES];
    }
}

-(NSString*) xPathForSelectedNode
{
    WebDriverElementNode *parentNode = _rootNode;
    NSMutableString *xPath = [NSMutableString stringWithString:@"/"];
    BOOL foundNode = NO;
    for(int i=0; i < browserSelectedIndexes.count && !foundNode; i++)
    {
        // find current browser node
        WebDriverElementNode *currentNode = [parentNode.children objectAtIndex:[[browserSelectedIndexes objectAtIndex:i] integerValue]];
        if (currentNode == selection)
            foundNode = YES;

        // build xpath
        [xPath appendString:@"/"];
        [xPath appendString:currentNode.typeShortcut];
        NSInteger nodeTypeCount = 0;
        for(int j=0; j < parentNode.children.count; j++)
        {
            WebDriverElementNode *node = [parentNode.children objectAtIndex:j];
			WebDriverElementNode *selectedNodeAtLevel = _rootNode;
			for(int k=0; k < selectedIndexes.count && k <= i; k++)
				selectedNodeAtLevel = [selectedNodeAtLevel.children objectAtIndex:[[selectedIndexes objectAtIndex:k] intValue]];
            if ( [node.type isEqualToString:selectedNodeAtLevel.type] && j <= [[selectedIndexes objectAtIndex:i] intValue])
            {
                nodeTypeCount++;
            }
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
