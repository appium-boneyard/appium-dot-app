//
//  SERemoteWebDriver.h
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
#import "SETouchAction.h"

@class SECapabilities;
@class SEBy;
@class SEWebElement;
@class SESession;

@interface SERemoteWebDriver : NSObject

@property SESession *session;
@property (readonly) NSError *lastError;
@property (readonly) NSArray *errors;

@property (readonly) NSString *alertText;
@property (readonly) NSArray *allContexts;
@property (readonly) NSArray *allLogTypes;
@property (readonly) NSArray *allSessions;
@property (readonly) NSArray *allWindows;
@property (readonly) NSDictionary *appiumSettings;
@property NSString *context;
@property (readonly) NSArray *cookies;
@property SELocation *location;
@property (readonly) SEScreenOrientation orientation;
@property (readonly) NSString *pageSource;
@property (readonly) IMAGE_TYPE *screenshot;
@property (readonly) NSString *title;
@property NSURL *url;
@property NSString *window;

-(id) initWithServerAddress:(NSString *)address port:(NSInteger)port;
-(id) initWithServerAddress:(NSString*)address port:(NSInteger)port desiredCapabilities:(SECapabilities*)desiredCapabilities requiredCapabilities:(SECapabilities*)requiredCapabilites error:(NSError**)error;
-(void)quit;
-(void)quitWithError:(NSError**)error;
-(SESession*) startSessionWithDesiredCapabilities:(SECapabilities*)desiredCapabilities requiredCapabilities:(SECapabilities*)requiredCapabilites;
-(SESession*) startSessionWithDesiredCapabilities:(SECapabilities*)desiredCapabilities requiredCapabilities:(SECapabilities*)requiredCapabilites error:(NSError**)error;
-(NSArray*) allSessions;
-(NSArray*) allSessionsWithError:(NSError**)error;
-(NSArray*) allContexts;
-(NSArray*) allContextsWithError:(NSError**)error;
-(NSString*) context;
-(NSString*) contextWithError:(NSError**)error;
-(void) setContext:(NSString*)context;
-(void) setContext:(NSString*)context error:(NSError**)error;
-(void) setTimeout:(NSInteger)timeoutInMilliseconds forType:(SETimeoutType)type;
-(void) setTimeout:(NSInteger)timeoutInMilliseconds forType:(SETimeoutType)type error:(NSError**)error;
-(void) setAsyncScriptTimeout:(NSInteger)timeoutInMilliseconds;
-(void) setAsyncScriptTimeout:(NSInteger)timeoutInMilliseconds error:(NSError**)error;
-(void) setImplicitWaitTimeout:(NSInteger)timeoutInMilliseconds;
-(void) setImplicitWaitTimeout:(NSInteger)timeoutInMilliseconds error:(NSError**)error;
-(NSString*) window;
-(NSString*) windowWithError:(NSError**)error;
-(NSArray*) allWindows;
-(NSArray*) allWindowsWithError:(NSError**)error;
-(NSURL*) url;
-(NSURL*) urlWithError:(NSError**)error;
-(void) setUrl:(NSURL*)url;
-(void) setUrl:(NSURL*)url error:(NSError**)error;
-(void) forward;
-(void) forwardWithError:(NSError**)error;
-(void) back;
-(void) backWithError:(NSError**)error;
-(void) refresh;
-(void) refreshWithError:(NSError**)error;
-(NSDictionary*) executeScript:(NSString*)script;
-(NSDictionary*) executeScript:(NSString*)script arguments:(NSArray*)arguments;
-(NSDictionary*) executeScript:(NSString*)script arguments:(NSArray*)arguments error:(NSError**)error;
-(NSDictionary*) executeAnsynchronousScript:(NSString*)script;
-(NSDictionary*) executeAnsynchronousScript:(NSString*)script arguments:(NSArray*)arguments;
-(NSDictionary*) executeAnsynchronousScript:(NSString*)script arguments:(NSArray*)arguments error:(NSError**)error;
-(IMAGE_TYPE*) screenshot;
-(IMAGE_TYPE*) screenshotWithError:(NSError**)error;
-(NSArray*) availableInputMethodEngines;
-(NSArray*) availableInputMethodEnginesWithError:(NSError**)error;
-(NSString*) activeInputMethodEngine;
-(NSString*) activeInputMethodEngineWithError:(NSError**)error;
-(BOOL) inputMethodEngineIsActive;
-(BOOL) inputMethodEngineIsActiveWithError:(NSError**)error;
-(void) deactivateInputMethodEngine;
-(void) deactivateInputMethodEngineWithError:(NSError**)error;
-(void) activateInputMethodEngine:(NSString*)engine;
-(void) activateInputMethodEngine:(NSString*)engine error:(NSError**)error;
-(void) setFrame:(NSString*)name;
-(void) setFrame:(NSString*)name error:(NSError**)error;
-(void) setWindow:(NSString*)windowHandle;
-(void) setWindow:(NSString*)windowHandle error:(NSError**)error;
-(void) closeWindow:(NSString*)windowHandle;
-(void) closeWindow:(NSString*)windowHandle error:(NSError**)error;
-(void) setWindowSize:(SIZE_TYPE)size window:(NSString*)windowHandle;
-(void) setWindowSize:(SIZE_TYPE)size window:(NSString*)windowHandle error:(NSError**)error;
-(SIZE_TYPE) windowSizeForWindow:(NSString*)windowHandle;
-(SIZE_TYPE) windowSizeForWindow:(NSString*)windowHandle error:(NSError**)error;
-(void) setWindowPosition:(POINT_TYPE)position window:(NSString*)windowHandle;
-(void) setWindowPosition:(POINT_TYPE)position window:(NSString*)windowHandle error:(NSError**)error;
-(POINT_TYPE) windowPositionForWindow:(NSString*)windowHandle;
-(POINT_TYPE) windowPositionForWindow:(NSString*)windowHandle error:(NSError**)error;
-(void) maximizeWindow:(NSString*)windowHandle;
-(void) maximizeWindow:(NSString*)windowHandle error:(NSError**)error;
-(NSArray*) cookies;
-(NSArray*) cookiesWithError:(NSError**)error;
-(void) setCookie:(NSHTTPCookie*)cookie;
-(void) setCookie:(NSHTTPCookie*)cookie error:(NSError**)error;
-(void) deleteCookies;
-(void) deleteCookiesWithError:(NSError**)error;
-(void) deleteCookie:(NSString*)cookieName;
-(void) deleteCookie:(NSString*)cookieName error:(NSError**)error;
-(NSString*) pageSource;
-(NSString*) pageSourceWithError:(NSError**)error;
-(NSString*) title;
-(NSString*) titleWithError:(NSError**)error;
-(SEWebElement*) findElementBy:(SEBy*)by;
-(SEWebElement*) findElementBy:(SEBy*)by error:(NSError**)error;
-(NSArray*) findElementsBy:(SEBy*)by;
-(NSArray*) findElementsBy:(SEBy*)by error:(NSError**)error;
-(SEWebElement*) activeElement;
-(SEWebElement*) activeElementWithError:(NSError**)error;
-(void) sendKeys:(NSString*)keyString;
-(void) sendKeys:(NSString*)keyString error:(NSError**)error;
-(SEScreenOrientation) orientation;
-(SEScreenOrientation) orientationWithError:(NSError**)error;
-(void) setOrientation:(SEScreenOrientation)orientation;
-(void) setOrientation:(SEScreenOrientation)orientation error:(NSError**)error;
-(NSString*)alertText;
-(NSString*)alertTextWithError:(NSError**)error;
-(void) setAlertText:(NSString*)text;
-(void) setAlertText:(NSString*)text error:(NSError**)error;
-(void) acceptAlert;
-(void) acceptAlertWithError:(NSError**)error;
-(void) dismissAlert;
-(void) dismissAlertWithError:(NSError**)error;
-(void) moveMouseWithXOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset;
-(void) moveMouseToElement:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset;
-(void) moveMouseToElement:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset error:(NSError**)error;
-(void) clickPrimaryMouseButton;
-(void) clickMouseButton:(SEMouseButton)button;
-(void) clickMouseButton:(SEMouseButton)button error:(NSError**)error;
-(void) mouseButtonDown:(SEMouseButton)button;
-(void) mouseButtonDown:(SEMouseButton)button error:(NSError**)error;
-(void) mouseButtonUp:(SEMouseButton)button;
-(void) mouseButtonUp:(SEMouseButton)button error:(NSError**)error;
-(void) doubleclick;
-(void) doubleclickWithError:(NSError**)error;
-(void) tapElement:(SEWebElement*)element;
-(void) tapElement:(SEWebElement*)element error:(NSError**)error;
-(void) fingerDownAt:(POINT_TYPE)point;
-(void) fingerDownAt:(POINT_TYPE)point error:(NSError**)error;
-(void) fingerUpAt:(POINT_TYPE)point;
-(void) fingerUpAt:(POINT_TYPE)point error:(NSError**)error;
-(void) moveFingerTo:(POINT_TYPE)point;
-(void) moveFingerTo:(POINT_TYPE)point error:(NSError**)error;
-(void) scrollfromElement:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset;
-(void) scrollfromElement:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset error:(NSError**)error;
-(void) scrollTo:(POINT_TYPE)position;
-(void) scrollTo:(POINT_TYPE)position error:(NSError**)error;
-(void) doubletapElement:(SEWebElement*)element;
-(void) doubletapElement:(SEWebElement*)element error:(NSError**)error;
-(void) pressElement:(SEWebElement*)element;
-(void) pressElement:(SEWebElement*)element error:(NSError**)error;
-(void) performTouchAction:(SETouchAction *)touchAction;
-(void) performTouchAction:(SETouchAction *)touchAction error:(NSError**)error;
-(void) flickfromElement:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset speed:(NSInteger)speed;
-(void) flickfromElement:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset speed:(NSInteger)speed error:(NSError**)error;
-(void) flickWithXSpeed:(NSInteger)xSpeed ySpeed:(NSInteger)ySpeed;
-(void) flickWithXSpeed:(NSInteger)xSpeed ySpeed:(NSInteger)ySpeed error:(NSError**)error;
-(SELocation*) location;
-(SELocation*) locationWithError:(NSError**)error;
-(void) setLocation:(SELocation*)location;
-(void) setLocation:(SELocation*)location error:(NSError**)error;
-(NSArray*) allLocalStorageKeys;
-(NSArray*) allLocalStorageKeysWithError:(NSError**)error;
-(void) setLocalStorageValue:(NSString*)value forKey:(NSString*)key;
-(void) setLocalStorageValue:(NSString*)value forKey:(NSString*)key error:(NSError**)error;
-(void) clearLocalStorage;
-(void) clearLocalStorageWithError:(NSError**)error;
-(void) localStorageItemForKey:(NSString*)key;
-(void) localStorageItemForKey:(NSString*)key error:(NSError**)error;
-(void) deleteLocalStorageItemForKey:(NSString*)key;
-(void) deleteLocalStorageItemForKey:(NSString*)key error:(NSError**)error;
-(NSInteger) countOfItemsInLocalStorage;
-(NSInteger) countOfItemsInLocalStorageWithError:(NSError**)error;
-(NSArray*) allSessionStorageKeys;
-(NSArray*) allSessionStorageKeysWithError:(NSError**)error;
-(void) setSessionStorageValue:(NSString*)value forKey:(NSString*)key;
-(void) setSessionStorageValue:(NSString*)value forKey:(NSString*)key error:(NSError**)error;
-(void) clearSessionStorage;
-(void) clearSessionStorageWithError:(NSError**)error;
-(void) sessionStorageItemForKey:(NSString*)key;
-(void) sessionStorageItemForKey:(NSString*)key error:(NSError**)error;
-(void) deleteStorageItemForKey:(NSString*)key;
-(void) deleteStorageItemForKey:(NSString*)key error:(NSError**)error;
-(NSInteger) countOfItemsInStorage;
-(NSInteger) countOfItemsInStorageWithError:(NSError**)error;
-(NSArray*) getLogForType:(SELogType)type;
-(NSArray*) getLogForType:(SELogType)type error:(NSError**)error;
-(NSArray*) allLogTypes;
-(NSArray*) allLogTypesWithError:(NSError**)error;
-(SEApplicationCacheStatus) applicationCacheStatus;
-(SEApplicationCacheStatus) applicationCacheStatusWithError:(NSError**)error;

