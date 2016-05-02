//
//  SERemoteWebDriver.m
//  Selenium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "SERemoteWebDriver.h"

@interface SERemoteWebDriver ()
	@property SEJsonWireClient *jsonWireClient;
@end

@implementation SERemoteWebDriver

#pragma mark - Public Methods

-(id) init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-init is not a valid initializer for the class SERemoteWebDriver"
                                 userInfo:nil];
    return nil;
}

-(id) initWithServerAddress:(NSString *)address port:(NSInteger)port
{
	self = [super init];
    if (self) {
		NSError *error;
        [self setJsonWireClient:[[SEJsonWireClient alloc] initWithServerAddress:address port:port error:&error]];
		[self addError:error];
    }
    return self;
}

-(id) initWithServerAddress:(NSString*)address port:(NSInteger)port desiredCapabilities:(SECapabilities*)desiredCapabilities requiredCapabilities:(SECapabilities*)requiredCapabilites error:(NSError**)error
{
    self = [self initWithServerAddress:address port:port];
    if (self) {
        [self setJsonWireClient:[[SEJsonWireClient alloc] initWithServerAddress:address port:port error:error]];
		[self addError:*error];

		// get session
		[self setSession:[self startSessionWithDesiredCapabilities:desiredCapabilities requiredCapabilities:requiredCapabilites]];
        if (self.session == nil)
            return nil;
    }
    return self;
}

-(void)addError:(NSError*)error
{
    [self.jsonWireClient addError:error];
}

-(NSArray*) errors {
    return self.jsonWireClient.errors;
}

-(NSError*) lastError {
    return self.jsonWireClient.lastError;
}

-(void)quit
{
    NSError *error;
    [self quitWithError:&error];
	[self addError:error];
}

-(void)quitWithError:(NSError**)error {
    [self.jsonWireClient deleteSessionWithSession:self.session.sessionId error:error];
}

-(SESession*) startSessionWithDesiredCapabilities:(SECapabilities*)desiredCapabilities requiredCapabilities:(SECapabilities*)requiredCapabilites
{
	// get session
	NSError *error;
    SESession* session = [self startSessionWithDesiredCapabilities:desiredCapabilities requiredCapabilities:requiredCapabilites error:&error];
	[self addError:error];
    return session;
}

-(SESession*) startSessionWithDesiredCapabilities:(SECapabilities*)desiredCapabilities requiredCapabilities:(SECapabilities*)requiredCapabilites error:(NSError**)error
{
    // get session
    [self setSession:[self.jsonWireClient postSessionWithDesiredCapabilities:desiredCapabilities andRequiredCapabilities:requiredCapabilites error:error]];
    if ([*error code] != 0)
        return nil;
    return [self session];
}

-(NSArray*) allSessions
{
	NSError *error;
    NSArray *sessions = [self allSessionsWithError:&error];
	[self addError:error];
	return sessions;
}

-(NSArray*) allSessionsWithError:(NSError**)error {
    return [self.jsonWireClient getSessionsAndReturnError:error];
}

-(NSArray*) allContexts {
    NSError *error;
    NSArray *contexts = [self allContextsWithError:&error];
    [self addError:error];
    return contexts;
}

-(NSArray*) allContextsWithError:(NSError**)error
{
    return [self.jsonWireClient getContextsForSession:self.session.sessionId error:error];
}

-(NSString*) context
{
    NSError *error;
    NSString* context = [self contextWithError:&error];
    [self addError:error];
    return context;
}

-(NSString*) contextWithError:(NSError**)error
{
    return [self.jsonWireClient getContextForSession:self.session.sessionId error:error];
}

-(void) setContext:(NSString*)context
{
    NSError *error;
    [self setContext:context error:&error];
    [self addError:error];
}

-(void) setContext:(NSString*)context error:(NSError**)error
{
    [self.jsonWireClient postContext:context session:self.session.sessionId error:error];
}

-(void) setTimeout:(NSInteger)timeoutInMilliseconds forType:(SETimeoutType)type
{
    NSError *error;
    [self setTimeout:timeoutInMilliseconds forType:type error:&error];
	[self addError:error];
}

-(void) setTimeout:(NSInteger)timeoutInMilliseconds forType:(SETimeoutType)type error:(NSError**)error
{

    [self.jsonWireClient postTimeout:timeoutInMilliseconds forType:type session:self.session.sessionId error:error];
}

-(void) setAsyncScriptTimeout:(NSInteger)timeoutInMilliseconds
{
	NSError *error;
    [self setAsyncScriptTimeout:timeoutInMilliseconds error:&error];
	[self addError:error];
}

-(void) setAsyncScriptTimeout:(NSInteger)timeoutInMilliseconds error:(NSError**)error
{
    [self.jsonWireClient postAsyncScriptWaitTimeout:timeoutInMilliseconds session:self.session.sessionId error:error];
}

-(void) setImplicitWaitTimeout:(NSInteger)timeoutInMilliseconds
{
	NSError *error;
    [self setImplicitWaitTimeout:timeoutInMilliseconds error:&error];
	[self addError:error];
}

-(void) setImplicitWaitTimeout:(NSInteger)timeoutInMilliseconds error:(NSError**)error
{
    [self.jsonWireClient postImplicitWaitTimeout:timeoutInMilliseconds session:self.session.sessionId error:error];
}

