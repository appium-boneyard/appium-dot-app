//
//  SEJsonWireClient.m
//  Selenium
//
//  Created by Dan Cuellar on 3/19/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "SEJsonWireClient.h"
#import "SEUtility.h"
#import "SEStatus.h"
#import "NSData+Base64.h"
#import "SETouchAction.h"
#import "SETouchActionCommand.h"


@interface SEJsonWireClient ()
	@property (readonly) NSString *httpCommandExecutor;
	@property NSString *serverAddress;
	@property NSInteger serverPort;
@end

@implementation SEJsonWireClient

-(id) initWithServerAddress:(NSString*)address port:(NSInteger)port error:(NSError**)error
{
    self = [super init];
    if (self) {
        [self setServerAddress:address];
        [self setServerPort:port];
        [self setErrors:[NSMutableArray new]];
		
        // get status
        [self getStatusAndReturnError:error];
        if ([*error code] != 0)
            return nil;
    }
    return self;
}

-(void)addError:(NSError*)error
{
    if (error == nil || error.code == 0)
        return;
    NSLog(@"Selenium Error: %ld - %@", error.code, error.description);
    [self setLastError:error];
    [self.errors addObject:error];
}

-(NSString*) httpCommandExecutor
{
    return [NSString stringWithFormat:@"http://%@:%d/wd/hub", self.serverAddress, (int)self.serverPort];
}

#pragma mark - JSON-Wire Protocol Implementation

// GET /status
-(SEStatus*) getStatusAndReturnError:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/status", self.httpCommandExecutor];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	SEStatus *webdriverStatus = [[SEStatus alloc] initWithDictionary:json];
	return webdriverStatus;
}

// POST /session
-(SESession*) postSessionWithDesiredCapabilities:(SECapabilities*)desiredCapabilities andRequiredCapabilities:(SECapabilities*)requiredCapabilities error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session", self.httpCommandExecutor];
	
	NSMutableDictionary *postDictionary = [NSMutableDictionary new];
	[postDictionary setValue:[desiredCapabilities dictionary] forKey:@"desiredCapabilities"];
	if (requiredCapabilities != nil)
	{
		[postDictionary setValue:[requiredCapabilities dictionary] forKey:@"requiredCapabilities"];
	}
	
	NSDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams:postDictionary error:error];
	SESession *session = [[SESession alloc] initWithDictionary:json];
	return session;
}

// GET /sessions
-(NSArray*) getSessionsAndReturnError:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/sessions", self.httpCommandExecutor];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	
	NSMutableArray *sessions = [NSMutableArray new];
	NSArray *jsonItems = (NSArray*)[json objectForKey:@"value"];
	for(int i =0; i < [jsonItems count]; i++)
	{
		SESession *session = [[SESession alloc] initWithDictionary:[jsonItems objectAtIndex:i]];
		[sessions addObject:session];
	}
	return sessions;
}

// GET /session/:sessionid/contexts
-(NSArray*) getContextsForSession:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/contexts", self.httpCommandExecutor, sessionId];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
    NSMutableArray *contexts = [NSMutableArray new];
    NSArray *jsonItems =(NSArray*)[json objectForKey:@"value"];
    for(int i=0; i < [jsonItems count]; i++)
    {
        NSString *context =[[NSString alloc] initWithString:(NSString*)[jsonItems objectAtIndex:i]];
        [contexts addObject:context];
    }
    return contexts;
}

// GET /session/:sessionid/context
-(NSString*) getContextForSession:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/context", self.httpCommandExecutor, sessionId];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
    return [json objectForKey:@"value"];
}

// POST /session/:sessionid/context
-(void) postContext:(NSString*)context session:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/context", self.httpCommandExecutor, sessionId];
    NSDictionary *postDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:context, @"context", nil];
    [SEUtility performPostRequestToUrl:urlString postParams:postDictionary error:error];
}

// GET /session/:sessionId
-(SESession*) getSessionWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@", self.httpCommandExecutor, sessionId];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	SESession *session = [[SESession alloc] initWithDictionary:json];
	return session;
}

// DELETE /session/:sessionId
-(void) deleteSessionWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@", self.httpCommandExecutor, sessionId];
	[SEUtility performDeleteRequestToUrl:urlString error:error];
}

// /session/:sessionId/timeouts
-(void) postTimeout:(NSInteger)timeoutInMilliseconds forType:(SETimeoutType)type session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/timeouts", self.httpCommandExecutor, sessionId];
    NSString *timeoutType = [SEEnums stringForTimeoutType:type];
	NSDictionary *postDictionary = [[NSDictionary alloc] initWithObjectsAndKeys: timeoutType, @"type", [NSString stringWithFormat:@"%d", ((int)timeoutInMilliseconds)], @"ms", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postDictionary error:error];
}

// POST /session/:sessionId/timeouts/async_script
-(void) postAsyncScriptWaitTimeout:(NSInteger)timeoutInMilliseconds session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/timeouts/async_script", self.httpCommandExecutor, sessionId];
	NSDictionary *postDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", ((int)timeoutInMilliseconds)], @"ms", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postDictionary error:error];
}

// POST /session/:sessionId/timeouts/implicit_wait
-(void) postImplicitWaitTimeout:(NSInteger)timeoutInMilliseconds session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/timeouts/implicit_wait", self.httpCommandExecutor, sessionId];
	NSDictionary *postDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", ((int)timeoutInMilliseconds)], @"ms", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postDictionary error:error];
}

