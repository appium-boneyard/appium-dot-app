//
//  AppiumCodeMaker.h
//  Appium
//
//  Created by Dan Cuellar on 4/8/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppiumCodeMaker.h"
#import "AppiumCodeMakerAction.h"
#import "AppiumCodeMakerLocator.h"

@class AppiumCodeMaker;

@protocol AppiumCodeMakerPlugin

@property (readonly) NSString *name;
@property (readonly) NSString *preCodeBoilerplate;
@property (readonly) NSString *postCodeBoilerplate;
@property (weak) AppiumCodeMaker *codeMaker;

-(id) initWithCodeMaker:(AppiumCodeMaker*)codeMaker;
-(NSString*) renderAction:(AppiumCodeMakerAction*)action;

@end
