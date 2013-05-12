//
//  AppiumInspectorRefreshButtonTextTransformer.m
//  Appium
//
//  Created by Dan Cuellar on 3/28/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumInspectorRefreshButtonTextTransformer.h"

@implementation AppiumInspectorRefreshButtonTextTransformer

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
    return ([value boolValue] ? @"" : @"Refresh");
}

@end