-(NSString*) window
{
	NSError *error;
    NSString* window = [self windowWithError:&error];
	[self addError:error];
	return window;
}

-(NSString*) windowWithError:(NSError**)error
{
    return [self.jsonWireClient getWindowHandleWithSession:self.session.sessionId error:error];
}

-(NSArray*) allWindows
{
	NSError *error;
    NSArray * windows = [self allWindowsWithError:&error];
	[self addError:error];
	return windows;
}

-(NSArray*) allWindowsWithError:(NSError**)error
{
    return [self.jsonWireClient getWindowHandlesWithSession:self.session.sessionId error:error];
}

-(NSURL*) url
{
	NSError *error;
    NSURL *url = [self urlWithError:&error];
	return url;
}

-(NSURL*) urlWithError:(NSError**)error
{
    return [self.jsonWireClient getURLWithSession:self.session.sessionId error:error];
}

-(void) setUrl:(NSURL*)url
{
	NSError *error;
    [self setUrl:url error:&error];
	[self addError:error];
}

-(void) setUrl:(NSURL*)url error:(NSError**)error
{
    [self.jsonWireClient postURL:url session:self.session.sessionId error:error];

}

-(void) forward
{
	NSError *error;
    [self forwardWithError:&error];
	[self addError:error];
}

-(void) forwardWithError:(NSError**)error
{
    [self.jsonWireClient postForwardWithSession:self.session.sessionId error:error];
}

-(void) back
{
	NSError *error;
    [self backWithError:&error];
	[self addError:error];
}

-(void) backWithError:(NSError**)error
{
    [self.jsonWireClient postBackWithSession:self.session.sessionId error:error];
}

-(void) refresh
{
	NSError *error;
    [self refreshWithError:&error];
	[self addError:error];
}

-(void) refreshWithError:(NSError**)error
{
    [self.jsonWireClient postRefreshWithSession:self.session.sessionId error:error];
}

-(NSDictionary*) executeScript:(NSString*)script
{
	return [self executeScript:script arguments:nil];
}

-(NSDictionary*) executeScript:(NSString*)script arguments:(NSArray*)arguments
{
	NSError *error;
    NSDictionary *output = [self executeScript:script arguments:arguments error:&error];
	[self addError:error];
	return output;
}

-(NSDictionary*) executeScript:(NSString*)script arguments:(NSArray*)arguments error:(NSError**)error
{
    return [self.jsonWireClient postExecuteScript:script arguments:arguments session:self.session.sessionId error:error];
}

-(NSDictionary*) executeAnsynchronousScript:(NSString*)script
{
	return [self executeAnsynchronousScript:script arguments:nil];
}

-(NSDictionary*) executeAnsynchronousScript:(NSString*)script arguments:(NSArray*)arguments
{
	NSError *error;
    NSDictionary *output = [self executeAnsynchronousScript:script arguments:arguments error:&error];
	[self addError:error];
	return output;
}

-(NSDictionary*) executeAnsynchronousScript:(NSString*)script arguments:(NSArray*)arguments error:(NSError**)error
{

    return [self.jsonWireClient postExecuteAsyncScript:script arguments:arguments session:self.session.sessionId error:error];
}

-(IMAGE_TYPE*) screenshot
{
	NSError *error;
    IMAGE_TYPE *image = [self screenshotWithError:&error];
	return image;
}

-(IMAGE_TYPE*) screenshotWithError:(NSError**)error
{
    return [self.jsonWireClient getScreenshotWithSession:self.session.sessionId error:error];
}

-(NSArray*) availableInputMethodEngines
{
	NSError *error;
    NSArray *engines = [self availableInputMethodEnginesWithError:&error];
	[self addError:error];
	return engines;
}

-(NSArray*) availableInputMethodEnginesWithError:(NSError**)error
{

    return[self.jsonWireClient getAvailableInputMethodEnginesWithSession:self.session.sessionId error:error];
}

-(NSString*) activeInputMethodEngine
{
    NSError *error;
    NSString *engine = [self activeInputMethodEngineWithError:&error];
	[self addError:error];
	return engine;
}

-(NSString*) activeInputMethodEngineWithError:(NSError**)error
{
    return [self.jsonWireClient getActiveInputMethodEngineWithSession:self.session.sessionId error:error];
}

-(BOOL) inputMethodEngineIsActive
{
    NSError *error;
    BOOL isActive = [self inputMethodEngineIsActiveWithError:&error];
	[self addError:error];
	return isActive;
}

-(BOOL) inputMethodEngineIsActiveWithError:(NSError**)error
{
    return [self.jsonWireClient getInputMethodEngineIsActivatedWithSession:self.session.sessionId error:error];
}

-(void) deactivateInputMethodEngine
{
    NSError *error;
    [self deactivateInputMethodEngineWithError:&error];
	[self addError:error];
}

-(void) deactivateInputMethodEngineWithError:(NSError**)error
{
    [self.jsonWireClient postDeactivateInputMethodEngineWithSession:self.session.sessionId error:error];
}

-(void) activateInputMethodEngine:(NSString*)engine
{
    NSError *error;
    [self activateInputMethodEngine:engine error:&error];
	[self addError:error];
}