// GET /session/:sessionId/window_handle
-(NSString*) getWindowHandleWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/window_handle", self.httpCommandExecutor, sessionId];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSString *handle = [[NSString alloc] initWithString:(NSString*)[json objectForKey:@"value"]];
	return handle;
}

// GET /session/:sessionId/window_handles
-(NSArray*) getWindowHandlesWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/window_handles", self.httpCommandExecutor, sessionId];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	
	NSMutableArray *handles = [NSMutableArray new];
	NSArray *jsonItems = (NSArray*)[json objectForKey:@"value"];
	for(int i =0; i < [jsonItems count]; i++)
	{
		NSString *handle = [[NSString alloc] initWithString:(NSString*)[jsonItems objectAtIndex:i]];
		[handles addObject:handle];
	}
	return handles;
}

// GET /session/:sessionId/url
-(NSURL*) getURLWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/url", self.httpCommandExecutor, sessionId];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSString *url = [json objectForKey:@"value"];
	return [[NSURL alloc] initWithString:url];
}

// POST /session/:sessionId/url
-(void) postURL:(NSURL*)url session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/url", self.httpCommandExecutor, sessionId];
	NSDictionary *postDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[url absoluteString], @"url", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postDictionary error:error];
}

// POST /session/:sessionId/forward
-(void) postForwardWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/forward", self.httpCommandExecutor, sessionId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/back
-(void) postBackWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/back", self.httpCommandExecutor, sessionId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/refresh
-(void) postRefreshWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/refresh", self.httpCommandExecutor, sessionId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/execute
-(NSDictionary*) postExecuteScript:(NSString*)script arguments:(NSArray*)arguments session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/execute", self.httpCommandExecutor, sessionId];
	NSMutableDictionary *postParams = [NSMutableDictionary new];
	[postParams setObject:script forKey:@"script"];
	if (arguments == nil || arguments.count < 1)
	{
		arguments = [NSArray new];
	}
	[postParams setObject:arguments forKey:@"args"];
	return [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/execute_async
-(NSDictionary*) postExecuteAsyncScript:(NSString*)script arguments:(NSArray*)arguments session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/execute_async", self.httpCommandExecutor, sessionId];
	NSMutableDictionary *postParams = [NSMutableDictionary new];
	[postParams setObject:script forKey:@"script"];
	if (arguments == nil || arguments.count < 1)
	{
		arguments = [NSArray new];
	}
	[postParams setObject:arguments forKey:@"args"];
	return [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// GET /session/:sessionId/screenshot
-(IMAGE_TYPE*) getScreenshotWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/screenshot", self.httpCommandExecutor, sessionId];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSString *pngString = [json objectForKey:@"value"];
	NSData *pngData = [NSData dataFromBase64String:pngString];
	IMAGE_TYPE *image = [[IMAGE_TYPE alloc] initWithData:pngData];
	return image;
}

// GET /session/:sessionId/ime/available_engines
-(NSArray*) getAvailableInputMethodEnginesWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/ime/available_engines", self.httpCommandExecutor, sessionId];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSArray *jsonItems = (NSArray*)[json objectForKey:@"value"];
	NSMutableArray *engines = [NSMutableArray new];
	for (int i=0; i < [jsonItems count]; i++)
	{
		NSString *engine = [jsonItems objectAtIndex:i];
		[engines addObject:engine];
	}
	return engines;
}

// GET /session/:sessionId/ime/active_engine
-(NSString*) getActiveInputMethodEngineWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/ime/active_engine", self.httpCommandExecutor, sessionId];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSString *activeEngine = [json objectForKey:@"value"];
	return activeEngine;
}

// GET /session/:sessionId/ime/activated
-(BOOL) getInputMethodEngineIsActivatedWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/ime/activated", self.httpCommandExecutor, sessionId];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	BOOL isActivated = [[json objectForKey:@"value"] boolValue];
	return isActivated;
}

// POST /session/:sessionId/ime/deactivate
-(void) postDeactivateInputMethodEngineWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/ime/deactivate", self.httpCommandExecutor, sessionId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/ime/activate
-(void) postActivateInputMethodEngine:(NSString*)engine session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/ime/activate", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: engine, @"engine", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/frame
-(void) postSetFrame:(id)name session:(NSString*)sessionId error:(NSError**)error
{
	if ([name isKindOfClass:[SEWebElement class]])
	{
		name = (SEWebElement*)[name elementJson];
	}
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/frame", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: name, @"name", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/window
-(void) postSetWindow:(NSString*)windowHandle session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/window", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: windowHandle, @"name", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// DELETE /session/:sessionId/window
-(void) deleteWindowWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/window", self.httpCommandExecutor, sessionId];
	[SEUtility performDeleteRequestToUrl:urlString error:error];
}

// POST /session/:sessionId/window/:windowHandle/size
-(void) postSetWindowSize:(SIZE_TYPE)size window:(NSString*)windowHandle session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/window/%@/size", self.httpCommandExecutor, sessionId, windowHandle];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt:(size.width/1)], @"width", [NSNumber numberWithInt:(size.height/1)], @"height", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// GET /session/:sessionId/window/:windowHandle/size
-(SIZE_TYPE) getWindowSizeWithWindow:(NSString*)windowHandle session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/window/%@/size", self.httpCommandExecutor, sessionId, windowHandle];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSDictionary *valueJson = [json objectForKey:@"value"];
	float width = [[valueJson objectForKey:@"width"] floatValue];
	float height = [[valueJson objectForKey:@"height"] floatValue];
	SIZE_TYPE size = SIZE_TYPE_MAKE(width,height);
	return size;
}

