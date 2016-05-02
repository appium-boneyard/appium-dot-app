//
//  SEBy.h
//  Selenium
//
//  Created by Dan Cuellar on 3/18/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEBy : NSObject

@property NSString *locationStrategy;
@property NSString *value;

-(id) initWithLocationStrategy:(NSString*)locationStrategy value:(NSString*)value;

+(SEBy*) className:(NSString*)className;
+(SEBy*) cssSelector:(NSString*)cssSelector;
+(SEBy*) idString:(NSString*)idString;
+(SEBy*) name:(NSString*)name;
+(SEBy*) linkText:(NSString*)linkText;
+(SEBy*) partialLinkText:(NSString*)partialLinkText;
+(SEBy*) tagName:(NSString*)tagName;
+(SEBy*) xPath:(NSString*)xPath;

+(SEBy*) accessibilityId:(NSString*)accessibilityId;
+(SEBy*) androidUIAutomator:(NSString*)uiAutomatorExpression;
+(SEBy*) iOSUIAutomation:(NSString*)uiAutomationExpression;

@end