-(void) activateInputMethodEngine:(NSString*)engine error:(NSError**)error
{
    [self.jsonWireClient postActivateInputMethodEngine:engine session:self.session.sessionId error:error];
}

-(void) setFrame:(NSString*)name
{
	NSError* error;
    [self setFrame:name error:&error];
	[self addError:error];
}

-(void) setFrame:(NSString*)name error:(NSError**)error
{
    [self.jsonWireClient postSetFrame:name session:self.session.sessionId error:error];
}

-(void) setWindow:(NSString*)windowHandle
{
	NSError* error;
    [self setWindow:windowHandle error:&error];
	[self addError:error];
}

-(void) setWindow:(NSString*)windowHandle error:(NSError**)error
{
    [self.jsonWireClient postSetWindow:windowHandle session:self.session.sessionId error:error];
}

-(void) closeWindow:(NSString*)windowHandle
{
	NSError* error;
    [self closeWindow:windowHandle error:&error];
	[self addError:error];
}

-(void) closeWindow:(NSString*)windowHandle error:(NSError**)error
{
    [self.jsonWireClient deleteWindowWithSession:self.session.sessionId error:error];
}

-(void) setWindowSize:(SIZE_TYPE)size window:(NSString*)windowHandle
{
	NSError *error;
    [self setWindowSize:size window:windowHandle error:&error];
	[self addError:error];
}

-(void) setWindowSize:(SIZE_TYPE)size window:(NSString*)windowHandle error:(NSError**)error
{
    [self.jsonWireClient postSetWindowSize:size window:windowHandle session:self.session.sessionId error:error];
}

-(SIZE_TYPE) windowSizeForWindow:(NSString*)windowHandle
{
	NSError *error;
    SIZE_TYPE size = [self windowSizeForWindow:windowHandle error:&error];
	[self addError:error];
	return size;
}

-(SIZE_TYPE) windowSizeForWindow:(NSString*)windowHandle error:(NSError**)error
{
    return [self.jsonWireClient getWindowSizeWithWindow:windowHandle session:self.session.sessionId error:error];
}

-(void) setWindowPosition:(POINT_TYPE)position window:(NSString*)windowHandle
{
	NSError *error;
    [self setWindowPosition:position window:windowHandle error:&error];
	[self addError:error];
}

-(void) setWindowPosition:(POINT_TYPE)position window:(NSString*)windowHandle error:(NSError**)error
{
    [self.jsonWireClient postSetWindowPosition:position window:windowHandle session:self.session.sessionId error:error];
}

-(POINT_TYPE) windowPositionForWindow:(NSString*)windowHandle
{
	NSError *error;
    POINT_TYPE position = [self windowPositionForWindow:windowHandle error:&error];
	[self addError:error];
	return position;
}

-(POINT_TYPE) windowPositionForWindow:(NSString*)windowHandle error:(NSError**)error
{
    return [self.jsonWireClient getWindowPositionWithWindow:windowHandle session:self.session.sessionId error:error];
}

-(void) maximizeWindow:(NSString*)windowHandle
{
	NSError *error;
    [self maximizeWindow:windowHandle error:&error];
	[self addError:error];
}

-(void) maximizeWindow:(NSString*)windowHandle error:(NSError**)error
{
    [self.jsonWireClient postMaximizeWindow:windowHandle session:self.session.sessionId error:error];
}

-(NSArray*) cookies
{
	NSError *error;
    NSArray *cookies = [self cookiesWithError:&error];
	[self addError:error];
	return cookies;
}

-(NSArray*) cookiesWithError:(NSError**)error
{
    return [self.jsonWireClient getCookiesWithSession:self.session.sessionId error:error];
}

-(void) setCookie:(NSHTTPCookie*)cookie
{
	NSError *error;
    [self setCookie:cookie error:&error];
	[self addError:error];
}

-(void) setCookie:(NSHTTPCookie*)cookie error:(NSError**)error
{
    [self.jsonWireClient postCookie:cookie session:self.session.sessionId error:error];
}

-(void) deleteCookies
{
	NSError *error;
    [self deleteCookiesWithError:&error];
	[self addError:error];
}

-(void) deleteCookiesWithError:(NSError**)error
{
    [self.jsonWireClient deleteCookiesWithSession:self.session.sessionId error:error];
}

-(void) deleteCookie:(NSString*)cookieName
{
	NSError *error;
    [self deleteCookie:cookieName error:&error];
	[self addError:error];
}

-(void) deleteCookie:(NSString*)cookieName error:(NSError**)error
{
    [self.jsonWireClient deleteCookie:cookieName session:self.session.sessionId error:error];
}

-(NSString*) pageSource
{
    NSError *error;
    NSString *source = [self pageSourceWithError:&error];
	[self addError:error];
	return source;
}

-(NSString*) pageSourceWithError:(NSError**)error
{
    return [self.jsonWireClient getSourceWithSession:self.session.sessionId error:error];
}

-(NSString*) title
{
    NSError *error;
    NSString *title = [self titleWithError:&error];
	return title;
}

-(NSString*) titleWithError:(NSError**)error
{
    return [self.jsonWireClient getTitleWithSession:self.session.sessionId error:error];
}

