//
//  AppiumInspectorDelegate.m
//  Appium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumInspectorDelegate.h"

@implementation AppiumInspectorDelegate


- (id)rootItemForBrowser:(NSBrowser *)browser {
    if (_rootNode == nil) {
        [self populateDOM];
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

-(void)populateDOM
{
	NSTask *pageSourceTask = [NSTask new];
	[pageSourceTask setCurrentDirectoryPath:[[NSBundle mainBundle]resourcePath]];
	[pageSourceTask setLaunchPath:@"/usr/bin/python"];
	[pageSourceTask setArguments:[NSArray arrayWithObjects:@"page_source.py", @"127.0.0.1", @"4723", nil]];
	[pageSourceTask setStandardOutput:[NSPipe pipe]];
	[pageSourceTask launch];
	[pageSourceTask waitUntilExit];
	NSData *data = [[[pageSourceTask standardOutput] fileHandleForReading] readDataToEndOfFile];
	NSError *e = nil;
	NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
	_rootNode = [[WebDriverElementNode alloc] initWithJSONDict:jsonDict];
}

@end
