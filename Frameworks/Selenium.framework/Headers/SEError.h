//
//  SEError.h
//  Selenium
//
//  Created by Dan Cuellar on 3/16/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEError : NSError

+(SEError*) errorWithCode:(NSInteger)code;
+(SEError*) errorWithResponseDict:(NSDictionary*)dict;

+(SEError*) success;
+(SEError*) noSuchDriver;
+(SEError*) noSuchElement;
+(SEError*) noSuchFrame;
+(SEError*) unknownCommand;
+(SEError*) staleElementReference;
+(SEError*) elementNotVisible;
+(SEError*) invalidElementState;
+(SEError*) unknownError;
+(SEError*) elementIsNotSelectable;
+(SEError*) javaScriptError;
+(SEError*) xpathLookupError;
+(SEError*) timeout;
+(SEError*) noSuchWindow;
+(SEError*) invalidCookieDomain;
+(SEError*) unableToSetCookie;
+(SEError*) unexpectedAlertOpen;
+(SEError*) noAlertOpenError;
+(SEError*) scriptTimeout;
+(SEError*) invalidElementCoordinates;
+(SEError*) imeNotAvailable;
+(SEError*) imeEngineActivationFailed;
+(SEError*) invalidSelector;
+(SEError*) sessionNotCreatedException;
+(SEError*) moveTargetOutOfBounds;

@end
