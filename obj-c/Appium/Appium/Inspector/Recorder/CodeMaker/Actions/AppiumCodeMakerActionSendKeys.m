//
//  AppiumCodeMakerSendKeysAction.m
//  Appium
//
//  Created by Dan Cuellar on 4/14/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerActionSendKeys.h"


@implementation AppiumCodeMakerActionSendKeys

-(id) initWithLocator:(AppiumCodeMakerLocator*)locator keys:(NSString*)keys
{
    self = [super init];
    if (self)
	{
		self.actionType = APPIUM_CODE_MAKER_ACTION_SEND_KEYS;
		[self.params setObject:locator forKey:@"locator"];
		[self.params setObject:keys forKey:@"keys"];
	}
    return self;
}

-(AppiumCodeMakerActionBlock) block
{
    return ^(SERemoteWebDriver* driver){
        SEWebElement *element = [driver findElementBy:[self.locator by]];
        [element sendKeys:self.keys];
    };
}

-(AppiumCodeMakerLocator*) locator { return [self.params objectForKey:@"locator"]; }
-(NSString*) keys { return [self.params objectForKey:@"keys"]; }

@end
