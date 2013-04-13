//
//  AppiumCodeMakerAction.m
//  Appium
//
//  Created by Dan Cuellar on 4/10/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerAction.h"

@implementation AppiumCodeMakerAction

-(id) initWithActionType:(AppiumCodeMakerActionType)actionType params:(NSArray*)params
{
	self = [super init];
    if (self)
	{
		self.actionType = actionType;
		self.params = params;
	}
    return self;
}

@end
