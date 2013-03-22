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

@implementation AppiumInspectorDelegate

SERemoteWebDriver *driver;
NSMutableArray *selectedIndexes;

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
		[_detailsTextView setString:[node infoText]];
	}
    return proposedSelectionIndexes;
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
	}
	NSString *pageSource = [driver pageSource];
	NSError *e = nil;
	NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData: [pageSource dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &e];
	_rootNode = [[WebDriverElementNode alloc] initWithJSONDict:jsonDict];
	[_screenshotView setImage:[driver screenshot]];
}

@end