// POST /session/:sessionId/window/:windowHandle/position
-(void) postSetWindowPosition:(POINT_TYPE)position window:(NSString*)windowHandle session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/window/%@/position", self.httpCommandExecutor, sessionId, windowHandle];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt:(position.x / 1)], @"x", [NSNumber numberWithInt:(position.y/1)], @"y", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// GET /session/:sessionId/window/:windowHandle/position
-(POINT_TYPE) getWindowPositionWithWindow:(NSString*)windowHandle session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/window/%@/position", self.httpCommandExecutor, sessionId, windowHandle];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSDictionary *valueJson = [json objectForKey:@"value"];
	float x = [[valueJson objectForKey:@"x"] floatValue];
	float y = [[valueJson objectForKey:@"y"] floatValue];
	POINT_TYPE position = POINT_TYPE_MAKE(x,y);
	return position;
}

// POST /session/:sessionId/window/:windowHandle/maximize
-(void) postMaximizeWindow:(NSString*)windowHandle session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/window/%@/maximize", self.httpCommandExecutor, sessionId, windowHandle];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}


// GET /session/:sessionId/cookie
-(NSArray*) getCookiesWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/cookie", self.httpCommandExecutor, sessionId];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSArray *jsonItems = (NSArray*)[json objectForKey:@"value"];
	NSMutableArray *cookies = [NSMutableArray new];
	for (int i=0; i < [jsonItems count]; i++)
	{
		NSMutableDictionary *cookieInfo = (NSMutableDictionary*)[jsonItems objectAtIndex:i];
		NSHTTPCookie *cookie = [SEUtility cookieWithJson:cookieInfo];
		[cookies addObject:cookie];
	}
	return cookies;
}

// POST /session/:sessionId/cookie
-(void) postCookie:(NSHTTPCookie*)cookie session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/cookie", self.httpCommandExecutor, sessionId];
	NSMutableDictionary *cookieJson = [NSMutableDictionary new];
	[cookieJson setObject:cookie.name forKey:@"name"];
	[cookieJson setObject:cookie.value forKey:@"value"];
	[cookieJson setObject:cookie.path forKey:@"path"];
	[cookieJson setObject:cookie.domain forKey:@"domain"];
	[cookieJson setObject:[NSNumber numberWithBool:cookie.isSecure] forKey:@"secure"];
	[cookieJson setObject:[NSNumber numberWithDouble:[cookie.expiresDate timeIntervalSince1970]] forKey:@"expiry"];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys:cookieJson, @"cookie", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// DELETE /session/:sessionId/cookie
-(void) deleteCookiesWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/cookie", self.httpCommandExecutor, sessionId];
	[SEUtility performDeleteRequestToUrl:urlString error:error];
}

// DELETE /session/:sessionId/cookie/:name
-(void) deleteCookie:(NSString*)cookieName session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/cookie/%@", self.httpCommandExecutor, sessionId, cookieName];
	[SEUtility performDeleteRequestToUrl:urlString error:error];
}

// GET /session/:sessionId/source
-(NSString*) getSourceWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/source", self.httpCommandExecutor, sessionId];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSString *source = [json objectForKey:@"value"];
	return source;
}

// GET /session/:sessionId/title
-(NSString*) getTitleWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/title", self.httpCommandExecutor, sessionId];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSString *title = [json objectForKey:@"value"];
	return title;
}

// POST /session/:sessionId/element
-(SEWebElement*) postElement:(SEBy*)locator session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys:[locator locationStrategy], @"using", [locator value], @"value", nil];
	NSDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
	NSString *elementId = [[json objectForKey:@"value"] objectForKey:@"ELEMENT"];
	SEWebElement *element = [[SEWebElement alloc] initWithOpaqueId:elementId jsonWireClient:self session:sessionId];
	return element;
}

// POST /session/:sessionId/elements
-(NSArray*) postElements:(SEBy*)locator session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/elements", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys:[locator locationStrategy], @"using", [locator value], @"value", nil];
	NSDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
	NSArray *matches = (NSArray*)[json objectForKey:@"value"];
	NSMutableArray *elements = [NSMutableArray new];
	for (int i=0; i < [matches count]; i++)
	{
		NSString *elementId = [[matches objectAtIndex:i] objectForKey:@"ELEMENT"];
		SEWebElement *element = [[SEWebElement alloc] initWithOpaqueId:elementId jsonWireClient:self session:sessionId];
		[elements addObject:element];
	}
	return elements;
}

// POST /session/:sessionId/element/active
-(SEWebElement*) postActiveElementWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/active", self.httpCommandExecutor, sessionId];
	NSDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
	NSString *elementId = [[json objectForKey:@"value"] objectForKey:@"ELEMENT"];
	SEWebElement *element = [[SEWebElement alloc] initWithOpaqueId:elementId jsonWireClient:self session:sessionId];
	return element;
}

// /session/:sessionId/element/:id (FUTURE)
//
// IMPLEMENT ME
//
//

