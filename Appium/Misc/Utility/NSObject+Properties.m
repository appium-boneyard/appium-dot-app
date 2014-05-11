//
//  NSString+RemoveLeadingWhitespace.m
//  Appium
//
//  Created by Dan Cuellar on 7/27/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "NSObject+Properties.h"

@implementation NSObject (allpropertyNames)

- (NSArray *)allPropertyNames
{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
	
    NSMutableArray *rv = [NSMutableArray array];
	
    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [rv addObject:name];
    }
	
    free(properties);
	
    return rv;
}
@end