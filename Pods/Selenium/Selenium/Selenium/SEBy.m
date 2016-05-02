//
//  SEBy.m
//  Selenium
//
//  Created by Dan Cuellar on 3/18/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "SEBy.h"

@implementation SEBy

-(id) initWithLocationStrategy:(NSString*)locationStrategy value:(NSString*)value
{
    self = [super init];
    if (self) {
        [self setLocationStrategy:locationStrategy];
		[self setValue:value];
    }
    return self;
}

+(SEBy*) className:(NSString*)className
{
	return [[SEBy alloc] initWithLocationStrategy:@"class name" value:className];
}

+(SEBy*) cssSelector:(NSString*)cssSelector
{
	return [[SEBy alloc] initWithLocationStrategy:@"css selector" value:cssSelector];
}

+(SEBy*) idString:(NSString*)idString
{
	return [[SEBy alloc] initWithLocationStrategy:@"id" value:idString];
}

+(SEBy*) name:(NSString*)name
{
	return [[SEBy alloc] initWithLocationStrategy:@"name" value:name];
}

+(SEBy*) linkText:(NSString*)linkText
{
	return [[SEBy alloc] initWithLocationStrategy:@"link text" value:linkText];
}

+(SEBy*) partialLinkText:(NSString*)partialLinkText
{
	return [[SEBy alloc] initWithLocationStrategy:@"partial link text" value:partialLinkText];
}

+(SEBy*) tagName:(NSString*)tagName
{
	return [[SEBy alloc] initWithLocationStrategy:@"tag name" value:tagName];
}

+(SEBy*) xPath:(NSString*)xPath
{
	return [[SEBy alloc] initWithLocationStrategy:@"xpath" value:xPath];
}

+(SEBy*) accessibilityId:(NSString*)accessibilityId
{
	return [[SEBy alloc] initWithLocationStrategy:@"accessibility id" value:accessibilityId];
}

+(SEBy*) androidUIAutomator:(NSString*)uiAutomatorExpression
{
	return [[SEBy alloc] initWithLocationStrategy:@"-android uiautomator" value:uiAutomatorExpression];
}


+(SEBy*) iOSUIAutomation:(NSString*)uiAutomationExpression
{
	return [[SEBy alloc] initWithLocationStrategy:@"-ios uiautomation" value:uiAutomationExpression];
}

@end
