//
//  RemoteWebDriverSession.h
//  Selenium
//
//  Created by Dan Cuellar on 3/14/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Capabilities.h"

@interface RemoteWebDriverSession : NSObject

@property Capabilities *capabilities;
@property NSString *sessionID;

-(id)initWithDictionary:(NSDictionary*)dict;

@end
