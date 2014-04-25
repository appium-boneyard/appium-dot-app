//
//  AppiumCodeMakerLocator.m
//  Appium
//
//  Created by Dan Cuellar on 4/11/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerLocator.h"
#import "AppiumPreferencesFile.h"

@implementation AppiumCodeMakerLocator

-(id) initWithLocatorType:(AppiumCodeMakerLocatorType)locatorType locatorString:(NSString*)locatorString xPath:(NSString*)xPath
{
	self = [super init];
    if (self)
	{
		self.locatorType = locatorType;
		self.locatorString = locatorString;
		self.xPath = xPath;
	}
    return self;
}

#pragma mark - NSCoding Implementation
-(id) initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.locatorType = [aDecoder decodeIntForKey:@"locatorType"];
        self.locatorString = [aDecoder decodeObjectForKey:@"locatorString"];
		self.xPath = [aDecoder decodeObjectForKey:@"xPath"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.locatorType forKey:@"locatorType"];
    [aCoder encodeObject:self.locatorString forKey:@"locatorString"];
	[aCoder encodeObject:self.xPath forKey:@"xPath"];
}

#pragma mark - NSCopying Implementation
-(id) copyWithZone:(NSZone *)zone
{
	AppiumCodeMakerLocator *another = [[AppiumCodeMakerLocator alloc] initWithLocatorType:self.locatorType locatorString:[self.locatorString copyWithZone:zone] xPath:[self.xPath copyWithZone:zone]];
	return another;
}

#pragma mark - Other Methods
-(SEBy*) by
{
	if ([[NSUserDefaults standardUserDefaults] boolForKey:APPIUM_PLIST_INSPECTOR_USES_XPATH_ONLY])
	{
		return [self byXPath];
	}

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

-(SEBy*) byXPath
{
	return [SEBy xPath:self.xPath];
}

@end