// POST /session/:sessionId/element/:id/element
-(SEWebElement*) postElementFromElement:(SEWebElement*)element by:(SEBy*)locator session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/elements", self.httpCommandExecutor, sessionId, element.opaqueId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys:[locator locationStrategy], @"using", [locator value], @"value", nil];
	NSDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
	NSString *elementId = [[json objectForKey:@"value"] objectForKey:@"ELEMENT"];
	SEWebElement *foundElement = [[SEWebElement alloc] initWithOpaqueId:elementId jsonWireClient:self session:sessionId];
	return foundElement;
}
// POST /session/:sessionId/element/:id/elements
-(NSArray*) postElementsFromElement:(SEWebElement*)element by:(SEBy*)locator session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/elements", self.httpCommandExecutor, sessionId, element.opaqueId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys:[locator locationStrategy], @"using", [locator value], @"value", nil];
	NSDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
	NSArray *matches = (NSArray*)[json objectForKey:@"value"];
	NSMutableArray *elements = [NSMutableArray new];
	for (int i=0; i < [matches count]; i++)
	{
		NSString *elementId = [[matches objectAtIndex:i] objectForKey:@"ELEMENT"];
		SEWebElement *element = [[SEWebElement alloc] initWithOpaqueId:elementId jsonWireClient:self session:sessionId];
		[elements addObject:element];
	}
	return elements;
}

// POST /session/:sessionId/element/:id/click
-(void) postClickElement:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/click", self.httpCommandExecutor, sessionId, element.opaqueId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/element/:id/submit
-(void) postSubmitElement:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/submit", self.httpCommandExecutor, sessionId, element.opaqueId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// GET /session/:sessionId/element/:id/text
-(NSString*) getElementText:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/text", self.httpCommandExecutor, sessionId, element.opaqueId];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSString *text = [json objectForKey:@"value"];
	return text;
}

// POST /session/:sessionId/element/:id/value
-(void) postKeys:(unichar *)keys element:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/value", self.httpCommandExecutor, sessionId, element.opaqueId];
	NSMutableArray *keyArray = [NSMutableArray new];
	for(int i=0; keys[i] != '\0'; i++)
	{
		[keyArray addObject:[NSString stringWithFormat:@"%C", keys[i]]];
	}
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: keyArray, @"value", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/keys
-(void) postKeys:(unichar *)keys session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/keys", self.httpCommandExecutor, sessionId];
	NSMutableArray *keyArray = [NSMutableArray new];
	for(int i=0; keys[i] != '\0'; i++)
	{
		[keyArray addObject:[NSString stringWithFormat:@"%C", keys[i]]];
	}
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: keyArray, @"value", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// GET /session/:sessionId/element/:id/name
-(NSString*) getElementName:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/name", self.httpCommandExecutor, sessionId, element.opaqueId];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSString *name = [json objectForKey:@"value"];
	return name;
}

// POST /session/:sessionId/element/:id/clear
-(void) postClearElement:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/clear", self.httpCommandExecutor, sessionId, element.opaqueId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// GET /session/:sessionId/element/:id/selected
-(BOOL) getElementIsSelected:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/selected", self.httpCommandExecutor, sessionId, element.opaqueId];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	BOOL isSelected = [[json objectForKey:@"value"] boolValue];
	return isSelected;
}

// GET /session/:sessionId/element/:id/enabled
-(BOOL) getElementIsEnabled:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/enabled", self.httpCommandExecutor, sessionId, element.opaqueId];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	BOOL isEnabled = [[json objectForKey:@"value"] boolValue];
	return isEnabled;
}

// GET /session/:sessionId/element/:id/attribute/:name
-(NSString*) getAttribute:(NSString*)attributeName element:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/attribute/%@", self.httpCommandExecutor, sessionId, element.opaqueId, attributeName];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSString *value = [json objectForKey:@"value"];
	return value;
}

// GET /session/:sessionId/element/:id/equals/:other
-(BOOL) getEqualityForElement:(SEWebElement*)element element:(SEWebElement*)otherElement session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/equals/%@", self.httpCommandExecutor, sessionId, element.opaqueId,[otherElement opaqueId]];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	BOOL isEqual = [[json objectForKey:@"value"] boolValue];
	return isEqual;
}

// GET /session/:sessionId/element/:id/displayed
-(BOOL) getElementIsDisplayed:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/displayed", self.httpCommandExecutor, sessionId, element.opaqueId];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	BOOL isDisplayed = [[json objectForKey:@"value"] boolValue];
	return isDisplayed;
}

// GET /session/:sessionId/element/:id/location
-(POINT_TYPE) getElementLocation:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/location", self.httpCommandExecutor, sessionId, element.opaqueId];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSDictionary *valueJson = [json objectForKey:@"value"];
	float x = [[valueJson objectForKey:@"x"] floatValue];
	float y = [[valueJson objectForKey:@"y"] floatValue];
	POINT_TYPE point = POINT_TYPE_MAKE(x,y);
	return point;
}

// GET /session/:sessionId/element/:id/location_in_view
-(POINT_TYPE) getElementLocationInView:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/location_in_view", self.httpCommandExecutor, sessionId, element.opaqueId];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSDictionary *valueJson = [json objectForKey:@"value"];
	float x = [[valueJson objectForKey:@"x"] floatValue];
	float y = [[valueJson objectForKey:@"y"] floatValue];
	POINT_TYPE point = POINT_TYPE_MAKE(x,y);
	return point;
}

// GET /session/:sessionId/element/:id/size
-(SIZE_TYPE) getElementSize:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/size", self.httpCommandExecutor, sessionId, element.opaqueId];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSDictionary *valueJson = [json objectForKey:@"value"];
	float x = [[valueJson objectForKey:@"width"] floatValue];
	float y = [[valueJson objectForKey:@"height"] floatValue];
	SIZE_TYPE size = SIZE_TYPE_MAKE(x,y);
	return size;
}

// GET /session/:sessionId/element/:id/css/:propertyName
-(NSString*) getCSSProperty:(NSString*)propertyName element:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/css/%@", self.httpCommandExecutor, sessionId, element.opaqueId, propertyName];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSString *value = [json objectForKey:@"value"];
	return value;
}

