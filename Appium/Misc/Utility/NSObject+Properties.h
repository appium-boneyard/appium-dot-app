//
//  NSObject+Properties.h
//  Appium
//
//  Created by Dan Cuellar on 5/11/14.
//  Copyright (c) 2014 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (allpropertyNames)
- (NSArray *)allPropertyNames;
@end