#pragma mark - 3.0 methods
/////////////////
// 3.0 METHODS //
/////////////////

-(void) shakeDevice;
-(void) shakeDeviceWithError:(NSError**)error;
-(void) lockDeviceScreen:(NSInteger)seconds;
-(void) lockDeviceScreen:(NSInteger)seconds error:(NSError**)error;
-(void) unlockDeviceScreen:(NSInteger)seconds;
-(void) unlockDeviceScreen:(NSInteger)seconds error:(NSError**)error;
-(BOOL) isDeviceLocked;
-(BOOL) isDeviceLockedWithError:(NSError**)error;
-(void) pressKeycode:(NSInteger)keycode metaState:(NSInteger)metastate error:(NSError**)error;
-(void) longPressKeycode:(NSInteger)keycode metaState:(NSInteger)metastate error:(NSError**)error;
-(void) triggerKeyEvent:(NSInteger)keycode metaState:(NSInteger)metastate error:(NSError**)error;
-(void) rotateDevice:(SEScreenOrientation)orientation;
-(void) rotateDevice:(SEScreenOrientation)orientation error:(NSError**)error;
-(NSString*)currentActivity;
-(NSString*)currentActivityWithError:(NSError**)error;
-(void)installAppAtPath:(NSString*)appPath;
-(void)installAppAtPath:(NSString*)appPath error:(NSError**)error;
-(void)removeApp:(NSString*)bundleId;
-(void)removeApp:(NSString*)bundleId error:(NSError**)error;
-(BOOL)isAppInstalled:(NSString*)bundleId;
-(BOOL)isAppInstalled:(NSString*)bundleId error:(NSError**)error;
-(void) hideKeyboard;
-(void) hideKeyboardWithError:(NSError**)error;
-(void) pushFileToPath:(NSString*)filePath data:(NSData*)data;
-(void) pushFileToPath:(NSString*)filePath data:(NSData*)data error:(NSError**) error;
-(NSData*) pullFileAtPath:(NSString*)filePath;
-(NSData*) pullFileAtPath:(NSString*)filePath error:(NSError**) error;
-(NSData*) pullFolderAtPath:(NSString*)filePath;
-(NSData*) pullFolderAtPath:(NSString*)filePath error:(NSError**) error;
-(void) toggleAirplaneMode;
-(void) toggleAirplaneModeWithError:(NSError**)error;
-(void) toggleCellularData;
-(void) toggleCellularDataWithError:(NSError**)error;
-(void) toggleWifi;
-(void) toggleWifiWithError:(NSError**)error;
-(void) toggleLocationServices;
-(void) toggleLocationServicesWithError:(NSError**)error;
-(void) openNotifications;
-(void) openNotificationsWithError:(NSError**)error;
-(void) startActivity:(NSString*)activity package:(NSString*)package;
-(void) startActivity:(NSString*)activity package:(NSString*)package waitActivity:(NSString*)waitActivity waitPackage:(NSString*)waitPackage;
-(void) startActivity:(NSString*)activity package:(NSString*)package waitActivity:(NSString*)waitActivity waitPackage:(NSString*)waitPackage error:(NSError**)error;
-(void) launchApp;
-(void) launchAppWithError:(NSError**)error;
-(void) closeApp;
-(void) closeAppWithError:(NSError**)error;
-(void) resetApp;
-(void) resetAppWithError:(NSError**)error;
-(void) runAppInBackground:(NSInteger)seconds;
-(void) runAppInBackground:(NSInteger)seconds error:(NSError**)error;
-(void) endTestCodeCoverage;
-(void) endTestCodeCoverageWithError:(NSError**)error;
-(NSString*)appStrings;
-(NSString*)appStringsForLanguage:(NSString*)languageCode;
-(NSString*)appStringsForLanguage:(NSString*)languageCode error:(NSError**)error;
-(void) setAppiumSettings:(NSDictionary*)settings;
-(void) setAppiumSettings:(NSDictionary*)settings error:(NSError**)error;
-(NSDictionary*) appiumSettings;
-(NSDictionary*) appiumSettingsWithError:(NSError**)error;

@end
