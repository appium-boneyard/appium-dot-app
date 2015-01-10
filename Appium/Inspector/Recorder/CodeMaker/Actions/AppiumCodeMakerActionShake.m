//
//  AppiumCodeMakerActionShake.m
//  Appium
//
//  Created by Dan Cuellar on 5/6/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerActionShake.h"

@implementation AppiumCodeMakerActionShake

-(id) init
{
    self = [super init];
    if (self)
	{
		self.actionType = APPIUM_CODE_MAKER_ACTION_SHAKE;
	}
    return self;
}

-(AppiumCodeMakerActionBlock) block
{
    return ^(SERemoteWebDriver* driver){
        [driver shakeDevice];
    };
}

@end
