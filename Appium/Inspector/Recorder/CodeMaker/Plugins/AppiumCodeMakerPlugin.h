//
//  AppiumCodeMaker.h
//  Appium
//
//  Created by Dan Cuellar on 4/8/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerActions.h"
#import "AppiumModel.h"

#define APPIUM_CODE_MAKER_PLUGIN_METHOD_NYI_STRING @"Action cannot currently be transcribed by Appium Recorder"

@class AppiumCodeMaker;
@class AppiumModel;

@interface AppiumCodeMakerPlugin : NSObject

@property (readonly) AppiumModel *model;
@property (readonly) NSString *name;
@property (readonly) NSString *fileExtension;
@property (readonly) NSString *preCodeBoilerplate;
@property (readonly) NSString *preCodeBoilerplateAndroid;
@property (readonly) NSString *preCodeBoilerplateiOS;
@property (readonly) NSString *postCodeBoilerplate;
@property (weak) AppiumCodeMaker *codeMaker;

-(id) initWithCodeMaker:(AppiumCodeMaker *)codeMaker;

-(NSString*) renderAction:(AppiumCodeMakerAction*)action;
-(NSString*) acceptAlert;
-(NSString*) comment:(AppiumCodeMakerActionComment*)action;
-(NSString*) commentWithString:(NSString *)comment;
-(NSString*) dismissAlert;
-(NSString*) executeScript:(AppiumCodeMakerActionExecuteScript*)action;
-(NSString*) preciseTap:(AppiumCodeMakerActionPreciseTap*)action;
-(NSString*) sendKeys:(AppiumCodeMakerActionSendKeys*)action;
- (NSString *)scrollTo:(AppiumCodeMakerActionScrollTo *)action;
-(NSString*) shake:(AppiumCodeMakerActionShake*)action;
-(NSString*) swipe:(AppiumCodeMakerActionSwipe*)action;
-(NSString*) tap:(AppiumCodeMakerActionTap*)action;

@end
