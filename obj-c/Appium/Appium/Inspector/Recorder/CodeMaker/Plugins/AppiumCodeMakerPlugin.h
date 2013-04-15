//
//  AppiumCodeMaker.h
//  Appium
//
//  Created by Dan Cuellar on 4/8/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerActions.h"

#define APPIUM_CODE_MAKER_PLUGIN_METHOD_NYI_STRING @"Action cannot currently be transcribed by Appium Recorder"

@class AppiumCodeMaker;

@protocol AppiumCodeMakerPlugin

@property (readonly) NSString *name;
@property (readonly) NSString *preCodeBoilerplate;
@property (readonly) NSString *postCodeBoilerplate;
-(NSString*) renderAction:(AppiumCodeMakerAction*)action;

-(NSString*) acceptAlert;
-(NSString*) comment:(AppiumCodeMakerActionComment*)action;
-(NSString*) commentWithString:(NSString *)comment;
-(NSString*) dismissAlert;
-(NSString*) sendKeys:(AppiumCodeMakerActionSendKeys*)action;
-(NSString*) tap:(AppiumCodeMakerActionTap*)action;

@end

@interface AppiumCodeMakerPlugin : NSObject

@property (weak) AppiumCodeMaker *codeMaker;

-(id) initWithCodeMaker:(AppiumCodeMaker*)codeMaker;
+(NSString*) renderAction:(AppiumCodeMakerAction*)action withPlugin:(id<AppiumCodeMakerPlugin>)plugin;

@end
