//
//  AppiumCodeMakerActionComment.m
//  Appium
//
//  Created by Dan Cuellar on 4/14/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerActionComment.h"

@implementation AppiumCodeMakerActionComment

-(id) initWithComment:(NSString*)comment
{
    self = [super init];
    if (self)
	{
		self.actionType = APPIUM_CODE_MAKER_ACTION_COMMENT;
		[self.params setObject:comment forKey:@"comment"];
	}
    return self;
}

-(AppiumCodeMakerActionBlock) block
{
    return ^(SERemoteWebDriver* driver){ };
}

-(NSString*) comment { return [self.params objectForKey:@"comment"]; }

@end
