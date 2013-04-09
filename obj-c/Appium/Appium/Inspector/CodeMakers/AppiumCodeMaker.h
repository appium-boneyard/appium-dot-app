//
//  AppiumCodeMaker.h
//  Appium
//
//  Created by Dan Cuellar on 4/8/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Selenium/SEWebElement.h>
#import "WebDriverElementNode.h"

@class WebDriverElementNode;

@protocol AppiumCodeMaker

@property (readonly) NSString *preCodeBoilerplate;
@property (readonly) NSString *postCodeBoilerplate;

-(NSString*) sendKeys:(NSString*)keys element:(NSString*)xpath;
-(NSString* )tap:(NSString*)xpath;
-(NSString*) escapeString:(NSString*)string;

@end
