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

@class SECapabilities;
@class SEBy;
@class SEWebElement;
@class SESession;

/**
 The `SERemoteWebDriver` class controls a webdriver session against a remote webdriver server
 */
@interface SERemoteWebDriver : NSObject


/**
 The session on which the `SERemoteWebDriver` will operate.
 */
@property SESession *session;


/**
 The last error thrown by an operation performed on this class
 */
@property NSError *lastError;


/**
 All errors thrown by this class
 */
@property NSMutableArray *errors;


/**
 Initializes the webdriver with server configuration and capabilities
 
 @param address The IP address of the remote web driver server
 @param port The TCP port on which the remote web driver server is running
 @param desiredCapabilities Capabilties desired for the server to implement
 @param requiredCapabilites Capabilties required for the server to implement
 @param error Storage for an error that may occur
 @return The remote web driver, initialized with server configuraion and tied to a newly created session
 */
-(id) initWithServerAddress:(NSString*)address port:(NSInteger)port desiredCapabilities:(SECapabilities*)desiredCapabilities requiredCapabilities:(SECapabilities*)requiredCapabilites error:(NSError**)error;


/**
  Quits the remote webdriver and deletes the session
 */
-(void) quit;


/**
 Configure the amount of time that a particular type of operation can execute for before they are aborted and a |Timeout| error is returned to the client. 
 @param timeoutInMilliseconds The amount of time, in milliseconds, that time-limited commands are permitted to run.
 @param type The type of operation to set the timeout for. Valid values are: "script" for script timeouts, "implicit" for modifying the implicit wait timeout and "page load" for setting a page load timeout.
 */
-(void) setTimeout:(NSInteger)timeoutInMilliseconds forType:(SETimeoutType)type;

/**
 Set the amount of time, in milliseconds, that asynchronous scripts executed by /session/:sessionId/execute_async are permitted to run before they are aborted and a |Timeout| error is returned to the client
 
 @param timeoutInMilliseconds The amount of time, in milliseconds, that time-limited commands are permitted to run.
 */
-(void) setAsyncScriptTimeout:(NSInteger)timeoutInMilliseconds;


/**
 Set the amount of time the driver should wait when searching for elements. When searching for a single element, the driver should poll the page until an element is found or the timeout expires, whichever occurs first. When searching for multiple elements, the driver should poll the page until at least one element is found or the timeout expires, at which point it should return an empty list.
 
 If this command is never sent, the driver should default to an implicit wait of 0ms.
 
 @param timeoutInMilliseconds The amount of time to wait, in milliseconds. This value has a lower bound of 0
 */
-(void) setImplicitWaitTimeout:(NSInteger)timeoutInMilliseconds;


/**
 Retrieve the current window handle.

 @return The current window handle.
 */
-(NSNumber*) window;


/**
 Retrieve the list of all window handles available to the session.
 
 @return An array of window handles.
 */
-(NSArray*) allWindows;


/**
 Retrieve the URL of the current page.
 
 @return The current URL.
 */
-(NSURL*) url;


/**
 Navigate to a new URL.
 
 @param url The URL to navigate to.
 */
-(void) setUrl:(NSURL*)url;


/**
 Navigate forwards in the browser history, if possible.
 */
-(void) forward;


/**
 Navigate backwards in the browser history, if possible.
 */
-(void) back;


/**
 Refresh the current page.
 */
-(void) refresh;


/**
 Inject a snippet of JavaScript into the page for execution in the context of the currently selected frame. The executed script is assumed to be synchronous and the result of evaluating the script is returned to the client.
 The script argument defines the script to execute in the form of a function body. The value returned by that function will be returned to the client. The function will be invoked with the provided args array and the values may be accessed via the arguments object in the order specified.
 
 Arguments may be any JSON-primitive, array, or JSON object. JSON objects that define a WebElement reference will be converted to the corresponding DOM element. Likewise, any WebElements in the script result will be returned to the client as WebElement JSON objects.
 
 @param script The script to execute.
 @return The script result.
 */
-(NSDictionary*) executeScript:(NSString*)script;


