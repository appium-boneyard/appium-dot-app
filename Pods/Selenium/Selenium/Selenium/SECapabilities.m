//
//  SECapabilities.m
//  Selenium
//
//  Created by Dan Cuellar on 3/14/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#define BROWSER_NAME @"browserName"
#define VERSION @"version"
#define PLATFORM @"platform"
#define JAVASCRIPT_ENABLED @"javascriptEnabled"
#define TAKES_SCREENSHOT @"takesScreenshot"
#define HANDLES_ALERTS @"handlesAlerts"
#define DATABASE_ENABLED @"databaseEnabled"
#define LOCATION_CONTEXT_ENABLED @"locationContextEnabled"
#define APPLICATION_CACHE_ENABLED @"applicationCacheEnabled"
#define BROWSER_CONNECTION_ENABLED @"browserConnectionEnabled"
#define CSS_SELECTORS_ENABLED @"cssSelectorsEnabled"
#define WEB_STORAGE_ENABLED @"webStorageEnabled"
#define ROTATABLE @"rotatable"
#define ACCEPT_SSL_CERTS @"acceptSslCerts"
#define NATIVE_EVENTS @"nativeEvents"
#define PROXY @"proxy"

#define APP @"app"
#define AUTOMATION_NAME @"automationName"
#define DEVICE_NAME @"deviceName"
#define PLATFORM_NAME @"platformName"
#define PLATFORM_VERSION @"platformVersion"

#import "SECapabilities.h"

@interface SECapabilities() {
    @private
    NSMutableDictionary* _dict;
}
@end

@implementation SECapabilities

#pragma mark - Constructors

-(id) init
{
    self = [super init];
    if (self) {
        _dict = [NSMutableDictionary new];
    }
    return self;
}

-(id) initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
		_dict = [NSMutableDictionary new];
		if ([dict objectForKey:BROWSER_NAME]) {
            [self setBrowserName:[dict objectForKey:BROWSER_NAME]];
        }
        
        if ([dict objectForKey:VERSION]) {
            [self setVersion:[dict objectForKey:VERSION]];
        }

        if ([dict objectForKey:PLATFORM]) {
            [self setPlatform:[dict objectForKey:PLATFORM]];
        }
        
        if ([dict objectForKey:JAVASCRIPT_ENABLED]) {
            [self setJavascriptEnabled:[[dict objectForKey:JAVASCRIPT_ENABLED] boolValue]];
        }
        
        if ([dict objectForKey:TAKES_SCREENSHOT]) {
            [self setTakesScreenShot:[[dict objectForKey:TAKES_SCREENSHOT] boolValue]];
        }
        
        if ([dict objectForKey:HANDLES_ALERTS]) {
            [self setHandlesAlerts:[[dict objectForKey:HANDLES_ALERTS] boolValue]];
        }
        
        if ([dict objectForKey:DATABASE_ENABLED]) {
            [self setDatabaseEnabled:[[dict objectForKey:DATABASE_ENABLED] boolValue]];
        }
        
        if ([dict objectForKey:LOCATION_CONTEXT_ENABLED]) {
            [self setLocationContextEnabled:[[dict objectForKey:LOCATION_CONTEXT_ENABLED] boolValue]];
        }
        
        if ([dict objectForKey:APPLICATION_CACHE_ENABLED]) {
            [self setApplicationCacheEnabled:[[dict objectForKey:APPLICATION_CACHE_ENABLED] boolValue]];
        }
        
        if ([dict objectForKey:BROWSER_CONNECTION_ENABLED]) {
            [self setBrowserConnectionEnabled:[[dict objectForKey:BROWSER_CONNECTION_ENABLED] boolValue]];
        }
    
        if ([dict objectForKey:CSS_SELECTORS_ENABLED]) {
            [self setCssSelectorsEnabled:[[dict objectForKey:CSS_SELECTORS_ENABLED] boolValue]];
        }
        
        if ([dict objectForKey:WEB_STORAGE_ENABLED]) {
            [self setWebStorageEnabled:[[dict objectForKey:WEB_STORAGE_ENABLED] boolValue]];
        }
		
        if ([dict objectForKey:APP]) {
            [self setApp:[dict objectForKey:APP]];
        }
        if ([dict objectForKey:AUTOMATION_NAME]) {
            [self setAutomationName:[dict objectForKey:AUTOMATION_NAME]];
        }
        if ([dict objectForKey:DEVICE_NAME]) {
            [self setDeviceName:[dict objectForKey:DEVICE_NAME]];
        }
        if ([dict objectForKey:PLATFORM_NAME]) {
            [self setPlatformName:[dict objectForKey:PLATFORM_NAME]];
        }
        if ([dict objectForKey:PLATFORM_VERSION]) {
            [self setPlatformVersion:[dict objectForKey:PLATFORM_VERSION]];
        }
    }
    return self;
}

#pragma mark - Built-in Capabilities

-(NSString*) browserName { return [_dict objectForKey:BROWSER_NAME];}
-(void) setBrowserName:(NSString *)browserName { [_dict setValue:browserName forKey:BROWSER_NAME]; }

-(NSString*) version { return [_dict objectForKey:VERSION];}
-(void) setVersion:(NSString *)version { [_dict setValue:version forKey:VERSION]; }

-(NSString*) platform { return [_dict objectForKey:PLATFORM];}
-(void) setPlatform:(NSString *)platform { [_dict setValue:platform forKey:PLATFORM]; }

