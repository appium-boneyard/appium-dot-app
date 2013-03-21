//
//  SEEnums.h
//  Selenium
//
//  Created by Dan Cuellar on 3/19/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEEnums : NSObject

typedef enum seleniumScreenOrientationTypes
{
	SELENIUM_SCREEN_ORIENTATION_PORTRAIT,
	SELENIUM_SCREEN_ORIENTATION_LANDSCAPE,
	SELENIUM_SCREEN_ORIENTATION_UNKOWN
} SEScreenOrientation;

typedef enum seleniumTimeoutTypes
{
	SELENIUM_TIMEOUT_IMPLICIT,
	SELENIUM_TIMEOUT_SCRIPT,
	SELENIUM_TIMEOUT_PAGELOAD
} SETimeoutType;


typedef enum seleniumApplicationCacheStatusTypes
{
    SELENIUM_APPLICATION_CACHE_STATUS_UNCACHED,
    SELENIUM_APPLICATION_CACHE_STATUS_IDLE,
    SELENIUM_APPLICATION_CACHE_STATUS_CHECKING,
    SELENIUM_APPLICATION_CACHE_STATUS_DOWNLOADING,
    SELENIUM_APPLICATION_CACHE_STATUS_UPDATE_READY,
    SELENIUM_APPLICATION_CACHE_STATUS_OBSOLETE
} SEApplicationCacheStatus;

typedef enum seleniumMouseButtonTypes
{
	SELENIUM_MOUSE_LEFT_BUTTON = 0,
	SELENIUM_MOUSE_MIDDLE_BUTTON = 1,
	SELENIUM_MOUSE_RIGHT_BUTTON = 2
} SEMouseButton;

+(NSString*) stringForTimeoutType:(SETimeoutType)type;
+(SEApplicationCacheStatus) applicationCacheStatusWithInt:(NSInteger)applicationCacheStatusInt;
+(NSInteger) intForMouseButton:(SEMouseButton)button;

@end
