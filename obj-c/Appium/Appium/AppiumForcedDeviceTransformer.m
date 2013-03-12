//
//  AppiumForcedDeviceTransformer.m
//  Appium
//
//  Created by Dan Cuellar on 3/12/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumForcedDeviceTransformer.h"

@implementation AppiumForcedDeviceTransformer

+ (Class)transformedValueClass
{
    return [NSNumber class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    return [[value stringValue] stringByReplacingOccurrencesOfString:@"," withString:@""];
}

-(id) reverseTransformedValue:(id)value
{
	return [NSNumber numberWithInt:[value intValue]];
}

@end
