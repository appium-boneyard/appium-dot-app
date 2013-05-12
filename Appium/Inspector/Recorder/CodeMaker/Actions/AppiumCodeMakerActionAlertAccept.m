//
//  AppiumCodeMakerActionAlertAccept.m
//  Appium
//
//  Created by Dan Cuellar on 4/14/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerActionAlertAccept.h"

@implementation AppiumCodeMakerActionAlertAccept

-(id) init
{
    self = [super init];
    if (self)
	{
		self.actionType = APPIUM_CODE_MAKER_ACTION_ALERT_ACCEPT;
	}
    return self;
}

-(AppiumCodeMakerActionBlock) block
{
    return ^(SERemoteWebDriver* driver){
        [driver acceptAlert];
    };
}

@end
