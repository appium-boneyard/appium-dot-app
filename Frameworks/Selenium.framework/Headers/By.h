//
//  By.h
//  Selenium
//
//  Created by Dan Cuellar on 3/18/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface By : NSObject

@property NSString *locationStrategy;
@property NSString *value;

-(id) initWithLocationStrategy:(NSString*)locationStrategy value:(NSString*)value;

+(By*) className:(NSString*)className;
+(By*) cssSelector:(NSString*)cssSelector;
+(By*) idString:(NSString*)idString;
+(By*) name:(NSString*)name;
+(By*) linkText:(NSString*)linkText;
+(By*) partialLinkText:(NSString*)partialLinkText;
+(By*) tagName:(NSString*)tagName;
+(By*) xPath:(NSString*)xPath;

@end