// GET /session/:sessionId/orientation
-(SEScreenOrientation) getOrientationWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/orientation", self.httpCommandExecutor, sessionId];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	if ([*error code] != 0)
		return SELENIUM_SCREEN_ORIENTATION_UNKOWN;
	NSString *value = [json objectForKey:@"value"];
	return ([value isEqualToString:@"LANDSCAPE"] ? SELENIUM_SCREEN_ORIENTATION_LANDSCAPE : SELENIUM_SCREEN_ORIENTATION_PORTRAIT);
}

// POST /session/:sessionId/orientation
-(void) postOrientation:(SEScreenOrientation)orientation session:(NSString*)sessionId error:(NSError**)error
{
	if (orientation == SELENIUM_SCREEN_ORIENTATION_UNKOWN)
		return;
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/orientation", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys:(orientation == SELENIUM_SCREEN_ORIENTATION_LANDSCAPE) ? @"LANDSCAPE" : @"PORTRAIT" , @"orientation", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// GET /session/:sessionId/alert_text
-(NSString*) getAlertTextWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/alert_text", self.httpCommandExecutor, sessionId];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSString *alertText = [json objectForKey:@"value"];
	return alertText;
}

// POST /session/:sessionId/alert_text
-(void) postAlertText:(NSString*)text session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/alert_text", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: text, @"text", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/accept_alert
-(void) postAcceptAlertWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/accept_alert", self.httpCommandExecutor, sessionId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/dismiss_alert
-(void) postDismissAlertWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/dismiss_alert", self.httpCommandExecutor, sessionId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/moveto
-(void) postMoveMouseToElement:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/move_to", self.httpCommandExecutor, sessionId];
	NSMutableDictionary *postParams = [NSMutableDictionary new];
	if (element != nil)
	{
		[postParams setObject:element.opaqueId forKey:@"element"];
	}
	[postParams setObject:[NSNumber numberWithInteger:xOffset] forKey:@"xoffset"];
	[postParams setObject:[NSNumber numberWithInteger:yOffset] forKey:@"yoffset"];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/click
-(void) postClickMouseButton:(SEMouseButton)button session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/click", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInteger:[SEEnums intForMouseButton:button]] , @"button", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/buttondown
-(void) postMouseButtonDown:(SEMouseButton)button session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/buttondown", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInteger:[SEEnums intForMouseButton:button]] , @"button", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/buttonup
-(void) postMouseButtonUp:(SEMouseButton)button session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/buttonup", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInteger:[SEEnums intForMouseButton:button]] , @"button", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/doubleclick
-(void) postDoubleClickWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/doubleclick", self.httpCommandExecutor, sessionId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/touch/click
-(void) postTapElement:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/touch/click", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: element.opaqueId, @"element", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/touch/down
-(void) postFingerDownAt:(POINT_TYPE)point session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/touch/down", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt:(int)point.x] , @"x", [NSNumber numberWithInt:(int)point.y] , @"y", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/touch/up
-(void) postFingerUpAt:(POINT_TYPE)point session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/touch/up", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt:(int)point.x] , @"x", [NSNumber numberWithInt:(int)point.y] , @"y", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/touch/move
-(void) postMoveFingerTo:(POINT_TYPE)point session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/touch/move", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt:(int)point.x] , @"x", [NSNumber numberWithInt:(int)point.y] , @"y", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/touch/scroll
-(void) postStartScrollingAtParticularLocation:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset session:(NSString*)sessionId error:(NSError**)error
{
	    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/touch/scroll", self.httpCommandExecutor,sessionId];
        NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: element.opaqueId , @"element", [NSNumber numberWithInteger:xOffset] , @"xoffset", [NSNumber numberWithInteger:yOffset] , @"yoffset", nil];
	    [SEUtility performPostRequestToUrl: urlString postParams:postParams error:error];
}

// POST /session/:sessionId/touch/scroll
-(void) postScrollfromAnywhereOnTheScreenWithSession:(POINT_TYPE)point session:(NSString*)sessionId error:(NSError**)error
{
	    NSString *urlString =[NSString stringWithFormat:@"%@/session/%@/touch/scroll", self.httpCommandExecutor, sessionId];
	    NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:(int)point.x], @"x" ,[NSNumber numberWithInt:(int)point.y],@"y",nil];
	  [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}


// POST /session/:sessionId/touch/doubleclick
-(void) postDoubleTapElement:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/touch/doubleclick", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: element.opaqueId, @"element", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/touch/longclick
-(void) postPressElement:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/touch/longclick", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: element.opaqueId, @"element", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/touch/perform
-(void) postTouchAction:(SETouchAction *)touchAction session:(NSString*)sessionId error:(NSError**)error
{

	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/touch/perform", self.httpCommandExecutor, sessionId];

	NSMutableArray *actionsJson = [NSMutableArray array];
	for (SETouchActionCommand *command in touchAction.commands) {
		NSDictionary *action = @{
				@"action": command.name,
				@"options": [command.options copy]
		};
		[actionsJson addObject:action];
	}

	NSDictionary *postParams = @{@"actions": actionsJson};
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}


// POST /session/:sessionId/touch/flick
-(void) postFlickFromParticularLocation:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset  speed:(NSInteger)speed session:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/touch/flick", self.httpCommandExecutor,sessionId];
    NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: element.opaqueId , @"element", [NSNumber numberWithInteger:xOffset] , @"xoffset", [NSNumber numberWithInteger:yOffset] , @"yoffset", [NSNumber numberWithInteger:speed] , @"speed",nil];
    [SEUtility performPostRequestToUrl: urlString postParams:postParams error:error];
}

