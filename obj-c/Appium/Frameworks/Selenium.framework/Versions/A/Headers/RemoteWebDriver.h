//
//  Selenium.h
//  Selenium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Capabilities.h"

@interface RemoteWebDriver : NSObject

-(id) initWithServerAddress:(NSString*)address port:(NSInteger)port desiredCapabilities:(Capabilities*)desiredCapabilities requiredCapabilities:(Capabilities*)requiredCapabilites error:(NSError**)error;

-(void) quit;
-(void) quitAndError:(NSError**)error;

-(NSString*) pageSource;
-(NSString*) pageSourceAndError:(NSError**)error;

@end
