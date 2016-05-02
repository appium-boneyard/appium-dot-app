//
//  SELocation.m
//  Selenium
//
//  Created by Khyati Dave on 3/25/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "SELocation.h"

@implementation SELocation

-(id) initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        NSDictionary *value = [dict objectForKey:@"value"];
      
        [self setLatitude:[[value objectForKey:@"latitude"] floatValue]];
        [self setLongitude:[[value objectForKey:@"longitude"] floatValue]];
        [self setAltitude:[[value objectForKey:@"altitude"] floatValue]];
    }
    return self;
}

@end
