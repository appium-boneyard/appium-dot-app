//
// Created by Mark Corbyn on 08/01/15.
// Copyright (c) 2015 Mark Corbyn. All rights reserved.
//

#import "SETouchActionCommand.h"

@interface SETouchActionCommand ()

@end

@implementation SETouchActionCommand {
}

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.options = [NSMutableDictionary dictionary];
    }
    return self;
}

-(instancetype) initWithName:(NSString *)name
{
    self = [self init];
    if (!self) return nil;

    self.name = name;

    return self;
}

-(void) addParameterWithKey:(NSString *)keyName value:(id)value
{
    self.options[keyName] = value;
}


@end