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
NSMutableArray *selectedIndexes;
NSImage *lastScreenshot;
NSString *lastPageSource;
WebDriverElementNode *selection;

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
        lastPageSource = [driver pageSource];
	}
	NSError *e = nil;
	NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData: [lastPageSource dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &e];
	_rootNode = [[WebDriverElementNode alloc] initWithJSONDict:jsonDict showDisabled:[self.showDisabled boolValue] showInvisible:[self.showInvisible boolValue]];
    [_browser loadColumnZero];
}

-(void)refreshScreenshot
{
	lastScreenshot = [driver screenshot];
	[_screenshotView setImage:lastScreenshot];
}

- (id)rootItemForBrowser:(NSBrowser *)browser {
    if (_rootNode == nil) {
        [self populateDOM];
		selectedIndexes = [NSMutableArray new];
    }
    return _rootNode;
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
		if (selectedIndexes.count < column+1)
		{
			[selectedIndexes addObject:[NSNumber numberWithInteger:[proposedSelectionIndexes firstIndex]]];
		}
		else
		{
			[selectedIndexes replaceObjectAtIndex:column withObject:[NSNumber numberWithInteger:[proposedSelectionIndexes firstIndex]]];
		}
        
		WebDriverElementNode *node = _rootNode;
		for(int i=0; i < selectedIndexes.count && i < column+1; i++)
		{
			node = [node.children objectAtIndex:[[selectedIndexes objectAtIndex:i] integerValue]];
		}
        selection = node;
        [self setHighlightBox];
        NSString *newDetails = [NSString stringWithFormat:@"%@\nid string: %@", _detailsTextView.string, [self xPathForSelectedNode]];
        [_detailsTextView setString:newDetails];
	}
    else
    {
        selection = nil;
        [_detailsTextView setString:@""];
    }
}

-(void)setHighlightBox
{
    if (selection != nil)
    {
        [_detailsTextView setString:[selection infoText]];
        if (!_highlightView.layer) {
            [_highlightView setWantsLayer:YES];
            _highlightView.layer.borderColor = [NSColor redColor].CGColor;
            _highlightView.layer.borderWidth = 2.0f;
            _highlightView.layer.cornerRadius = 8.0f;
        }
        
        CGRect viewRect = [selection rect];
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
        viewRect.origin.x = xOffset + (selection.rect.origin.x * scalar);
        viewRect.origin.y = maxY - (yOffset + ((selection.rect.origin.y + selection.rect.size.height) * scalar));
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
    NSString *idString = nil;
    WebDriverElementNode *parentNode = _rootNode;
    NSMutableString *xPath = [NSMutableString stringWithString:@"/"];
    BOOL foundNode = NO;
    for(int i=0; i < selectedIndexes.count && !foundNode; i++)
    {
        WebDriverElementNode *currentNode = [parentNode.children objectAtIndex:[[selectedIndexes objectAtIndex:i] integerValue]];
        if (currentNode == selection)
            foundNode = YES;
        [xPath appendString:@"/"];
        [xPath appendString:currentNode.type];
        NSInteger nodeTypeCount = 0;
        for(int j=0; j < parentNode.children.count; j++)
        {
            WebDriverElementNode *node = [parentNode.children objectAtIndex:j];
            if ( [node.type isEqualToString:selection.type] && j < [[selectedIndexes objectAtIndex:i] integerValue])
            {
                nodeTypeCount++;
            }
            if (idString != nil && [idString isEqualToString:node.label])
            {
                idString = nil;
            }
        }
        [xPath appendString:[NSString stringWithFormat:@"[%ld]", nodeTypeCount]];
        parentNode = currentNode;
    }
    return [NSString stringWithFormat:@"SEBy xPath:@\"%@\"", xPath];
}

-(IBAction)tap:(id)sender
{
    
}

@end
