//
//  AppiumCodeMaker.h
//  Appium
//
//  Created by Dan Cuellar on 4/10/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <MGSFragaria/MGSFragaria.h>
#import <Selenium/SERemoteWebDriver.h>
#import "AppiumCodeMakerAction.h"
#import "AppiumCodeMakerPlugin.h"

@class AppiumCodeMakerAction;
@class AppiumCodeMakerPlugin;
@class SERemoteWebDriver;

@interface AppiumCodeMaker : NSObject<NSCoding> {
@private
	NSMutableArray *_actions;
	NSString *_renderedActions;
	AppiumCodeMakerPlugin *_activePlugin;
	NSDictionary *_plugins;
	IBOutlet NSView *_contentView;
	MGSFragaria *_fragaria;
}

@property AppiumCodeMakerPlugin *activePlugin;
@property (readonly) NSArray *allPlugins;
@property NSString *syntaxDefinition;
@property NSNumber *useBoilerPlate;
@property NSNumber *useXPathOnly;
@property NSString *string;
@property NSAttributedString *attributedString;

-(void) reset;
-(void) addAction:(AppiumCodeMakerAction*)action;
-(void) replay:(SERemoteWebDriver*)driver;

@end
