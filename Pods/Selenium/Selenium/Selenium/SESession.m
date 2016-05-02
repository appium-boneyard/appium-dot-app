//
//  SESession.m
//  Selenium
//
//  Created by Dan Cuellar on 3/14/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "SESession.h"

@implementation SESession

-(id) initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
		if ([dict objectForKey:@"sessionId"] != nil)
		{
			[self setCapabilities:[[SECapabilities alloc] initWithDictionary:[dict objectForKey:@"value"]]];
			[self setSessionId:[dict objectForKey:@"sessionId"]];
		}
		else
		{
			[self setCapabilities:[[SECapabilities alloc] initWithDictionary:[dict objectForKey:@"capabilities"]]];
			[self setSessionId:[dict objectForKey:@"id"]];
		}
    }
    return self;
}

@end
