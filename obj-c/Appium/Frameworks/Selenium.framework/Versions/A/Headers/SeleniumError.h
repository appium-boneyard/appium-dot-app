//
//  SeleniumError.h
//  Selenium
//
//  Created by Dan Cuellar on 3/16/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeleniumError : NSError

+(SeleniumError*) errorWithCode:(NSInteger)code;
+(SeleniumError*) errorWithResponseDict:(NSDictionary*)dict;

+(SeleniumError*) success;
+(SeleniumError*) noSuchDriver;
+(SeleniumError*) noSuchElement;
+(SeleniumError*) noSuchFrame;
+(SeleniumError*) unknownCommand;
+(SeleniumError*) staleElementReference;
+(SeleniumError*) elementNotVisible;
+(SeleniumError*) invalidElementState;
+(SeleniumError*) unknownError;
+(SeleniumError*) elementIsNotSelectable;
+(SeleniumError*) javaScriptError;
+(SeleniumError*) xpathLookupError;
+(SeleniumError*) timeout;
+(SeleniumError*) noSuchWindow;
+(SeleniumError*) invalidCookieDomain;
+(SeleniumError*) unableToSetCookie;
+(SeleniumError*) unexpectedAlertOpen;
+(SeleniumError*) noAlertOpenError;
+(SeleniumError*) scriptTimeout;
+(SeleniumError*) invalidElementCoordinates;
+(SeleniumError*) imeNotAvailable;
+(SeleniumError*) imeEngineActivationFailed;
+(SeleniumError*) invalidSelector;
+(SeleniumError*) sessionNotCreatedException;
+(SeleniumError*) moveTargetOutOfBounds;

@end
