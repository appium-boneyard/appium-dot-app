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
@class SETouchAction;

@interface SEJsonWireClient : NSObject

@property NSError *lastError;
@property NSMutableArray *errors;

-(id) initWithServerAddress:(NSString*)address port:(NSInteger)port error:(NSError**)error;
-(void) addError:(NSError*)error;

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

// GET /session/:sessionid/contexts
-(NSArray*) getContextsForSession:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionid/context
-(NSString*) getContextForSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionid/context
-(void) postContext:(NSString*)context session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/timeouts
-(void) postTimeout:(NSInteger)timeoutInMilliseconds forType:(SETimeoutType)type session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/timeouts/async_script
-(void) postAsyncScriptWaitTimeout:(NSInteger)timeoutInMilliseconds session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/timeouts/implicit_wait
-(void) postImplicitWaitTimeout:(NSInteger)timeoutInMilliseconds session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/window_handle
-(NSString*) getWindowHandleWithSession:(NSString*)sessionId error:(NSError**)error;

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
-(IMAGE_TYPE*) getScreenshotWithSession:(NSString*)sessionId error:(NSError**)error;

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
-(void) postSetWindow:(NSString*)windowHandle session:(NSString*)sessionId error:(NSError**)error;

// DELETE /session/:sessionId/window
-(void) deleteWindowWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/window/:windowHandle/size
-(void) postSetWindowSize:(SIZE_TYPE)size window:(NSString*)windowHandle session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/window/:windowHandle/size
-(SIZE_TYPE) getWindowSizeWithWindow:(NSString*)windowHandle session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/window/:windowHandle/position
-(void) postSetWindowPosition:(POINT_TYPE)position window:(NSString*)windowHandle session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/window/:windowHandle/position
-(POINT_TYPE) getWindowPositionWithWindow:(NSString*)windowHandle session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/window/:windowHandle/maximize
-(void) postMaximizeWindow:(NSString*)windowHandle session:(NSString*)sessionId error:(NSError**)error;

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
-(POINT_TYPE) getElementLocation:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/element/:id/location_in_view
-(POINT_TYPE) getElementLocationInView:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/element/:id/size
-(SIZE_TYPE) getElementSize:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error;

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
-(void) postFingerDownAt:(POINT_TYPE)point session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/touch/up
-(void) postFingerUpAt:(POINT_TYPE)point session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/touch/move
-(void) postMoveFingerTo:(POINT_TYPE)point session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/touch/scroll
-(void) postStartScrollingAtParticularLocation:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/touch/scroll
-(void) postScrollfromAnywhereOnTheScreenWithSession:(POINT_TYPE)point session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/touch/doubleclick
-(void) postDoubleTapElement:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/touch/longclick
-(void) postPressElement:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/touch/perform
-(void) postTouchAction:(SETouchAction *)touchAction session:(NSString*)sessionId error:(NSError**)error;

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


#pragma mark - 3.0 methods
/////////////////
// 3.0 METHODS //
/////////////////

// POST /wd/hub/session/:sessionId/appium/device/shake
-(void) postShakeDeviceWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /wd/hub/session/:sessionId/appium/device/lock
-(void) postLockDeviceWithSession:(NSString*)sessionId seconds:(NSInteger)seconds error:(NSError**)error;

// POST /wd/hub/session/:sessionId/appium/device/unlock
-(void) postUnlockDeviceWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /wd/hub/session/:sessionId/appium/device/is_locked
-(BOOL) postIsDeviceLockedWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /wd/hub/session/:sessionId/appium/device/press_keycode
-(void) postPressKeycode:(NSInteger)keycode metastate:(NSInteger)metaState session:(NSString*)sessionId error:(NSError**)error;

// POST /wd/hub/session/:sessionId/appium/device/long_press_keycode
-(void) postLongPressKeycode:(NSInteger)keycode metastate:(NSInteger)metaState session:(NSString*)sessionId error:(NSError**)error;

// POST /wd/hub/session/:sessionId/appium/device/keyevent
-(void) postKeyEvent:(NSInteger)keycode metastate:(NSInteger)metaState session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/appium/app/rotate
- (void)postRotate:(SEScreenOrientation)orientation session:(NSString*)sessionId error:(NSError **)error;

