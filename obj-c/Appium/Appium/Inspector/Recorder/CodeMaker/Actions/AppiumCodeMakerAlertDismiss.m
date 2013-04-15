//
//  AppiumCodeMakerActionDismissAlert.m
//  Appium
//
//  Created by Dan Cuellar on 4/14/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerActionAlertDismiss.h"

@implementation AppiumCodeMakerActionAlertDismiss

-(id) init
{
    self = [super init];
    if (self)
	{
		self.actionType = APPIUM_CODE_MAKER_ACTION_ALERT_DISMISS;
	}
    return self;
}

-(AppiumCodeMakerActionBlock) block
{
    return ^(SERemoteWebDriver* driver){
        [driver dismissAlert];
    };
}

@end
