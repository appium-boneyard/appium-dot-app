//
//  Enums.h
//  Selenium
//
//  Created by Dan Cuellar on 3/19/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Enums : NSObject

typedef enum screenOrientationTypes
{
	SCREEN_ORIENTATION_PORTRAIT,
	SCREEN_ORIENTATION_LANDSCAPE,
	SCREEN_ORIENTATION_NA
} ScreenOrientation;

typedef enum timeoutTypes
{
	TIMEOUT_IMPLICIT,
	TIMEOUT_SCRIPT,
	TIMEOUT_PAGELOAD
} TimeoutType;

@end