-(SEWebElement*) findElementBy:(SEBy*)by
{
	NSError *error;
    SEWebElement *element = [self findElementBy:by error:&error];
	[self addError:error];
    return element;
}

-(SEWebElement*) findElementBy:(SEBy*)by error:(NSError**)error
{
    SEWebElement *element = [self.jsonWireClient postElement:by session:self.session.sessionId error:error];
    return element != nil && element.opaqueId != nil ? element : nil;
}

-(NSArray*) findElementsBy:(SEBy*)by
{
	NSError *error;
    NSArray *elements = [self findElementsBy:by error:&error];
	[self addError:error];
	return elements;
}

-(NSArray*) findElementsBy:(SEBy*)by error:(NSError**)error
{
    NSArray *elements = [self.jsonWireClient postElements:by session:self.session.sessionId error:error];
    if (elements == nil || elements.count < 1) {
        return [NSArray new];
    }
    SEWebElement *element = [elements objectAtIndex:0];
    if (element == nil || element.opaqueId == nil) {
        return [NSArray new];
    }
    return elements;
}

-(SEWebElement*) activeElement
{
	NSError *error;
    SEWebElement *element = [self activeElementWithError:&error];
	[self addError:error];
	return element;
}

-(SEWebElement*) activeElementWithError:(NSError**)error
{
    return [self.jsonWireClient postActiveElementWithSession:self.session.sessionId error:error];
}

-(void) sendKeys:(NSString*)keyString
{
	NSError *error;
    [self sendKeys:keyString error:&error];
	[self addError:error];
}

-(void) sendKeys:(NSString*)keyString error:(NSError**)error
{
    unichar keys[keyString.length+1];
    for(int i=0; i < keyString.length; i++)
        keys[i] = [keyString characterAtIndex:i];
    keys[keyString.length] = '\0';
    [self.jsonWireClient postKeys:keys session:self.session.sessionId error:error];
}

-(SEScreenOrientation) orientation
{
	NSError *error;
    SEScreenOrientation orientation = [self orientationWithError:&error];
	[self addError:error];
	return orientation;
}

-(SEScreenOrientation) orientationWithError:(NSError**)error
{
    return [self.jsonWireClient getOrientationWithSession:self.session.sessionId error:error];
}

-(void) setOrientation:(SEScreenOrientation)orientation
{
	NSError* error;
    [self setOrientation:orientation error:&error];
	[self addError:error];
}

-(void) setOrientation:(SEScreenOrientation)orientation error:(NSError**)error
{
    [self.jsonWireClient postOrientation:orientation session:self.session.sessionId error:error];
}

-(NSString*)alertText
{
    NSError *error;
	NSString *alertText = [self alertTextWithError:&error];
	[self addError:error];
	return alertText;
}

-(NSString*)alertTextWithError:(NSError**)error
{
    return [self.jsonWireClient getAlertTextWithSession:self.session.sessionId error:error];
}

-(void) setAlertText:(NSString*)text
{
	NSError* error;
    [self setAlertText:text error:&error];
	[self addError:error];
}

-(void) setAlertText:(NSString*)text error:(NSError**)error
{
    [self.jsonWireClient postAlertText:text session:self.session.sessionId error:error];
}

-(void) acceptAlert
{
	NSError *error;
    [self acceptAlertWithError:&error];
	[self addError:error];
}

-(void) acceptAlertWithError:(NSError**)error
{
    [self.jsonWireClient postAcceptAlertWithSession:self.session.sessionId error:error];
}

-(void) dismissAlert
{
	NSError *error;
    [self dismissAlertWithError:&error];
	[self addError:error];
}

-(void) dismissAlertWithError:(NSError**)error
{
    [self.jsonWireClient postDismissAlertWithSession:self.session.sessionId error:error];
}

-(void) moveMouseWithXOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset
{
	[self moveMouseToElement:nil xOffset:xOffset yOffset:yOffset];
}

-(void) moveMouseToElement:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset
{
	NSError *error;
    [self moveMouseToElement:element xOffset:xOffset yOffset:yOffset error:&error];
	[self addError:error];
}

-(void) moveMouseToElement:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset
                     error:(NSError**)error {
    [self.jsonWireClient postMoveMouseToElement:element xOffset:xOffset yOffset:yOffset session:self.session.sessionId error:error];
}

-(void) clickPrimaryMouseButton
{
	[self clickMouseButton:SELENIUM_MOUSE_LEFT_BUTTON];
}

-(void) clickMouseButton:(SEMouseButton)button
{
	NSError *error;
    [self clickMouseButton:button error:&error];
	[self addError:error];
}

-(void) clickMouseButton:(SEMouseButton)button error:(NSError**)error
{
    [self.jsonWireClient postClickMouseButton:button session:self.session.sessionId error:error];
}

-(void) mouseButtonDown:(SEMouseButton)button
{
	NSError *error;
    [self mouseButtonDown:button error:&error];
	[self addError:error];
}

-(void) mouseButtonDown:(SEMouseButton)button error:(NSError**)error
{
    [self.jsonWireClient postMouseButtonDown:button session:self.session.sessionId error:error];
}

-(void) mouseButtonUp:(SEMouseButton)button
{
	NSError *error;
    [self mouseButtonUp:button error:&error];
	[self addError:error];
}

