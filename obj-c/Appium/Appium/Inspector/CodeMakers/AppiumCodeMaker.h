//
//  AppiumCodeMaker.h
//  Appium
//
//  Created by Dan Cuellar on 4/8/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AppiumCodeMaker

@property (readonly) NSString *preCodeBoilerplate;
@property (readonly) NSString *postCodeBoilerplate;
@property (readonly) NSString *sendKeys;
@property (readonly) NSString *tap;

-(NSString*) escapeString:(NSString*)string;

@end