-(BOOL) javascriptEnabled { return [[_dict objectForKey:JAVASCRIPT_ENABLED] boolValue]; }
-(void) setJavascriptEnabled:(BOOL)javascriptEnabled { [_dict setValue:[NSNumber numberWithBool:javascriptEnabled] forKey:JAVASCRIPT_ENABLED]; }

-(BOOL) takesScreenShot { return [[_dict objectForKey:TAKES_SCREENSHOT] boolValue]; }
-(void) setTakesScreenShot:(BOOL)takesScreenShot { [_dict setValue:[NSNumber numberWithBool:takesScreenShot] forKey:TAKES_SCREENSHOT]; }

-(BOOL) handlesAlerts { return [[_dict objectForKey:HANDLES_ALERTS] boolValue]; }
-(void) setHandlesAlerts:(BOOL)handlesAlerts { [_dict setValue:[NSNumber numberWithBool:handlesAlerts] forKey:HANDLES_ALERTS]; }

-(BOOL) databaseEnabled { return [[_dict objectForKey:DATABASE_ENABLED] boolValue]; }
-(void) setDatabaseEnabled:(BOOL)databaseEnabled { [_dict setValue:[NSNumber numberWithBool:databaseEnabled] forKey:DATABASE_ENABLED]; }

-(BOOL) locationContextEnabled { return [[_dict objectForKey:LOCATION_CONTEXT_ENABLED] boolValue]; }
-(void) setLocationContextEnabled:(BOOL)locationContextEnabled { [_dict setValue:[NSNumber numberWithBool:locationContextEnabled] forKey:LOCATION_CONTEXT_ENABLED];}

-(BOOL) applicationCacheEnabled { return [[_dict objectForKey:APPLICATION_CACHE_ENABLED] boolValue]; }
-(void) setApplicationCacheEnabled:(BOOL)applicationCacheEnabled { [_dict setValue:[NSNumber numberWithBool:applicationCacheEnabled] forKey:APPLICATION_CACHE_ENABLED]; }

-(BOOL) browserConnectionEnabled { return [[_dict objectForKey:BROWSER_CONNECTION_ENABLED] boolValue]; }
-(void) setBrowserConnectionEnabled:(BOOL)browserConnectionEnabled { [_dict setValue:[NSNumber numberWithBool:browserConnectionEnabled] forKey:BROWSER_CONNECTION_ENABLED]; }

-(BOOL) cssSelectorsEnabled { return [[_dict objectForKey:CSS_SELECTORS_ENABLED] boolValue]; }
-(void) setCssSelectorsEnabled:(BOOL)cssSelectorsEnabled { [_dict setValue:[NSNumber numberWithBool:cssSelectorsEnabled] forKey:CSS_SELECTORS_ENABLED]; }

-(BOOL) webStorageEnabled { return [[_dict objectForKey:WEB_STORAGE_ENABLED] boolValue]; }
-(void) setWebStorageEnabled:(BOOL)webStorageEnabled { [_dict setValue:[NSNumber numberWithBool:webStorageEnabled] forKey:WEB_STORAGE_ENABLED]; }

-(BOOL) rotatable { return [[_dict objectForKey:ROTATABLE] boolValue]; }
-(void) setRotatable:(BOOL)rotatable { [_dict setValue:[NSNumber numberWithBool:rotatable] forKey:ROTATABLE]; }

-(BOOL) acceptSslCerts { return [[_dict objectForKey:ACCEPT_SSL_CERTS] boolValue]; }
-(void) setAcceptSslCerts:(BOOL)acceptSslCerts { [_dict setValue:[NSNumber numberWithBool:acceptSslCerts] forKey:ACCEPT_SSL_CERTS]; }

-(BOOL) nativeEvents { return [[_dict objectForKey:NATIVE_EVENTS] boolValue]; }
-(void) setNativeEvents:(BOOL)nativeEvents { [_dict setValue:[NSNumber numberWithBool:nativeEvents] forKey:NATIVE_EVENTS]; }

#pragma mark - Appium Capabilities

- (NSString *)app { return [_dict objectForKey:APP]; }
- (void)setApp:(NSString *)app { [_dict setObject:app forKey:APP]; }

- (NSString *)automationName { return [_dict objectForKey:AUTOMATION_NAME]; }
- (void)setAutomationName:(NSString *)automationName { [_dict setObject:automationName forKey:AUTOMATION_NAME]; }

- (NSString *)deviceName { return [_dict objectForKey:DEVICE_NAME]; }
- (void)setDeviceName:(NSString *)deviceName { [_dict setObject:deviceName forKey:DEVICE_NAME]; }

- (NSString *)platformName { return [_dict objectForKey:PLATFORM_NAME]; }
- (void)setPlatformName:(NSString *)platformName { [_dict setObject:platformName forKey:PLATFORM_NAME]; }

- (NSString *)platformVersion { return [_dict objectForKey:PLATFORM_VERSION]; }
- (void)setPlatformVersion:(NSString *)platformVersion { [_dict setObject:platformVersion forKey:PLATFORM_VERSION]; }

#pragma mark - Custom Capabilities

-(id) getCapabilityForKey:(NSString*)key { return [_dict valueForKey:key]; }
-(void) addCapabilityForKey:(NSString*)key andValue:(id)value { [_dict setValue:value forKey:key]; }
-(NSDictionary*) dictionary { return _dict; }

@end
