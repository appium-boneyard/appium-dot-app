//
//  WebElement.h
//  Selenium
//
//  Created by Dan Cuellar on 3/18/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONWireClient.h"
#import "By.h"

@class JSONWireClient;
@class By;

@interface WebElement : NSObject

@property NSString *opaqueId;
@property JSONWireClient *client;
@property NSString *sessionId;

-(id) initWithOpaqueId:(NSString*)opaqueId jsonWireClient:(JSONWireClient*)jsonWireClient session:(NSString*)remoteSessionId;

-(void) click;
-(void) clickAndReturnError:(NSError**)error;
-(void) submit;
-(void) submitAndReturnError:(NSError**)error;
-(NSString*) text;
-(NSString*) textAndReturnError:(NSError**)error;
-(NSString*) tagName;
-(NSString*) tagNameAndReturnError:(NSError**)error;
-(void) clear;
-(void) clearAndReturnError:(NSError**)error;
-(BOOL) isSelected;
-(BOOL) isSelectedAndReturnError:(NSError**)error;
-(BOOL) isEnabled;
-(BOOL) isEnabledAndReturnError:(NSError**)error;
-(NSString*) attribute:(NSString*)attributeName;
-(NSString*) attribute:(NSString*)attributeName error:(NSError**)error;
-(BOOL) isEqualToElement:(WebElement*)element;
-(BOOL) isEqualToElement:(WebElement*)element error:(NSError**)error;
-(BOOL) isDisplayed;
-(BOOL) isDisplayedAndReturnError:(NSError**)error;
-(NSPoint) location;
-(NSPoint) locationAndReturnError:(NSError**)error;
-(NSPoint) locationInView;
-(NSPoint) locationInViewAndReturnError:(NSError**)error;
-(NSSize) size;
-(NSSize) sizeAndReturnError:(NSError**)error;
-(NSString*) cssProperty:(NSString*)propertyName;
-(NSString*) cssProperty:(NSString*)propertyName error:(NSError**)error;


-(WebElement*) findElementBy:(By*)by;
-(WebElement*) findElementBy:(By*)by error:(NSError**)error;
-(NSArray*) findElementsBy:(By*)by;
-(NSArray*) findElementsBy:(By*)by error:(NSError**)error;

@end
