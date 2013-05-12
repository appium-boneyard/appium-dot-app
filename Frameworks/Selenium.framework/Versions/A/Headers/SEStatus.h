//
//  SEStatus.h
//  Selenium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEStatus : NSObject

@property NSString *buildVersion;
@property NSString *buildRevision;
@property NSString *buildTime;
@property NSString *osArchitecture;
@property NSString *osName;
@property NSString *osVersion;

-(id) initWithDictionary:(NSDictionary*)dict;

@end