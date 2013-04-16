//
//  AppiumCodeMakerLocator.h
//  Appium
//
//  Created by Dan Cuellar on 4/11/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Selenium/SERemoteWebDriver.h>

typedef enum appiumCodeMakerLocatorTypes
{
    APPIUM_CODE_MAKER_LOCATOR_TYPE_REFERENCE,
	APPIUM_CODE_MAKER_LOCATOR_TYPE_NAME,
	APPIUM_CODE_MAKER_LOCATOR_TYPE_XPATH
	
} AppiumCodeMakerLocatorType;

@interface AppiumCodeMakerLocator : NSObject<NSCopying,NSCoding>

@property AppiumCodeMakerLocatorType locatorType;
@property NSString *locatorString;
@property NSString *xPath;

-(id) initWithLocatorType:(AppiumCodeMakerLocatorType)locatorType locatorString:(NSString*)locatorString xPath:(NSString*)xPath;
-(SEBy*) by;
-(SEBy*) byXPath;

@end