-(void) mouseButtonUp:(SEMouseButton)button error:(NSError**)error
{
    [self.jsonWireClient postMouseButtonUp:button session:self.session.sessionId error:error];
}

-(void) doubleclick
{
	NSError *error;
    [self doubleclickWithError:&error];
	[self addError:error];
}

-(void) doubleclickWithError:(NSError**)error
{
    [self.jsonWireClient postDoubleClickWithSession:self.session.sessionId error:error];
}

-(void) tapElement:(SEWebElement*)element
{
	NSError *error;
    [self tapElement:element error:&error];
	[self addError:error];
}

-(void) tapElement:(SEWebElement*)element error:(NSError**)error
{
    [self.jsonWireClient postTapElement:element session:self.session.sessionId error:error];
}

-(void) fingerDownAt:(POINT_TYPE)point
{
	NSError *error;
    [self fingerDownAt:point error:&error];
	[self addError:error];
}

-(void) fingerDownAt:(POINT_TYPE)point error:(NSError**)error
{
    [self.jsonWireClient postFingerDownAt:point session:self.session.sessionId error:error];
}

-(void) fingerUpAt:(POINT_TYPE)point
{
	NSError *error;
    [self fingerUpAt:point error:&error];
	[self addError:error];
}

-(void) fingerUpAt:(POINT_TYPE)point error:(NSError**)error
{
    [self.jsonWireClient postFingerUpAt:point session:self.session.sessionId error:error];
}

-(void) moveFingerTo:(POINT_TYPE)point
{
	NSError *error;
    [self moveFingerTo:point error:&error];
	[self addError:error];
}

-(void) moveFingerTo:(POINT_TYPE)point error:(NSError**)error
{
    [self.jsonWireClient postMoveFingerTo:point session:self.session.sessionId error:error];
}

-(void) scrollfromElement:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset
{
    NSError *error;
    [self scrollfromElement:element xOffset:xOffset yOffset:yOffset error:&error];
    [self addError:error];
}

-(void) scrollfromElement:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset error:(NSError**)error
{
    [self.jsonWireClient postStartScrollingAtParticularLocation:element xOffset:xOffset yOffset:yOffset session:self.session.sessionId error:error];
}

-(void) scrollTo:(POINT_TYPE)position
{
    NSError *error;
    [self scrollTo:position error:&error];
    [self addError:error];
}

-(void) scrollTo:(POINT_TYPE)position error:(NSError**)error
{
    [self.jsonWireClient postScrollfromAnywhereOnTheScreenWithSession:position session:self.session.sessionId error:error];
}

-(void) doubletapElement:(SEWebElement*)element
{
	NSError *error;
    [self doubletapElement:element error:&error];
	[self addError:error];
}

-(void) doubletapElement:(SEWebElement*)element error:(NSError**)error
{
    [self.jsonWireClient postDoubleTapElement:element session:self.session.sessionId error:error];
}

-(void) pressElement:(SEWebElement*)element
{
	NSError *error;
    [self pressElement:element error:&error];
	[self addError:error];
}

-(void) pressElement:(SEWebElement*)element error:(NSError**)error
{
    [self.jsonWireClient postPressElement:element session:self.session.sessionId error:error];
}

-(void) performTouchAction:(SETouchAction *)touchAction
{
    NSError *error;
    [self performTouchAction:touchAction error:&error];
    [self addError:error];
}

- (void) performTouchAction:(SETouchAction *)touchAction error:(NSError **)error {
    [self.jsonWireClient postTouchAction:touchAction session:self.session.sessionId error:error];
}


-(void) flickfromElement:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset speed:(NSInteger)speed
{
    NSError *error;
    [self flickfromElement:element xOffset:xOffset yOffset:yOffset speed:speed error:&error];
    [self addError:error];
}

-(void) flickfromElement:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset speed:(NSInteger)speed error:(NSError**)error
{
    [self.jsonWireClient postFlickFromParticularLocation:element xOffset:xOffset yOffset:yOffset speed:speed session:self.session.sessionId error:error];
}

-(void) flickWithXSpeed:(NSInteger)xSpeed ySpeed:(NSInteger)ySpeed
{
    NSError *error;
    [self flickWithXSpeed:xSpeed ySpeed:ySpeed error:&error];
    [self addError:error];
}

-(void) flickWithXSpeed:(NSInteger)xSpeed ySpeed:(NSInteger)ySpeed error:(NSError**)error
{
    [self.jsonWireClient postFlickFromAnywhere:xSpeed ySpeed:ySpeed session:self.session.sessionId error:error];
}

-(SELocation*) location
{
    NSError *error;
    SELocation *location = [self locationWithError:&error];
    [self addError:error];
    return location;
}

-(SELocation*) locationWithError:(NSError**)error
{
    return [self.jsonWireClient getLocationAndReturnError:self.session.sessionId error:error];
}

-(void) setLocation:(SELocation*)location
{
    NSError *error;
    [self setLocation:location error:&error];
    [self addError:error];
}

-(void) setLocation:(SELocation*)location error:(NSError**)error
{
    [self.jsonWireClient postLocation:location session:self.session.sessionId error:error];
}