// POST /session/:sessionId/touch/flick
-(void) postFlickFromAnywhere:(NSInteger)xSpeed ySpeed:(NSInteger)ySpeed session:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/touch/flick", self.httpCommandExecutor,sessionId];
    NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:xSpeed] , @"xSpeed", [NSNumber numberWithInteger:ySpeed] , @"ySpeed",nil];
    [SEUtility performPostRequestToUrl: urlString postParams:postParams error:error];
}


// GET /session/:sessionId/location
-(SELocation*) getLocationAndReturnError:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/location", self.httpCommandExecutor,sessionId];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	SELocation *currentGeoLocation = [[SELocation alloc] initWithDictionary:json];
	return currentGeoLocation ;
}

// POST /session/:sessionId/location
-(void) postLocation:(SELocation*)location session:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/location", self.httpCommandExecutor,sessionId];
    NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: location, @"location", nil];
    [SEUtility performPostRequestToUrl: urlString postParams:postParams error:error];
}


// GET /session/:sessionId/local_storage
-(NSArray*) getAllLocalStorageKeys:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString =[NSString stringWithFormat:@"%@/session/%@/local_storage",self.httpCommandExecutor,sessionId];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
    NSMutableArray *keysList = [NSMutableArray new];
    NSArray *jsonItems = (NSArray*)[json objectForKey:@"value"];
    for(int i =0; i < [jsonItems count]; i++)
    {
        NSString *key = [[NSString alloc] initWithString:(NSString*)[jsonItems objectAtIndex:i]];
        [keysList addObject:key];
    }
    
    return keysList;
}

//POST /session/:sessionId/local_storage
-(void) postSetLocalStorageItemForKey:(NSString*)key value:(NSString*)value session:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString =[NSString stringWithFormat:@"%@/session/%@/local_storage",self.httpCommandExecutor,sessionId];
    NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys:key, @"key",value, @"value", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
    
}

// DELETE /session/:sessionId/local_storage
-(void) deleteLocalStorage:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString =[NSString stringWithFormat:@"%@/session/%@/local_storage",self.httpCommandExecutor,sessionId];
    [SEUtility performDeleteRequestToUrl:urlString error:error];
}

// GET /session/:sessionId/local_storage/key/:key
-(void) getLocalStorageItemForKey:(NSString*)key session:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString =[NSString stringWithFormat:@"%@/session/%@/local_storage/key/%@",self.httpCommandExecutor,sessionId,key];
    [SEUtility performGetRequestToUrl:urlString error:error];
}

//DELETE /session/:sessionId/local_storage/key/:key
-(void) deleteLocalStorageItemForGivenKey:(NSString*)key session:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString=[NSString stringWithFormat:@"%@/session/%@/local_storage/key/%@",self.httpCommandExecutor,sessionId,key];
    [SEUtility performDeleteRequestToUrl:urlString error:error];
}

// GET /session/:sessionId/local_storage/size
-(NSInteger) getLocalStorageSize:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString=[NSString stringWithFormat:@"%@/session/%@/local_storage/size",self.httpCommandExecutor,sessionId];
    NSDictionary *json=[SEUtility performGetRequestToUrl:urlString error:error];
    NSInteger numOfItemsInLocalStorage = [[json objectForKey:@"value"] integerValue];
    return numOfItemsInLocalStorage;
}

// GET /session/:sessionId/session_storage
-(NSArray*) getAllStorageKeys:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString =[NSString stringWithFormat:@"%@/session/%@/session_storage",self.httpCommandExecutor,sessionId];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];        
    NSMutableArray *keysList = [NSMutableArray new];
    NSArray *jsonItems = (NSArray*)[json objectForKey:@"value"];
        for(int i =0; i < [jsonItems count]; i++)
        {
            NSString *key = [[NSString alloc] initWithString:(NSString*)[jsonItems objectAtIndex:i]];
            [keysList addObject:key];
        }

    return keysList;
}

// POST /session/:sessionId/session_storage
-(void) postSetStorageItemForKey:(NSString*)key value:(NSString*)value session:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString =[NSString stringWithFormat:@"%@/session/%@/session_storage",self.httpCommandExecutor,sessionId];
    NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys:key, @"key",value, @"value", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];

}

// DELETE /session/:sessionId/session_storage
-(void) deleteStorage:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString =[NSString stringWithFormat:@"%@/session/%@/session_storage",self.httpCommandExecutor,sessionId];
    [SEUtility performDeleteRequestToUrl:urlString error:error];
}

// GET /session/:sessionId/session_storage/key/:key
-(void) getStorageItemForKey:(NSString*)key session:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString =[NSString stringWithFormat:@"%@/session/%@/session_storage/key/%@",self.httpCommandExecutor,sessionId,key];
    [SEUtility performGetRequestToUrl:urlString error:error];
}

//DELETE /session/:sessionId/session_storage/key/:key
-(void) deleteStorageItemForGivenKey:(NSString*)key session:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString=[NSString stringWithFormat:@"%@/session/%@/session_storage/key/%@",self.httpCommandExecutor,sessionId,key];
    [SEUtility performDeleteRequestToUrl:urlString error:error];
}


// GET /session/:sessionId/session_storage/size
-(NSInteger) getStorageSize:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString=[NSString stringWithFormat:@"%@/session/%@/session_storage/size",self.httpCommandExecutor,sessionId];
    NSDictionary *json=[SEUtility performGetRequestToUrl:urlString error:error];
    NSInteger numOfItemsInStorage = [[json objectForKey:@"value"] integerValue];
    return numOfItemsInStorage;
}


