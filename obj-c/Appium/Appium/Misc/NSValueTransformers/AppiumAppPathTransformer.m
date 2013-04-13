//
//  AppiumAppPathTransformer.m
//  Appium
//
//  Created by Dan Cuellar on 3/6/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumAppPathTransformer.h"

@implementation AppiumAppPathTransformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    return [[NSURL alloc] initFileURLWithPath:value];
}
@end