-(NSArray*) allLocalStorageKeys
{
    NSError *error;
    NSArray *allLocalStorageKeys = [self allLocalStorageKeysWithError:&error];
    [self addError:error];
    return allLocalStorageKeys;

}

-(NSArray*) allLocalStorageKeysWithError:(NSError**)error
{
    return [self.jsonWireClient getAllLocalStorageKeys:self.session.sessionId error:error];
}

-(void) setLocalStorageValue:(NSString*)value forKey:(NSString*)key
{
    NSError *error;
    [self setLocalStorageValue:value forKey:key error:&error];
    [self addError:error];
}

-(void) setLocalStorageValue:(NSString*)value forKey:(NSString*)key error:(NSError**)error
{
    [self.jsonWireClient postSetLocalStorageItemForKey:key value:value session:self.session.sessionId error:error];
}

-(void) clearLocalStorage
{
    NSError *error;
    [self clearLocalStorageWithError:&error];
    [self addError:error];
}

-(void) clearLocalStorageWithError:(NSError**)error
{
    [self.jsonWireClient deleteLocalStorage:self.session.sessionId error:error];
}

-(void) localStorageItemForKey:(NSString*)key
{
    NSError *error;
    [self localStorageItemForKey:key error:&error];
    [self addError:error];
}

-(void) localStorageItemForKey:(NSString*)key error:(NSError**)error
{
    [self.jsonWireClient getLocalStorageItemForKey:key session:self.session.sessionId error:error];
}

-(void) deleteLocalStorageItemForKey:(NSString*)key
{
    NSError *error;
    [self deleteLocalStorageItemForKey:key error:&error];
    [self addError:error];
}

-(void) deleteLocalStorageItemForKey:(NSString*)key error:(NSError**)error
{
    [self.jsonWireClient deleteLocalStorageItemForGivenKey:key session:self.session.sessionId error:error];
}

-(NSInteger) countOfItemsInLocalStorage
{
    NSError *error;
    NSInteger numItems = [self countOfItemsInLocalStorageWithError:&error];
    [self addError:error];
    return numItems;
}

-(NSInteger) countOfItemsInLocalStorageWithError:(NSError**)error
{
    return [self.jsonWireClient getLocalStorageSize:self.session.sessionId error:error];
}

-(NSArray*) allSessionStorageKeys
{
    NSError *error;
    NSArray *allStorageKeys = [self allLocalStorageKeysWithError:&error];
    return allStorageKeys;
}

-(NSArray*) allSessionStorageKeysWithError:(NSError**)error
{
    return [self.jsonWireClient getAllStorageKeys:self.session.sessionId error:error];
}

-(void) setSessionStorageValue:(NSString*)value forKey:(NSString*)key
{
    NSError *error;
    [self setSessionStorageValue:value forKey:key error:&error];
    [self addError:error];
}

-(void) setSessionStorageValue:(NSString*)value forKey:(NSString*)key error:(NSError**)error
{
    [self.jsonWireClient postSetStorageItemForKey:key value:value session:self.session.sessionId error:error];
}

-(void) clearSessionStorage
{
    NSError *error;
    [self clearSessionStorageWithError:&error];
    [self addError:error];
}

-(void) clearSessionStorageWithError:(NSError**)error
{
    [self.jsonWireClient deleteStorage:self.session.sessionId error:error];
}

-(void) sessionStorageItemForKey:(NSString*)key
{
    NSError *error;
    [self sessionStorageItemForKey:key error:&error];
    [self addError:error];
}

-(void) sessionStorageItemForKey:(NSString*)key error:(NSError**)error
{
    [self.jsonWireClient getStorageItemForKey:key  session:self.session.sessionId error:error];
}

-(void) deleteStorageItemForKey:(NSString*)key
{
    NSError *error;
    [self deleteStorageItemForKey:key error:&error];
    [self addError:error];
}

-(void) deleteStorageItemForKey:(NSString*)key error:(NSError**)error
{
    [self.jsonWireClient deleteStorageItemForGivenKey:key session:self.session.sessionId error:error];
}

-(NSInteger) countOfItemsInStorage
{
    NSError *error;
    NSInteger numItems = [self countOfItemsInStorageWithError:&error];
    [self addError:error];
    return numItems;
}

-(NSInteger) countOfItemsInStorageWithError:(NSError**)error
{
    return [self.jsonWireClient getStorageSize:self.session.sessionId error:error];
}

-(NSArray*) getLogForType:(SELogType)type
{
    NSError *error;
    NSArray *logsForType = [self getLogForType:type error:&error];
    [self addError:error];
    return logsForType;
}

-(NSArray*) getLogForType:(SELogType)type error:(NSError**)error
{
    return [self.jsonWireClient  getLogForGivenLogType:type session:self.session.sessionId error:error];
}

-(NSArray*) allLogTypes
{
    NSError *error;
    NSArray *logTypes = [self allLogTypesWithError:&error];
    [self addError:error];
    return logTypes;
}

-(NSArray*) allLogTypesWithError:(NSError**)error
{
    return [self.jsonWireClient getLogTypes:self.session.sessionId error:error];
}

-(SEApplicationCacheStatus) applicationCacheStatus
{
    NSError* error;
    SEApplicationCacheStatus status = [self applicationCacheStatusWithError:&error];
	[self addError:error];
	return status;
}

