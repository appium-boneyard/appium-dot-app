//
//  AppiumCodeMakerLocator.m
//  Appium
//
//  Created by Dan Cuellar on 4/11/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerLocator.h"

#define APPIUM_CODEMAKER_LOCATOR_TYPE_ENCODER_KEY @"locatorType"
#define APPIUM_CODEMAKER_LOCATOR_STRING_ENCODER_KEY @"locatorString"

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

#pragma mark - NSCoding Implementation
-(id) initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]) 
    {
        self.locatorType = [aDecoder decodeIntForKey:APPIUM_CODEMAKER_LOCATOR_TYPE_ENCODER_KEY];
        self.locatorString = [aDecoder decodeObjectForKey:APPIUM_CODEMAKER_LOCATOR_STRING_ENCODER_KEY];
    }
    return self;
}
                                          
-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.locatorType forKey:APPIUM_CODEMAKER_LOCATOR_TYPE_ENCODER_KEY];
    [aCoder encodeObject:self.locatorString forKey:APPIUM_CODEMAKER_LOCATOR_STRING_ENCODER_KEY];
}

#pragma mark - NSCopying Implementation
-(id)copyWithZone:(NSZone *)zone
{
	AppiumCodeMakerLocator *another = [[AppiumCodeMakerLocator alloc] initWithLocatorType:self.locatorType locatorString:[self.locatorString copy]];
	return another;
}

@end
