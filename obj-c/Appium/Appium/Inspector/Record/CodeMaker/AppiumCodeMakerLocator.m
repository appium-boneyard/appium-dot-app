//
//  AppiumCodeMakerLocator.m
//  Appium
//
//  Created by Dan Cuellar on 4/11/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerLocator.h"

@implementation AppiumCodeMakerLocator

-(id) initWithLocatorType:(AppiumCodeMakerLocatorType)locatorType locatorString:(NSString*)locatorString
{
	self = [super init];
    if (self)
	{
		self.locatorType = locatorType;
		self.locatorString = locatorString;
	}
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
	AppiumCodeMakerLocator *another = [[AppiumCodeMakerLocator alloc] initWithLocatorType:self.locatorType locatorString:[self.locatorString copy]];
	return another;
}

@end