// GET /wd/hub/session/:sessionId/appium/device/current_activity
-(NSString*) getCurrentActivityForDeviceForSession:(NSString*)sessionId error:(NSError**)error;

// POST /wd/hub/session/:sessionId/appium/device/install_app
- (void)postInstallApp:(NSString*)appPath session:(NSString*)sessionId error:(NSError **)error;

// POST /wd/hub/session/:sessionId/appium/device/remove_app
- (void)postRemoveApp:(NSString*)appPath session:(NSString*)sessionId error:(NSError **)error;

// POST /wd/hub/session/:sessionId/appium/device/app_installed
-(BOOL) postIsAppInstalledWithBundleId:(NSString*)bundleId session:(NSString*)sessionId error:(NSError**)error;

// POST /wd/hub/session/:sessionId/appium/device/hide_keyboard
-(void) postHideKeyboardWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /wd/hub/session/:sessionId/appium/device/push_file
- (void)postPushFileToPath:(NSString*)path data:(NSData*)data session:(NSString*)sessionId error:(NSError **)error;

// POST /wd/hub/session/:sessionId/appium/device/pull_file
-(NSData*) postPullFileAtPath:(NSString*)path session:(NSString*)sessionId error:(NSError**)error;

// POST /wd/hub/session/:sessionId/appium/device/pull_folder
-(NSData*) postPullFolderAtPath:(NSString*)path session:(NSString*)sessionId error:(NSError**)error;

// POST /wd/hub/session/:sessionId/appium/device/toggle_airplane_mode
-(void) postToggleAirplaneModeWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /wd/hub/session/:sessionId/appium/device/toggle_data
-(void) postToggleDataWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /wd/hub/session/:sessionId/appium/device/toggle_wifi
-(void) postToggleWifiWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /wd/hub/session/:sessionId/appium/device/toggle_location_services
-(void) postToggleLocationServicesWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /wd/hub/session/:sessionId/appium/device/open_notifications
-(void) postOpenNotificationsWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /wd/hub/session/:sessionId/appium/device/start_activity
-(void) postStartActivity:(NSString*)activity package:(NSString*)package waitActivity:(NSString*)waitActivity waitPackage:(NSString*)waitPackage session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/appium/app/launch
- (void)postLaunchAppWithSession:(NSString *)sessionId error:(NSError **)error;

// POST /session/:sessionId/appium/app/close
- (void)postCloseAppWithSession:(NSString *)sessionId error:(NSError **)error;

// POST /session/:sessionId/appium/app/reset
- (void)postResetAppWithSession:(NSString *)sessionId error:(NSError **)error;

// POST /session/:sessionId/appium/app/background
- (void)postRunAppInBackground:(NSInteger)seconds session:(NSString *)sessionId error:(NSError **)error;

// POST /wd/hub/session/:sessionId/appium/app/end_test_coverage
- (void)postEndTestCoverageWithSession:(NSString *)sessionId error:(NSError **)error;

// GET /wd/hub/session/:sessionId/appium/app/strings
-(NSString*) getAppStringsForLanguage:(NSString*)languageCode session:(NSString*)sessionId error:(NSError**)error;

// POST /wd/hub/session/:sessionId/appium/element/:elementId?/value
-(void) postSetValueForElement:(SEWebElement*)element value:(NSString*)value isUnicode:(BOOL)isUnicode session:(NSString*)sessionId error:(NSError**)error;

// POST /wd/hub/session/:sessionId/appium/element/:elementId?/replace_value
-(void) postReplaceValueForElement:(SEWebElement*)element value:(NSString*)value isUnicode:(BOOL)isUnicode session:(NSString*)sessionId error:(NSError**)error;

// POST /wd/hub/session/:sessionId/appium/settings
-(void) postSetAppiumSettings:(NSDictionary*)settings session:(NSString*)sessionId error:(NSError**)error;

// GET /wd/hub/session/:sessionId/appium/settings
-(NSDictionary*) getAppiumSettingsWithSession:(NSString*)sessionId error:(NSError**)error;

@end
