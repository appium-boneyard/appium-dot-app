//
//  AppiumCodeMakerActionScrollTo.m
//  Appium
//
//  Created by Dan Cuellar on 5/12/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerActionScrollTo.h"
#import <Selenium/SERemoteWebDriver.h>

@implementation AppiumCodeMakerActionScrollTo

-(id) initWithLocator:(AppiumCodeMakerLocator*)locator
{
    self = [super init];
    if (self)
	{
		self.actionType = APPIUM_CODE_MAKER_ACTION_SCROLL_TO;
		[self.params setObject:locator forKey:@"locator"];
	}
    return self;
}

-(AppiumCodeMakerActionBlock) block
{
    return ^(SERemoteWebDriver* driver){
        SEWebElement *element = [driver findElementBy:[self.locator by]];
        [driver executeScript:@"mobile: scrollTo" arguments:[NSArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys: element.opaqueId, @"element", nil]]];
    };
}

-(AppiumCodeMakerLocator*) locator { return [self.params objectForKey:@"locator"]; }

@end