-(SEApplicationCacheStatus) applicationCacheStatusWithError:(NSError**)error
{
    return [self.jsonWireClient getApplicationCacheStatusWithSession:self.session.sessionId error:error];
}


#pragma mark - 3.0 methods
/////////////////
// 3.0 METHODS //
/////////////////

-(void) shakeDevice {
    NSError *error;
    [self shakeDeviceWithError:&error];
    [self addError:error];
}

-(void) shakeDeviceWithError:(NSError**)error {
    [self.jsonWireClient postShakeDeviceWithSession:self.session.sessionId error:error];
}

-(void) lockDeviceScreen:(NSInteger)seconds {
    NSError *error;
    [self lockDeviceScreen:seconds error:&error];
    [self addError:error];
}

-(void) lockDeviceScreen:(NSInteger)seconds error:(NSError**)error {
    [self.jsonWireClient postLockDeviceWithSession:self.session.sessionId seconds:seconds error:error];
}

-(void) unlockDeviceScreen:(NSInteger)seconds {
    NSError *error;
    [self unlockDeviceScreen:seconds error:&error];
    [self addError:error];
}

-(void) unlockDeviceScreen:(NSInteger)seconds error:(NSError**)error {
    [self.jsonWireClient postUnlockDeviceWithSession:self.session.sessionId error:error];
}

-(BOOL) isDeviceLocked {
    NSError *error;
    BOOL locked = [self isDeviceLockedWithError:&error];
    [self addError:error];
    return locked;
}

-(BOOL) isDeviceLockedWithError:(NSError**)error {
    return [self.jsonWireClient postIsDeviceLockedWithSession:self.session.sessionId error:error];
}

-(void) pressKeycode:(NSInteger)keycode metaState:(NSInteger)metastate error:(NSError**)error {
    [self.jsonWireClient postPressKeycode:keycode metastate:metastate session:self.session.sessionId error:error];
}

-(void) longPressKeycode:(NSInteger)keycode metaState:(NSInteger)metastate error:(NSError**)error {
    [self.jsonWireClient postLongPressKeycode:keycode metastate:metastate session:self.session.sessionId error:error];
}

-(void) triggerKeyEvent:(NSInteger)keycode metaState:(NSInteger)metastate error:(NSError**)error {
    [self.jsonWireClient postKeyEvent:keycode metastate:metastate session:self.session.sessionId error:error];
}

-(void) rotateDevice:(SEScreenOrientation)orientation
{
    NSError *error;
    [self rotateDevice:orientation error:&error];
    [self addError:error];
}

-(void) rotateDevice:(SEScreenOrientation)orientation error:(NSError**)error {
    [self.jsonWireClient postRotate:orientation session:self.session.sessionId error:error];
}

-(NSString*)currentActivity
{
    NSError *error;
    NSString *currentActivity = [self currentActivityWithError:&error];
    [self addError:error];
    return currentActivity;
}

-(NSString*)currentActivityWithError:(NSError**)error {
    return [self.jsonWireClient getCurrentActivityForDeviceForSession:self.session.sessionId error:error];
}

-(void)installAppAtPath:(NSString*)appPath {
    NSError *error;
    [self installAppAtPath:appPath error:&error];
    [self addError:error];
}

-(void)installAppAtPath:(NSString*)appPath error:(NSError**)error {
    [self.jsonWireClient postInstallApp:appPath session:self.session.sessionId error:error];
}

-(void)removeApp:(NSString*)bundleId {
    NSError *error;
    [self removeApp:bundleId error:&error];
    [self addError:error];
}

-(void)removeApp:(NSString*)bundleId error:(NSError**)error {
    [self.jsonWireClient postRemoveApp:bundleId session:self.session.sessionId error:error];
}

-(BOOL)isAppInstalled:(NSString*)bundleId
{
    NSError *error;
    BOOL installed = [self isAppInstalled:bundleId error:&error];
    [self addError:error];
    return installed;
}

-(BOOL)isAppInstalled:(NSString*)bundleId error:(NSError**)error {
    return [self.jsonWireClient postIsAppInstalledWithBundleId:bundleId session:self.session.sessionId error:error];
}

-(void) hideKeyboard {
    NSError *error;
    [self hideKeyboardWithError:&error];
    [self addError:error];
}

-(void) hideKeyboardWithError:(NSError**)error {
    [self.jsonWireClient postHideKeyboardWithSession:self.session.sessionId error:error];
}

-(void) pushFileToPath:(NSString*)filePath data:(NSData*)data {
    NSError *error;
    [self pushFileToPath:filePath data:data error:&error];
    [self addError:error];
}

-(void) pushFileToPath:(NSString*)filePath data:(NSData*)data error:(NSError**) error {
    [self.jsonWireClient postPushFileToPath:filePath data:data session:self.session.sessionId error:error];
}

-(NSData*) pullFileAtPath:(NSString*)filePath {
    NSError *error;
    NSData *data = [self pullFileAtPath:filePath error:&error];
    [self addError:error];
    return data;
}

-(NSData*) pullFileAtPath:(NSString*)filePath error:(NSError**) error {
    return [self.jsonWireClient postPullFileAtPath:filePath session:self.session.sessionId error:error];
}


