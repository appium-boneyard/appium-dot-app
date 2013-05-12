//
//  Selenium.h
//  Selenium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Capabilities.h"
#import "By.h"
#import "WebElement.h"
#import "RemoteWebDriverSession.h"
#import "SeleniumEnums.h"

@class Capabilities;
@class By;
@class WebElement;
@class RemoteWebDriverSession;

@interface RemoteWebDriver : NSObject

@property RemoteWebDriverSession *session;

-(id) initWithServerAddress:(NSString*)address port:(NSInteger)port desiredCapabilities:(Capabilities*)desiredCapabilities requiredCapabilities:(Capabilities*)requiredCapabilites error:(NSError**)error;

-(void) quit;
-(void) quitAndError:(NSError**)error;
-(void) setTimeout:(NSInteger)timeoutInMilliseconds forType:(TimeoutType)type;
-(void) setTimeout:(NSInteger)timeoutInMilliseconds forType:(TimeoutType)type error:(NSError**)error;
-(void) setAsyncScriptTimeout:(NSInteger)timeoutInMilliseconds;
-(void) setAsyncScriptTimeout:(NSInteger)timeoutInMilliseconds error:(NSError**)error;
-(void) setImplicitWaitTimeout:(NSInteger)timeoutInMilliseconds;
-(void) setImplicitWaitTimeout:(NSInteger)timeoutInMilliseconds error:(NSError**)error;
-(NSString*) windowHandle;
-(NSString*) windowHandleAndReturnError:(NSError**)error;
-(NSArray*) windowHandles;
-(NSArray*) windowHandlesAndReturnError:(NSError**)error;

-(NSURL*) url;
-(NSURL*) urlAndReturnError:(NSError**)error;
-(void) setUrl:(NSURL*)url;
-(void) setUrl:(NSURL*)url error:(NSError**)error;
-(void) forward;
-(void) forwardAndReturnError:(NSError**)error;
-(void) back;
-(void) backAndReturnError:(NSError**)error;
-(void) refresh;
-(void) refreshAndReturnError:(NSError**)error;

-(NSString*) pageSource;
-(NSString*) pageSourceAndReturnError:(NSError**)error;
-(NSString*) title;
-(NSString*) titleAndReturnError:(NSError **)error;
-(WebElement*) findElementBy:(By*)by;
-(WebElement*) findElementBy:(By*)by error:(NSError**)error;
-(NSArray*) findElementsBy:(By*)by;
-(NSArray*) findElementsBy:(By*)by error:(NSError**)error;
-(WebElement*) activeElement;
-(WebElement*) activeElementAndReturnError:(NSError**)error;
-(ScreenOrientation) orientation;
-(ScreenOrientation) orientationAndReturnError:(NSError**)error;
-(void) setOrientation:(ScreenOrientation)orientation;
-(void) setOrientation:(ScreenOrientation)orientation error:(NSError**)error;
-(NSString*)alertText;
-(NSString*)alertTextAndReturnError:(NSError **)error;
-(void) setAlertText:(NSString*)text;
-(void) setAlertText:(NSString*)text error:(NSError**)error;
-(void) acceptAlert;
-(void) acceptAlertAndReturnError:(NSError**)error;
-(void) dismissAlert;
-(void) dismissAlertAndReturnError:(NSError**)error;

@end
