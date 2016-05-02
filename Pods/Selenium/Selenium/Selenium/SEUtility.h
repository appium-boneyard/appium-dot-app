//
//  SEUtility.h
//  Selenium
//
//  Created by Dan Cuellar on 3/18/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEUtility : NSObject

+(NSDictionary*) performGetRequestToUrl:(NSString*)urlString error:(NSError**)error;
+(NSDictionary*) performPostRequestToUrl:(NSString*)urlString postParams:(NSDictionary*)postParams error:(NSError**)error;
+(NSDictionary*) performDeleteRequestToUrl:(NSString*)urlString error:(NSError**)error;
+(NSHTTPCookie*) cookieWithJson:(NSDictionary*)json;

@end
