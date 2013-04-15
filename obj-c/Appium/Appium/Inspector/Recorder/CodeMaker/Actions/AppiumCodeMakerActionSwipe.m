//
//  AppiumCodeMakerActionSwipe.m
//  Appium
//
//  Created by Dan Cuellar on 4/14/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerActionSwipe.h"

@implementation AppiumCodeMakerActionSwipe

-(id) initWithArguments:(NSArray*)arguments
{
    self = [super init];
    if (self)
	{
		self.actionType = APPIUM_CODE_MAKER_ACTION_SWIPE;
		[self.params setObject:arguments forKey:@"args"];
	}
    return self;
}

-(AppiumCodeMakerActionBlock) block
{
    return ^(SERemoteWebDriver* driver){
        [driver executeScript:@"mobile: swipe" arguments:[self.params objectForKey:@"args"]];
    };
}

@end