// POST /session/:sessionId/log
-(NSArray*) getLogForGivenLogType:(SELogType)type session:(NSString*)sessionId error:(NSError**)error
{
    NSString  *urlString = [NSString stringWithFormat:@"%@/session/%@/log",self.httpCommandExecutor,sessionId];
    NSString *logType = [SEEnums stringForLogType:type];
    NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys:logType,@"type", nil];
    NSDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
    NSMutableArray *logEntries =[NSMutableArray new];
    NSArray *jsonItems = (NSArray*)[json objectForKey:@"value"];
    for(int i=0; i < [jsonItems count]; i++)
    {
        NSString *logEntry =[[NSString alloc] initWithString:(NSString*)[jsonItems objectAtIndex:i]];
        [logEntries addObject:logEntry];
    }
    return logEntries;
}


// GET /session/:sessionId/log/types
-(NSArray*) getLogTypes:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/log/types",self.httpCommandExecutor,sessionId];
    NSDictionary *json =[SEUtility performGetRequestToUrl:urlString error:error];
    NSMutableArray *logTypes = [NSMutableArray new];
    NSArray *jsonItems =(NSArray*)[json objectForKey:@"value"];
    for(int i=0; i < [jsonItems count]; i++)
    {
        NSString *logType =[[NSString alloc] initWithString:(NSString*)[jsonItems objectAtIndex:i]];
        [logTypes addObject:logType];
    }
    return logTypes;    
}


// GET /session/:sessionId/application_cache/status
-(SEApplicationCacheStatus) getApplicationCacheStatusWithSession:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/application_cache/status", self.httpCommandExecutor, sessionId];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	 NSInteger appCacheStatus = [[json objectForKey:@"value"] integerValue];
    return [SEEnums applicationCacheStatusWithInt:appCacheStatus];
}


#pragma mark - 3.0 methods
  /////////////////
 // 3.0 METHODS //
/////////////////

// POST /wd/hub/session/:sessionId/appium/device/shake
-(void) postShakeDeviceWithSession:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/device/shake", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /wd/hub/session/:sessionId/appium/device/lock
-(void) postLockDeviceWithSession:(NSString*)sessionId seconds:(NSInteger)seconds error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/device/lock", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:@{@"seconds" : [NSNumber numberWithInteger:seconds]} error:error];
}

// POST /wd/hub/session/:sessionId/appium/device/unlock
-(void) postUnlockDeviceWithSession:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/device/unlock", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /wd/hub/session/:sessionId/appium/device/is_locked
-(BOOL) postIsDeviceLockedWithSession:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/device/is_locked", self.httpCommandExecutor, sessionId];
    NSDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
    return [[json objectForKey:@"value"] boolValue];
}

// POST /wd/hub/session/:sessionId/appium/device/press_keycode
-(void) postPressKeycode:(NSInteger)keycode metastate:(NSInteger)metaState session:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/device/press_keycode", self.httpCommandExecutor, sessionId];
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:keycode], @"keycode", nil];
    if (metaState > 0) {
        [postParams setObject:[NSNumber numberWithInteger:metaState] forKey:@"metastate"];
    }
    [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}


// POST /wd/hub/session/:sessionId/appium/device/long_press_keycode
-(void) postLongPressKeycode:(NSInteger)keycode metastate:(NSInteger)metaState session:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/device/long_press_keycode", self.httpCommandExecutor, sessionId];
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:keycode], @"keycode", nil];
    if (metaState > 0) {
        [postParams setObject:[NSNumber numberWithInteger:metaState] forKey:@"metastate"];
    }
    [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /wd/hub/session/:sessionId/appium/device/keyevent
-(void) postKeyEvent:(NSInteger)keycode metastate:(NSInteger)metaState session:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/device/keyevent", self.httpCommandExecutor, sessionId];
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:keycode], @"keycode", nil];
    if (metaState > 0) {
        [postParams setObject:[NSNumber numberWithInteger:metaState] forKey:@"metastate"];
    }
    [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/appium/app/rotate
- (void)postRotate:(SEScreenOrientation)orientation session:(NSString*)sessionId error:(NSError **)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/device/rotate", self.httpCommandExecutor, sessionId];
    NSDictionary *postDictionary = @{@"orientation" : orientation == SELENIUM_SCREEN_ORIENTATION_LANDSCAPE ? @"LANDSCAPE" : @"PORTRAIT" };
    [SEUtility performPostRequestToUrl:urlString postParams:postDictionary error:error];
}

// GET /wd/hub/session/:sessionId/appium/device/current_activity
-(NSString*) getCurrentActivityForDeviceForSession:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/device/current_activity", self.httpCommandExecutor, sessionId];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
    return [json objectForKey:@"value"];
}

// POST /wd/hub/session/:sessionId/appium/device/install_app
- (void)postInstallApp:(NSString*)appPath session:(NSString*)sessionId error:(NSError **)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/device/install_app", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:@{@"appPath" : appPath } error:error];
}

// POST /wd/hub/session/:sessionId/appium/device/remove_app
- (void)postRemoveApp:(NSString*)bundleId session:(NSString*)sessionId error:(NSError **)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/device/remove_app", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:@{@"bundleId" : bundleId } error:error];
}

// POST /wd/hub/session/:sessionId/appium/device/app_installed
-(BOOL) postIsAppInstalledWithBundleId:(NSString*)bundleId session:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/device/app_installed", self.httpCommandExecutor, sessionId];
    NSDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams: @{ @"bundleId" : bundleId } error:error];
    return [[json objectForKey:@"value"] boolValue];
}

