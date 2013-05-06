//
//  AppiumCodeMakerActionExecuteScript.m
//  Appium
//
//  Created by Dan Cuellar on 5/5/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerActionExecuteScript.h"

@implementation AppiumCodeMakerActionExecuteScript

-(id) initWithScript:(NSString*)script
{
    self = [super init];
    if (self)
	{
		self.actionType = APPIUM_CODE_MAKER_ACTION_EXECUTE_SCRIPT;
		[self.params setObject:script forKey:@"script"];
	}
    return self;
}

-(AppiumCodeMakerActionBlock) block
{
    return ^(SERemoteWebDriver* driver){
        [driver executeScript:self.script];
    };
}

-(NSString*) script { return [self.params objectForKey:@"script"]; }

@end
