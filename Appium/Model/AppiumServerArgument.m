//
//  AppiumServerArgument.m
//  Appium
//
//  Created by Jamie Edge on 09/08/2014.
//  Copyright (c) 2014 Appium. All rights reserved.
//

#import "AppiumServerArgument.h"

@implementation AppiumServerArgument

- (id)initWithName:(NSString *)name withValue:(NSString *)value
{
	self = [self init];
	
	if (self)
	{
		self.name  = name;
		self.value = value;
	}
	
	return self;
}

+ (AppiumServerArgument *)argumentWithName:(NSString *)name
{
	return [[AppiumServerArgument alloc] initWithName:name withValue:nil];
}

+ (AppiumServerArgument *)argumentWithName:(NSString *)name withValue:(NSString *)value
{
	return [[AppiumServerArgument alloc] initWithName:name withValue:value];
}

#pragma mark - Helpers

+ (NSString *)parseIntegerValue:(NSNumber *)number
{
	return [NSString stringWithFormat:@"%ld", (long)[number integerValue]];
}

@end
