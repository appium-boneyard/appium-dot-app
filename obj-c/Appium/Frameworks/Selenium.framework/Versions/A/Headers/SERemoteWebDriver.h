//
//  Selenium.h
//  Selenium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SECapabilities.h"
#import "SEBy.h"
#import "SEWebElement.h"
#import "SESession.h"
#import "SEEnums.h"

@class SECapabilities;
@class SEBy;
@class SEWebElement;
@class SESession;

@interface SERemoteWebDriver : NSObject

@property SESession *session;
@property NSError *lastError;
@property NSMutableArray *errors;

-(id) initWithServerAddress:(NSString*)address port:(NSInteger)port desiredCapabilities:(SECapabilities*)desiredCapabilities requiredCapabilities:(SECapabilities*)requiredCapabilites error:(NSError**)error;

-(void) quit;
-(void) setTimeout:(NSInteger)timeoutInMilliseconds forType:(SETimeoutType)type;
-(void) setAsyncScriptTimeout:(NSInteger)timeoutInMilliseconds;
-(void) setImplicitWaitTimeout:(NSInteger)timeoutInMilliseconds;
-(NSString*) window;
-(NSArray*) allWindows;
-(NSURL*) url;
-(void) setUrl:(NSURL*)url;
-(void) forward;
-(void) back;
-(void) refresh;
-(NSDictionary*) executeScript:(NSString*)script;
-(NSDictionary*) executeScript:(NSString*)script arguments:(NSArray*)arguments;
-(NSDictionary*) executeAnsynchronousScript:(NSString*)script;
-(NSDictionary*) executeAnsynchronousScript:(NSString*)script arguments:(NSArray*)arguments;
-(NSImage*) screenshot;
-(NSArray*) availableInputMethodEngines;
-(NSString*) activeInputMethodEngine;
-(BOOL) inputMethodEngineIsActive;
-(void) deactivateInputMethodEngine;
-(void) activateInputMethodEngine:(NSString*)engine;
-(void) setFrame:(id)name;
-(void) setWindow:(NSString*)windowHandle;
-(void) closeWindow:(NSString*)windowHandle;
-(void) setWindowSize:(NSSize)size window:(NSString*)windowHandle;
-(NSSize) windowSizeForWindow:(NSString*)windowHandle;
-(void) setWindowPosition:(NSPoint)position window:(NSString*)windowHandle;
-(NSPoint) windowPositionForWindow:(NSString*)windowHandle;
-(void) maximizeWindow:(NSString*)windowHandle;
-(NSArray*) cookies;
-(void) setCookie:(NSHTTPCookie*)cookie;
-(void) deleteCookies;
-(void) deleteCookie:(NSString*)cookieName;
-(NSString*) pageSource;
-(NSString*) title;
-(SEWebElement*) findElementBy:(SEBy*)by;
-(NSArray*) findElementsBy:(SEBy*)by;
-(SEWebElement*) activeElement;
-(void) sendKeys:(NSString*)keyString;
-(SEScreenOrientation) orientation;
-(void) setOrientation:(SEScreenOrientation)orientation;
-(NSString*)alertText;
-(void) setAlertText:(NSString*)text;
-(void) acceptAlert;
-(void) dismissAlert;
-(void) moveMouseWithXOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset;
-(void) moveMouseToElement:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset;
-(void) click;
-(void) clickMouseButton:(SEMouseButton)button;
-(void) mouseButtonDown:(SEMouseButton)button;
-(void) mouseButtonUp:(SEMouseButton)button;
-(void) doubleclick;
-(void) tapElement:(SEWebElement*)element;
-(void) fingerDownAt:(NSPoint)point;
-(void) fingerUpAt:(NSPoint)point;
-(void) moveFingerTo:(NSPoint)point;
-(void) doubletapElement:(SEWebElement*)element;
-(void) pressElement:(SEWebElement*)element;

-(SEApplicationCacheStatus) applicationCacheStatus;

@end
