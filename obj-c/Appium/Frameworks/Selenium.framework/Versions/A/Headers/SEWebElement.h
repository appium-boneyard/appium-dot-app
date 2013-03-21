//
//  SEWebElement.h
//  Selenium
//
//  Created by Dan Cuellar on 3/18/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEBy.h"

@class SEJsonWireClient;
@class SEBy;

@interface SEWebElement : NSObject

@property NSString *opaqueId;
@property NSString *sessionId;

-(id) initWithOpaqueId:(NSString*)opaqueId jsonWireClient:(SEJsonWireClient*)jsonWireClient session:(NSString*)sessionId;

-(void) click;
-(void) clickAndReturnError:(NSError**)error;
-(void) submit;
-(void) submitAndReturnError:(NSError**)error;
-(NSString*) text;
-(NSString*) textAndReturnError:(NSError**)error;
-(void) sendKeys:(NSString*)keyString;
-(void) sendKeys:(NSString*)keyString error:(NSError**)error;
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
-(BOOL) isEqualToElement:(SEWebElement*)element;
-(BOOL) isEqualToElement:(SEWebElement*)element error:(NSError**)error;
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


-(SEWebElement*) findElementBy:(SEBy*)by;
-(SEWebElement*) findElementBy:(SEBy*)by error:(NSError**)error;
-(NSArray*) findElementsBy:(SEBy*)by;
-(NSArray*) findElementsBy:(SEBy*)by error:(NSError**)error;

-(NSDictionary*)elementJson;

@end
