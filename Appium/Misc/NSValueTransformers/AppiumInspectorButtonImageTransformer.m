//
//  AppiumInspectorButtonImageTransformer.m
//  Appium
//
//  Created by Jamie Edge on 27/07/2014.
//  Copyright (c) 2014 Appium. All rights reserved.
//

#import "AppiumInspectorButtonImageTransformer.h"

@implementation AppiumInspectorButtonImageTransformer

+ (Class)transformedValueClass
{
    return [NSNumber class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    return ([value boolValue] ? nil : [NSImage imageNamed:@"inspector"]);
}

@end
