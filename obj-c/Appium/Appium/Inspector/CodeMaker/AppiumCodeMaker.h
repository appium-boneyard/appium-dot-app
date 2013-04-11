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
	id<AppiumCodeMakerPlugin> _activePlugin;
	NSDictionary *_plugins;
}

@property id<AppiumCodeMakerPlugin> activePlugin;
@property (readonly) NSArray *allPlugins;
@property NSString *selectedPluginString;
@property NSNumber *useBoilerPlate;
@property NSString *string;
@property NSAttributedString *attributedString;

-(void) addAction:(AppiumCodeMakerAction*)action;

@end
