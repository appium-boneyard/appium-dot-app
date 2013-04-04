//
//  SEJsonWireClient.h
//  Selenium
//
//  Created by Dan Cuellar on 3/19/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SESession.h"
#import "SECapabilities.h"
#import "SEWebElement.h"
#import "SEBy.h"
#import "SEEnums.h"
#import "SELocation.h"

@class SEBy;
@class SECapabilities;
@class SEStatus;
@class SESession;
@class SEWebElement;
@class SELocation;

@interface SEJsonWireClient : NSObject

-(id) initWithServerAddress:(NSString*)address port:(NSInteger)port desiredCapabilities:(SECapabilities*)desiredCapabilities requiredCapabilities:(SECapabilities*)requiredCapabilites error:(NSError**)error;

#pragma mark - JSON-Wire Protocol Implementation

// GET /status
-(SEStatus*) getStatusAndReturnError:(NSError**)error;

// POST /session
-(SESession*) postSessionWithDesiredCapabilities:(SECapabilities*)desiredCapabilities andRequiredCapabilities:(SECapabilities*)requiredCapabilities error:(NSError**)error;

// GET /sessions
-(NSArray*) getSessionsAndReturnError:(NSError**)error;

// GET /session/:sessionId
-(SESession*) getSessionWithSession:(NSString*)sessionId error:(NSError**)error;

// DELETE /session/:sessionId
-(void) deleteSessionWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/timeouts
-(void) postTimeout:(NSInteger)timeoutInMilliseconds forType:(SETimeoutType)type session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/timeouts/async_script
-(void) postAsyncScriptWaitTimeout:(NSInteger)timeoutInMilliseconds session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/timeouts/implicit_wait
-(void) postImplicitWaitTimeout:(NSInteger)timeoutInMilliseconds session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/window_handle
-(NSNumber*) getWindowHandleWithSession:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/window_handles
-(NSArray*) getWindowHandlesWithSession:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/url
-(NSURL*) getURLWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/url
-(void) postURL:(NSURL*)url session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/forward
-(void) postForwardWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/back
-(void) postBackWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/refresh
-(void) postRefreshWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/execute
-(NSDictionary*) postExecuteScript:(NSString*)script arguments:(NSArray*)arguments session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/execute_async
-(NSDictionary*) postExecuteAsyncScript:(NSString*)script arguments:(NSArray*)arguments session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/screenshot
-(NSImage*) getScreenshotWithSession:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/ime/available_engines
-(NSArray*) getAvailableInputMethodEnginesWithSession:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/ime/active_engine
-(NSString*) getActiveInputMethodEngineWithSession:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/ime/activated
-(BOOL) getInputMethodEngineIsActivatedWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/ime/deactivate
-(void) postDeactivateInputMethodEngineWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/ime/activate
-(void) postActivateInputMethodEngine:(NSString*)engine session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/frame
-(void) postSetFrame:(id)name session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/window
-(void) postSetWindow:(NSNumber*)windowHandle session:(NSString*)sessionId error:(NSError**)error;

// DELETE /session/:sessionId/window
-(void) deleteWindowWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/window/:windowHandle/size
-(void) postSetWindowSize:(NSSize)size window:(NSNumber*)windowHandle session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/window/:windowHandle/size
-(NSSize) getWindowSizeWithWindow:(NSNumber*)windowHandle session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/window/:windowHandle/position
-(void) postSetWindowPosition:(NSPoint)position window:(NSNumber*)windowHandle session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/window/:windowHandle/position
-(NSPoint) getWindowPositionWithWindow:(NSNumber*)windowHandle session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/window/:windowHandle/maximize
-(void) postMaximizeWindow:(NSNumber*)windowHandle session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/cookie
-(NSArray*) getCookiesWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/cookie
-(void) postCookie:(NSHTTPCookie*)cookie session:(NSString*)sessionId error:(NSError**)error;

// DELETE /session/:sessionId/cookie
-(void) deleteCookiesWithSession:(NSString*)sessionId error:(NSError**)error;

// DELETE /session/:sessionId/cookie/:name
-(void) deleteCookie:(NSString*)cookieName session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/source
-(NSString*) getSourceWithSession:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/title
-(NSString*) getTitleWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/element
-(SEWebElement*) postElement:(SEBy*)locator session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/elements
-(NSArray*) postElements:(SEBy*)locator session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/element/active
-(SEWebElement*) postActiveElementWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/element/:id
// FUTURE (NOT YET IMPLEMENTED)

