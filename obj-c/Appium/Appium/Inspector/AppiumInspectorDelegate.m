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
#import <Selenium/RemoteWebDriver.h>

@implementation AppiumInspectorDelegate

RemoteWebDriver *driver;

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
	if (driver == nil)
	{
		AppiumModel *model = [(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] model];
		Capabilities *capabilities = [Capabilities new];
		[capabilities setPlatform:@"Mac"];
		[capabilities setBrowserName:@"iOS"];
		[capabilities setVersion:@"6.1"];
        NSError *error;
		driver = [[RemoteWebDriver alloc] initWithServerAddress:[model ipAddress] port:[[model port] integerValue] desiredCapabilities:capabilities requiredCapabilities:nil error:&error];
	}
	NSString *pageSource = [driver pageSource];
	NSError *e = nil;
	NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData: [pageSource dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &e];
	_rootNode = [[WebDriverElementNode alloc] initWithJSONDict:jsonDict];
}

@end
