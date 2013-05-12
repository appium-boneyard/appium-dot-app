//
//  AppiumCodeMakerActionExecuteScript.h
//  Appium
//
//  Created by Dan Cuellar on 5/5/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerAction.h"

@interface AppiumCodeMakerActionExecuteScript : AppiumCodeMakerAction

-(id) initWithScript:(NSString*)script;

@property (readonly) NSString* script;

@end
