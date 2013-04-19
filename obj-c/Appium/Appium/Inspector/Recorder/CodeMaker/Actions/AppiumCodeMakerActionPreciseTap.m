//
//  AppiumCodeMakerActionPreciseTap.m
//  Appium
//
//  Created by Dan Cuellar on 4/18/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerActionPreciseTap.h"

@implementation AppiumCodeMakerActionPreciseTap

-(id) initWithArguments:(NSArray*)arguments
{
    self = [super init];
    if (self)
	{
		self.actionType = APPIUM_CODE_MAKER_ACTION_PRECISE_TAP;
		[self.params setObject:arguments forKey:@"args"];
	}
    return self;
}

-(AppiumCodeMakerActionBlock) block
{
    return ^(SERemoteWebDriver* driver){
        [driver executeScript:@"mobile: tap" arguments:[self.params objectForKey:@"args"]];
    };
}

@end