/**
 Inject a snippet of JavaScript into the page for execution in the context of the currently selected frame. The executed script is assumed to be synchronous and the result of evaluating the script is returned to the client.
 The script argument defines the script to execute in the form of a function body. The value returned by that function will be returned to the client. The function will be invoked with the provided args array and the values may be accessed via the arguments object in the order specified.
 
 Arguments may be any JSON-primitive, array, or JSON object. JSON objects that define a WebElement reference will be converted to the corresponding DOM element. Likewise, any WebElements in the script result will be returned to the client as WebElement JSON objects.
 
 @param script The script to execute.
 @param arguments The arguments for the script
 @return The script result.
 */
-(NSDictionary*) executeScript:(NSString*)script arguments:(NSArray*)arguments;


/**
 Inject a snippet of JavaScript into the page for execution in the context of the currently selected frame. The executed script is assumed to be asynchronous and must signal that is done by invoking the provided callback, which is always provided as the final argument to the function. The value to this callback will be returned to the client.
 Asynchronous script commands may not span page loads. If an unload event is fired while waiting for a script result, an error should be returned to the client.
 
 The script argument defines the script to execute in teh form of a function body. The function will be invoked with the provided args array and the values may be accessed via the arguments object in the order specified. The final argument will always be a callback function that must be invoked to signal that the script has finished.
 
 Arguments may be any JSON-primitive, array, or JSON object. JSON objects that define a WebElement reference will be converted to the corresponding DOM element. Likewise, any WebElements in the script result will be returned to the client as WebElement JSON objects.
 
 @param script The script to execute.
 @return The script result.
 */
-(NSDictionary*) executeAnsynchronousScript:(NSString*)script;


/**
 Inject a snippet of JavaScript into the page for execution in the context of the currently selected frame. The executed script is assumed to be asynchronous and must signal that is done by invoking the provided callback, which is always provided as the final argument to the function. The value to this callback will be returned to the client.
 Asynchronous script commands may not span page loads. If an unload event is fired while waiting for a script result, an error should be returned to the client.
 
 The script argument defines the script to execute in teh form of a function body. The function will be invoked with the provided args array and the values may be accessed via the arguments object in the order specified. The final argument will always be a callback function that must be invoked to signal that the script has finished.
 
 Arguments may be any JSON-primitive, array, or JSON object. JSON objects that define a WebElement reference will be converted to the corresponding DOM element. Likewise, any WebElements in the script result will be returned to the client as WebElement JSON objects.
 
 @param script The script to execute.
 @param arguments The arguments for the script
 @return The script result.
 */
-(NSDictionary*) executeAnsynchronousScript:(NSString*)script arguments:(NSArray*)arguments;


/**
 Take a screenshot of the current page.
 
 @return The PNG screenshot as an NSImage.
 */
-(NSImage*) screenshot;



-(NSArray*) availableInputMethodEngines;
-(NSString*) activeInputMethodEngine;
-(BOOL) inputMethodEngineIsActive;
-(void) deactivateInputMethodEngine;
-(void) activateInputMethodEngine:(NSString*)engine;
-(void) setFrame:(id)name;
-(void) setWindow:(NSNumber*)windowHandle;
-(void) closeWindow:(NSNumber*)windowHandle;
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
-(void) scrollfromElement:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset;
-(void) scrollTo:(NSPoint)position;
-(void) doubletapElement:(SEWebElement*)element;
-(void) pressElement:(SEWebElement*)element;
-(void) flickfromElement:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset speed:(NSInteger)speed;
-(void) flickWithXSpeed:(NSInteger)xSpeed ySpeed:(NSInteger)ySpeed;
-(SELocation*) location;
-(void) setLocation:(SELocation*)location;
-(NSArray*) allLocalStorageKeys;
-(void) setLocalStorageValue:(NSString*)value forKey:(NSString*)key;
-(void) clearLocalStorage;
-(void) localStorageItemForKey:(NSString*)key;
-(void) deleteLocalStorageItemForKey:(NSString*)key;
-(NSInteger) countOfItemsInLocalStorage;
-(NSArray*) allSessionStorageKeys;
-(void) setSessionStorageValue:(NSString*)value forKey:(NSString*)key;
-(void) clearSessionStorage;
-(void) sessionStorageItemForKey:(NSString*)key;
-(NSInteger) countOfItemsInStorage;
-(void) deleteStorageItemForKey:(NSString*)key;
-(NSArray*) getLogForType:(SELogType)type;
-(NSArray*) allLogTypes;
-(SEApplicationCacheStatus) applicationCacheStatus;

@end
