//
//  AppiumServerArgument.h
//  Appium
//
//  Created by Jamie Edge on 09/08/2014.
//  Copyright (c) 2014 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppiumServerArgument : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *value;

- (id)initWithName:(NSString *)name withValue:(NSString *)value;
+ (AppiumServerArgument *)argumentWithName:(NSString *)name;
+ (AppiumServerArgument *)argumentWithName:(NSString *)name withValue:(NSString *)value;
+ (NSString *)parseIntegerValue:(NSNumber *)number;

@end
