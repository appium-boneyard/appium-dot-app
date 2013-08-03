//
//  AppiumCodeMakerAction.m
//  Appium
//
//  Created by Dan Cuellar on 4/10/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerAction.h"

@interface AppiumCodeMakerAction ()

@property (readwrite) NSMutableDictionary *params;

@end

@implementation AppiumCodeMakerAction

-(id) init
{
    self = [super init];
    if (self)
	{
        self.params = [NSMutableDictionary new];
	}
    return self;
}

-(AppiumCodeMakerActionBlock) block { return nil; }

#pragma mark - NSCoding Implementation
-(id) initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.actionType = [aDecoder decodeIntForKey:@"actionType"];
        self.params = [aDecoder decodeObjectForKey:@"params"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.actionType forKey:@"actionType"];
    [aCoder encodeObject:self.params forKey:@"params"];
}

#pragma mark - NSCopying Implementation
-(id) copyWithZone:(NSZone *)zone
{
	AppiumCodeMakerAction *another = [[AppiumCodeMakerAction alloc] init];
	[another setActionType:self.actionType];
	[another setParams:[self.params copyWithZone:zone]];


	return another;
}

@end
