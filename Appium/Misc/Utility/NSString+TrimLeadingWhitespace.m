//
//  NSString+RemoveLeadingWhitespace.m
//  Appium
//
//  Created by Dan Cuellar on 7/27/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "NSString+TrimLeadingWhitespace.h"

@implementation NSString (trimLeadingWhitespace)
-(NSString*)stringByTrimmingLeadingWhitespace {
    NSInteger i = 0;

    while ((i < [self length])
           && [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[self characterAtIndex:i]]) {
        i++;
    }
    return [self substringFromIndex:i];
}
@end