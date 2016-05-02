//
// Created by Mark Corbyn on 08/01/15.
// Copyright (c) 2015 Mark Corbyn. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SETouchActionCommand : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableDictionary *options;

-(instancetype) initWithName:(NSString *)name;

-(void) addParameterWithKey:(NSString *)keyName value:(id)value;

@end