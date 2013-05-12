//
//  Capabilities.h
//  Selenium
//
//  Created by Dan Cuellar on 3/14/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Capabilities : NSObject

@property NSString* browserName;
@property NSString* version;
@property NSString* platform;
@property BOOL javascriptEnabled;
@property BOOL takesScreenShot;
@property BOOL handlesAlerts;
@property BOOL databaseEnabled;
@property BOOL locationContextEnabled;
@property BOOL applicationCacheEnabled;
@property BOOL browserConnectionEnabled;
@property BOOL cssSelectorsEnabled;
@property BOOL webStorageEnabled;
@property BOOL rotatable;
@property BOOL acceptSslCerts;
@property BOOL nativeEvents;
// TODO: add proxy object

-(id)initWithDictionary:(NSDictionary*)dict;
-(id) getCapabilityForKey:(NSString*)key;
-(void) addCapabilityForKey:(NSString*)key andValue:(id)value;
-(NSDictionary*) dictionary;

@end
