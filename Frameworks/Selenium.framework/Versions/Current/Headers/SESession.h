//
//  SESession.h
//  Selenium
//
//  Created by Dan Cuellar on 3/14/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SECapabilities.h"

@interface SESession : NSObject

@property SECapabilities *capabilities;
@property NSString *sessionId;

-(id) initWithDictionary:(NSDictionary*)dict;

@end
