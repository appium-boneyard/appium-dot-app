//
//  AppiumCodeMaker.h
//  Appium
//
//  Created by Dan Cuellar on 4/10/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppiumCodeMakerPlugin.h"

@interface AppiumCodeMaker : NSObject {
@private
	NSMutableArray *_actions;
	NSString *_renderedActions;
	id<AppiumCodeMakerPlugin> _plugin;
}

@property id<AppiumCodeMakerPlugin> plugin;
@property NSString *string;
@property NSAttributedString *attributedString;

-(void) addAction:(AppiumCodeMakerAction*)action;

@end
