//
//  AppiumCodeMakerJavaPlugin.h
//  Appium
//
//  Created by Dan Cuellar on 4/11/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppiumCodeMaker.h"

@class AppiumCodeMaker;

@interface AppiumCodeMakerJavaPlugin : AppiumCodeMakerPlugin<AppiumCodeMakerPlugin>

@property (weak) AppiumCodeMaker *codeMaker;

@end
