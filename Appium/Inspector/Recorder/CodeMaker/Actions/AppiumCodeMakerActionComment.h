//
//  AppiumCodeMakerActionComment.h
//  Appium
//
//  Created by Dan Cuellar on 4/14/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerAction.h"

@class AppiumCodeMakerAction;

@interface AppiumCodeMakerActionComment : AppiumCodeMakerAction

@property (readonly) NSString *comment;

-(id) initWithComment:(NSString*)comment;

@end
