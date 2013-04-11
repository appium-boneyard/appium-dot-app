//
//  AppiumCodeMaker.h
//  Appium
//
//  Created by Dan Cuellar on 4/8/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppiumCodeMakerAction.h"

@protocol AppiumCodeMakerPlugin

@property (readonly) NSString *preCodeBoilerplate;
@property (readonly) NSString *postCodeBoilerplate;

-(NSString*) renderAction:(AppiumCodeMakerAction*)action;

@end
