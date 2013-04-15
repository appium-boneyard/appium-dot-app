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
        self.elementReference = nil;
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
-(id) copyWithZone:(NSZone *)zone
{
	AppiumCodeMakerLocator *another = [[AppiumCodeMakerLocator alloc] initWithLocatorType:self.locatorType locatorString:[self.locatorString copyWithZone:zone]];
	return another;
}

#pragma mark - Other Methods
// vvv remove once xpath with indices is fixed
-(SEWebElement*) elementWithDriver:(SERemoteWebDriver*)driver
{

    return (self.elementReference == nil) ? [driver findElementBy:[self by]] : self.elementReference;
}
// ^^^ remove once xpath with indices is fixed

-(SEBy*) by
{
    switch(self.locatorType)
    {
        case APPIUM_CODE_MAKER_LOCATOR_TYPE_NAME:
            return [SEBy name:self.locatorString];
        case APPIUM_CODE_MAKER_LOCATOR_TYPE_XPATH:
            return [SEBy xPath:self.xPath];
        default:
            return nil;
    }
}

@end
