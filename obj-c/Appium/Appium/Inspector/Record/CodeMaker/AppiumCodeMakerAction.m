//
//  AppiumCodeMakerAction.m
//  Appium
//
//  Created by Dan Cuellar on 4/10/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerAction.h"

@implementation AppiumCodeMakerAction

-(id) initWithActionType:(AppiumCodeMakerActionType)actionType params:(NSDictionary*)params
{
    self = [super init];
    if (self)
	{
		self.actionType = actionType;
        self.params = params;
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
	AppiumCodeMakerAction *another = [[AppiumCodeMakerAction alloc] initWithActionType:self.actionType params:[self.params copy]];
	return another;
}

@end