-(NSData*) pullFolderAtPath:(NSString*)filePath {
    NSError *error;
    NSData *data = [self pullFolderAtPath:filePath error:&error];
    [self addError:error];
    return data;
}

-(NSData*) pullFolderAtPath:(NSString*)filePath error:(NSError**) error {
    return [self.jsonWireClient postPullFolderAtPath:filePath session:self.session.sessionId error:error];
}

-(void) toggleAirplaneMode {
    NSError *error;
    [self toggleAirplaneModeWithError:&error];
    [self addError:error];
}

-(void) toggleAirplaneModeWithError:(NSError**)error {
    [self.jsonWireClient postToggleAirplaneModeWithSession:self.session.sessionId error:error];
}

-(void) toggleCellularData {
    NSError *error;
    [self toggleCellularDataWithError:&error];
    [self addError:error];
}

-(void) toggleCellularDataWithError:(NSError**)error {
    [self.jsonWireClient postToggleDataWithSession:self.session.sessionId error:error];
}

-(void) toggleWifi {
    NSError *error;
    [self toggleWifiWithError:&error];
    [self addError:error];
}

-(void) toggleWifiWithError:(NSError**)error {
    [self.jsonWireClient postToggleWifiWithSession:self.session.sessionId error:error];
}

-(void) toggleLocationServices {
    NSError *error;
    [self toggleLocationServicesWithError:&error];
    [self addError:error];
}

-(void) toggleLocationServicesWithError:(NSError**)error {
    [self.jsonWireClient postToggleLocationServicesWithSession:self.session.sessionId error:error];
}

-(void) openNotifications {
    NSError *error;
    [self openNotificationsWithError:&error];
    [self addError:error];
}

-(void) openNotificationsWithError:(NSError**)error {
    [self.jsonWireClient postOpenNotificationsWithSession:self.session.sessionId error:error];
}

-(void) startActivity:(NSString*)activity package:(NSString*)package {
    [self startActivity:activity package:package waitActivity:nil waitPackage:nil];
}

-(void) startActivity:(NSString*)activity package:(NSString*)package waitActivity:(NSString*)waitActivity waitPackage:(NSString*)waitPackage {
    NSError *error;
    [self startActivity:activity package:package waitActivity:waitActivity waitPackage:waitPackage error:&error];
    [self addError:error];
}

-(void) startActivity:(NSString*)activity package:(NSString*)package waitActivity:(NSString*)waitActivity waitPackage:(NSString*)waitPackage error:(NSError**)error {
    [self.jsonWireClient postStartActivity:activity package:package waitActivity:waitActivity waitPackage:waitPackage session:self.session.sessionId error:error];
}

-(void) launchApp
{
    NSError *error;
    [self launchAppWithError:&error];
    [self addError:error];
}

-(void) launchAppWithError:(NSError**)error
{
    [self.jsonWireClient postLaunchAppWithSession:self.session.sessionId error:error];
}

-(void) closeApp
{
    NSError *error;
    [self closeAppWithError:&error];
    [self addError:error];
}

-(void) closeAppWithError:(NSError**)error
{
    [self.jsonWireClient postCloseAppWithSession:self.session.sessionId error:error];
}

-(void) resetApp
{
    NSError *error;
    [self resetAppWithError:&error];
    [self addError:error];
}

-(void) resetAppWithError:(NSError**)error
{
    [self.jsonWireClient postResetAppWithSession:self.session.sessionId error:error];
}

-(void) runAppInBackground:(NSInteger)seconds
{
    NSError *error;
    [self runAppInBackground:seconds error:&error];
    [self addError:error];
}

-(void) runAppInBackground:(NSInteger)seconds error:(NSError**)error
{
    [self.jsonWireClient postRunAppInBackground:seconds session:self.session.sessionId error:error];
}

-(void) endTestCodeCoverage
{
    NSError *error;
    [self endTestCodeCoverageWithError:&error];
    [self addError:error];
}

-(void) endTestCodeCoverageWithError:(NSError**)error
{
    [self.jsonWireClient postEndTestCoverageWithSession:self.session.sessionId error:error];
}

-(NSString*)appStrings {
    return [self appStringsForLanguage:nil];
}

-(NSString*)appStringsForLanguage:(NSString *)languageCode
{
    NSError *error;
    NSString *strings = [self appStringsForLanguage:languageCode error:&error];
    [self addError:error];
    return strings;
}

-(NSString*)appStringsForLanguage:(NSString*)languageCode error:(NSError**)error {
    return [self.jsonWireClient getAppStringsForLanguage:languageCode session:self.session.sessionId error:error];
}

-(void) setAppiumSettings:(NSDictionary*)settings {
    NSError *error;
    [self setAppiumSettings:settings error:&error];
    [self addError:error];
}

-(void) setAppiumSettings:(NSDictionary*)settings error:(NSError**)error {
    [self.jsonWireClient postSetAppiumSettings:settings session:self.session.sessionId error:error];
}

-(NSDictionary*) appiumSettings {
    NSError *error;
    NSDictionary *settings = [self appiumSettingsWithError:&error];
    [self addError:error];
    return settings;
}

-(NSDictionary*) appiumSettingsWithError:(NSError**)error {
    return [self.jsonWireClient getAppiumSettingsWithSession:self.session.sessionId error:error];
}

@end