// POST /wd/hub/session/:sessionId/appium/device/hide_keyboard
-(void) postHideKeyboardWithSession:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/device/hide_keyboard", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /wd/hub/session/:sessionId/appium/device/push_file
- (void)postPushFileToPath:(NSString*)path data:(NSData*)data session:(NSString*)sessionId error:(NSError **)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/device/push_file", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:@{@"path" : path, @"data": [data base64EncodedString]} error:error];
}

// POST /wd/hub/session/:sessionId/appium/device/pull_file
-(NSData*) postPullFileAtPath:(NSString*)path session:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/device/pull_file", self.httpCommandExecutor, sessionId];
    NSDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams: @{ @"path" : path } error:error];
    return [NSData dataFromBase64String:(NSString*)[json objectForKey:@"value"]];
}

// POST /wd/hub/session/:sessionId/appium/device/pull_folder
-(NSData*) postPullFolderAtPath:(NSString*)path session:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/device/pull_folder", self.httpCommandExecutor, sessionId];
    NSDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams: @{ @"path" : path } error:error];
    return [NSData dataFromBase64String:(NSString*)[json objectForKey:@"value"]];
}

// POST /wd/hub/session/:sessionId/appium/device/toggle_airplane_mode
-(void) postToggleAirplaneModeWithSession:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/device/toggle_airplane_mode", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /wd/hub/session/:sessionId/appium/device/toggle_data
-(void) postToggleDataWithSession:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/device/toggle_data", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /wd/hub/session/:sessionId/appium/device/toggle_wifi
-(void) postToggleWifiWithSession:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/device/toggle_wifi", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /wd/hub/session/:sessionId/appium/device/toggle_location_services
-(void) postToggleLocationServicesWithSession:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/device/toggle_location_services", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /wd/hub/session/:sessionId/appium/device/open_notifications
-(void) postOpenNotificationsWithSession:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/device/open_notifications", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /wd/hub/session/:sessionId/appium/device/start_activity
-(void) postStartActivity:(NSString*)activity package:(NSString*)package waitActivity:(NSString*)waitActivity waitPackage:(NSString*)waitPackage session:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/device/start_activity", self.httpCommandExecutor, sessionId];
    NSMutableDictionary *postParams = [NSMutableDictionary new];
    [postParams setObject:activity forKey:@"appActivity"];
    [postParams setObject:package forKey:@"appPackage"];
    if (waitActivity != nil ) { [postParams setObject:waitActivity forKey:@"appWaitActivity"]; }
    if (waitPackage != nil ) { [postParams setObject:waitPackage forKey:@"appWaitPackage"]; }
    
    [SEUtility performPostRequestToUrl:urlString postParams: postParams error:error];
}

// POST /session/:sessionId/appium/app/launch
- (void)postLaunchAppWithSession:(NSString *)sessionId error:(NSError **)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/app/launch", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/appium/app/close
- (void)postCloseAppWithSession:(NSString *)sessionId error:(NSError **)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/app/close", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/appium/app/reset
- (void)postResetAppWithSession:(NSString *)sessionId error:(NSError **)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/app/reset", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/appium/app/background
- (void)postRunAppInBackground:(NSInteger)seconds session:(NSString *)sessionId error:(NSError **)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/app/background", self.httpCommandExecutor, sessionId];
    NSDictionary *postDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:seconds], @"seconds", nil];
    [SEUtility performPostRequestToUrl:urlString postParams:postDictionary error:error];
}

// POST /wd/hub/session/:sessionId/appium/app/end_test_coverage
- (void)postEndTestCoverageWithSession:(NSString *)sessionId error:(NSError **)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/app/end_test_coverage", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /wd/hub/session/:sessionId/appium/app/strings
-(NSString*) getAppStringsForLanguage:(NSString*)languageCode session:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/app/strings", self.httpCommandExecutor, sessionId];
    NSDictionary *postParams = languageCode == nil ? [NSDictionary new] : @{@"language" : languageCode};
    NSDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
    return [[json objectForKey:@"value"] stringValue];
}

// POST /wd/hub/session/:sessionId/appium/element/:elementId?/value
-(void) postSetValueForElement:(SEWebElement*)element value:(NSString*)value isUnicode:(BOOL)isUnicode session:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/element/%@/value", self.httpCommandExecutor, sessionId, element.opaqueId];
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:value, @"text", nil];
    if (isUnicode) {
        [postParams setObject:[NSNumber numberWithBool:isUnicode] forKey:@"unicodeKeyboard"];
    }
    [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /wd/hub/session/:sessionId/appium/element/:elementId?/replace_value
-(void) postReplaceValueForElement:(SEWebElement*)element value:(NSString*)value isUnicode:(BOOL)isUnicode session:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/element/%@/replace_value", self.httpCommandExecutor, sessionId, element.opaqueId];
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:value, @"text", nil];
    if (isUnicode) {
        [postParams setObject:[NSNumber numberWithBool:isUnicode] forKey:@"unicodeKeyboard"];
    }
    [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /wd/hub/session/:sessionId/appium/settings
-(void) postSetAppiumSettings:(NSDictionary*)settings session:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/settings", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:@{@"settings":settings} error:error];
}

// GET /wd/hub/session/:sessionId/appium/settings
-(NSDictionary*) getAppiumSettingsWithSession:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/appium/settings", self.httpCommandExecutor, sessionId];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
    return [[json objectForKey:@"value"] dictionaryRepresentation];
}

@end