// POST /session/:sessionId/element/:id/element
-(SEWebElement*) postElementFromElement:(SEWebElement*)element by:(SEBy*)locator session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/element/:id/elements
-(NSArray*) postElementsFromElement:(SEWebElement*)element by:(SEBy*)locator session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/element/:id/click
-(void) postClickElement:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/element/:id/submit
-(void) postSubmitElement:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/element/:id/text
-(NSString*) getElementText:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// /session/:sessionId/element/:id/value
-(void) postKeys:(unichar *)keys element:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/keys
-(void) postKeys:(unichar *)keys session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/element/:id/name
-(NSString*) getElementName:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/element/:id/clear
-(void) postClearElement:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/element/:id/selected
-(BOOL) getElementIsSelected:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/element/:id/enabled
-(BOOL) getElementIsEnabled:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/element/:id/attribute/:name
-(NSString*) getAttribute:(NSString*)attributeName element:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/element/:id/equals/:other
-(BOOL) getEqualityForElement:(SEWebElement*)element element:(SEWebElement*)otherElement session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/element/:id/displayed
-(BOOL) getElementIsDisplayed:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/element/:id/location
-(NSPoint) getElementLocation:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/element/:id/location_in_view
-(NSPoint) getElementLocationInView:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/element/:id/size
-(NSSize) getElementSize:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/element/:id/css/:propertyName
-(NSString*) getCSSProperty:(NSString*)propertyName element:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/orientation
-(SEScreenOrientation) getOrientationWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/orientation
-(void) postOrientation:(SEScreenOrientation)orientation session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/alert_text
-(NSString*) getAlertTextWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/alert_text
-(void) postAlertText:(NSString*)text session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/accept_alert
-(void) postAcceptAlertWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/dismiss_alert
-(void) postDismissAlertWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/moveto
-(void) postMoveMouseToElement:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/click
-(void) postClickMouseButton:(SEMouseButton)button session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/buttondown
-(void) postMouseButtonDown:(SEMouseButton)button session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/buttonup
-(void) postMouseButtonUp:(SEMouseButton)button session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/doubleclick
-(void) postDoubleClickWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/touch/click
-(void) postTapElement:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/touch/down
-(void) postFingerDownAt:(NSPoint)point session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/touch/up
-(void) postFingerUpAt:(NSPoint)point session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/touch/move
-(void) postMoveFingerTo:(NSPoint)point session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/touch/scroll
-(void) postStartScrollingAtParticularLocation:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/touch/scroll
-(void) postScrollfromAnywhereOnTheScreenWithSession:(NSPoint)point session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/touch/doubleclick
-(void) postDoubleTapElement:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/touch/longclick
-(void) postPressElement:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/touch/flick
-(void) postFlickFromParticularLocation:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset  speed:(NSInteger)speed session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/touch/flick
-(void) postFlickFromAnywhere:(NSInteger)xSpeed ySpeed:(NSInteger)ySpeed session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/location
-(SELocation*) getLocationAndReturnError:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/location
-(void) postLocation:(SELocation*)location session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/local_storage
-(NSArray*) getAllLocalStorageKeys:(NSString*)sessionId error:(NSError**)error;

//POST /session/:sessionId/local_storage
-(void) postSetLocalStorageItemForKey:(NSString*)key value:(NSString*)value session:(NSString*)sessionId error:(NSError**)error;

// DELETE /session/:sessionId/local_storage
-(void) deleteLocalStorage:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/local_storage/key/:key
-(void) getLocalStorageItemForKey:(NSString*)key session:(NSString*)sessionId error:(NSError**)error;

//DELETE /session/:sessionId/local_storage/key/:key
-(void) deleteLocalStorageItemForGivenKey:(NSString*)key session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/local_storage/size
-(NSInteger) getLocalStorageSize:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/session_storage
-(NSArray*) getAllStorageKeys:(NSString*)sessionId error:(NSError**)error;

//POST /session/:sessionId/session_storage
-(void) postSetStorageItemForKey:(NSString*)key value:(NSString*)value session:(NSString*)sessionId error:(NSError**)error;

// DELETE /session/:sessionId/session_storage
-(void) deleteStorage:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/session_storage/key/:key
-(void) getStorageItemForKey:(NSString*)key session:(NSString*)sessionId error:(NSError**)error;

//DELETE /session/:sessionId/session_storage/key/:key
-(void) deleteStorageItemForGivenKey:(NSString*)key session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/session_storage/size
-(NSInteger) getStorageSize:(NSString*) sessionId error:(NSError**) error;

// POST /session/:sessionId/log
-(NSArray*) getLogForGivenLogType:(SELogType)type session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/log/types
-(NSArray*) getLogTypes:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/application_cache/status
-(SEApplicationCacheStatus) getApplicationCacheStatusWithSession:(NSString*)sessionId error:(NSError**)error;

@end
