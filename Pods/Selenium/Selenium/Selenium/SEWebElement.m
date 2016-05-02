//
//  SEWebElement.m
//  Selenium
//
//  Created by Dan Cuellar on 3/18/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "SEWebElement.h"

@interface SEWebElement ()
	@property SEJsonWireClient *jsonWireClient;
@end

@implementation SEWebElement 

-(id) initWithOpaqueId:(NSString*)opaqueId jsonWireClient:(SEJsonWireClient*)jsonWireClient session:(NSString*)sessionId
{
    self = [super init];
    if (self) {
        [self setOpaqueId:opaqueId];
		[self setJsonWireClient:jsonWireClient];
		[self setSessionId:sessionId];
    }
    return self;
}

-(void) click
{
	NSError *error;
	[self clickAndReturnError:&error];
    [self.jsonWireClient addError:error];
}

-(void) clickAndReturnError:(NSError**)error
{
	[self.jsonWireClient postClickElement:self session:self.sessionId error:error];
}

-(void) submit
{
	NSError *error;
	[self submitAndReturnError:&error];
    [self.jsonWireClient addError:error];
}

-(void) submitAndReturnError:(NSError**)error
{
	[self.jsonWireClient postSubmitElement:self session:self.sessionId error:error];
}

-(NSString*) text
{
	NSError *error;
	NSString *text = [self textAndReturnError:&error];
    [self.jsonWireClient addError:error];
    return text;
}

-(NSString*) textAndReturnError:(NSError**)error
{
	return [self.jsonWireClient getElementText:self session:self.sessionId error:error];
}

-(void) sendKeys:(NSString*)keyString
{
	NSError *error;
	[self sendKeys:keyString error:&error];
    [self.jsonWireClient addError:error];
}

-(void) sendKeys:(NSString*)keyString error:(NSError**)error
{
	unichar keys[keyString.length+1];
	for(int i=0; i < keyString.length; i++)
		keys[i] = [keyString characterAtIndex:i];
	keys[keyString.length] = '\0';
	return [self.jsonWireClient postKeys:keys element:self session:self.sessionId error:error];
}

-(NSString*) tagName
{
	NSError *error;
	NSString *tagName = [self tagNameAndReturnError:&error];
    [self.jsonWireClient addError:error];
    return tagName;
}

-(NSString*) tagNameAndReturnError:(NSError**)error
{
	return [self.jsonWireClient getElementName:self session:self.sessionId error:error];
}

-(void) clear
{
	NSError *error;
	[self clearAndReturnError:&error];
    [self.jsonWireClient addError:error];
}

-(void) clearAndReturnError:(NSError**)error
{
	[self.jsonWireClient postClearElement:self session:self.sessionId error:error];
}

-(BOOL) isSelected
{
	NSError *error;
	return [self isSelectedAndReturnError:&error];
}

-(BOOL) isSelectedAndReturnError:(NSError**)error
{
	return [self.jsonWireClient getElementIsSelected:self session:self.sessionId error:error];
}

-(BOOL) isEnabled
{
	NSError *error;
	return [self isEnabledAndReturnError:&error];
}

-(BOOL) isEnabledAndReturnError:(NSError**)error
{
	return [self.jsonWireClient getElementIsEnabled:self session:self.sessionId error:error];
}

-(NSString*) attribute:(NSString*)attributeName
{
	NSError *error;
	NSString *attribute = [self attribute:attributeName error:&error];
    [self.jsonWireClient addError:error];
    return attribute;
}

-(NSString*) attribute:(NSString*)attributeName error:(NSError**)error
{
	return [self.jsonWireClient getAttribute:attributeName element:self session:self.sessionId error:error];
}

-(BOOL) isEqualToElement:(SEWebElement*)element
{
	NSError *error;
	BOOL result = [self isEqualToElement:element error:&error];
    [self.jsonWireClient addError:error];
    return result;
}

-(BOOL) isEqualToElement:(SEWebElement*)element error:(NSError**)error
{
	return [self.jsonWireClient getEqualityForElement:self element:element session:self.sessionId error:error];
}

-(BOOL) isDisplayed
{
	NSError *error;
	BOOL isDisplayed = [self isDisplayedAndReturnError:&error];
    [self.jsonWireClient addError:error];
    return isDisplayed;
}

-(BOOL) isDisplayedAndReturnError:(NSError**)error
{
	return [self.jsonWireClient getElementIsDisplayed:self session:self.sessionId error:error];
}

-(POINT_TYPE) location
{
	NSError *error;
    POINT_TYPE location = [self locationAndReturnError:&error];
    [self.jsonWireClient addError:error];
    return location;
}

-(POINT_TYPE) locationAndReturnError:(NSError**)error
{
	return [self.jsonWireClient getElementLocation:self session:self.sessionId error:error];
}

-(POINT_TYPE) locationInView
{
	NSError *error;
	POINT_TYPE locationInView = [self locationInViewAndReturnError:&error];
    [self.jsonWireClient addError:error];
    return locationInView;
}

-(POINT_TYPE) locationInViewAndReturnError:(NSError**)error
{
	return [self.jsonWireClient getElementLocationInView:self session:self.sessionId error:error];
}

-(SIZE_TYPE) size
{
	NSError *error;
	SIZE_TYPE size = [self sizeAndReturnError:&error];
    [self.jsonWireClient addError:error];
    return size;
}

-(SIZE_TYPE) sizeAndReturnError:(NSError**)error
{
	return [self.jsonWireClient getElementSize:self session:self.sessionId error:error];
}

-(NSString*) cssProperty:(NSString*)propertyName
{
	NSError *error;
	NSString *property = [self cssProperty:propertyName error:&error];
    [self.jsonWireClient addError:error];
    return property;
}

-(NSString*) cssProperty:(NSString*)propertyName error:(NSError**)error
{
	return [self.jsonWireClient getCSSProperty:propertyName element:self session:self.sessionId error:error];
}

-(SEWebElement*) findElementBy:(SEBy*)by
{
	NSError *error;
	SEWebElement *element = [self findElementBy:by error:&error];
    [self.jsonWireClient addError:error];
    return element;
}

-(SEWebElement*) findElementBy:(SEBy*)by error:(NSError**)error
{
	SEWebElement *element = [self.jsonWireClient postElementFromElement:self by:by session:self.sessionId error:error];
    return element != nil && element.opaqueId != nil ? element : nil;
}

-(NSArray*) findElementsBy:(SEBy*)by
{
	NSError *error;
	NSArray *elements = [self findElementsBy:by error:&error];
    [self.jsonWireClient addError:error];
    return elements;
}

-(NSArray*) findElementsBy:(SEBy*)by error:(NSError**)error
{
	NSArray *elements = [self.jsonWireClient postElementsFromElement:self by:by session:self.sessionId error:error];
    if (elements == nil || elements.count < 1) {
        return [NSArray new];
    }
    SEWebElement *element = [elements objectAtIndex:0];
    if (element == nil || element.opaqueId == nil) {
        return [NSArray new];
    }
    return elements;
}

-(NSDictionary*)elementJson
{
	NSDictionary* json = [[NSDictionary alloc] initWithObjectsAndKeys:self.opaqueId, @"ELEMENT", nil];
	return json;
}

-(void) setValue:(NSString*)value {
    [self setValue:value isUnicode:NO];
}

-(void) setValue:(NSString*)value isUnicode:(BOOL)isUnicode {
    NSError *error;
    [self setValue:value isUnicode:isUnicode error:&error];
    [self.jsonWireClient addError:error];
}

-(void) setValue:(NSString*)value isUnicode:(BOOL)isUnicode error:(NSError**)error
{
    [self.jsonWireClient postSetValueForElement:self value:value isUnicode:isUnicode session:self.sessionId error:error];
}

-(void) replaceValue:(NSString*)value element:(SEWebElement*)element {
    [self replaceValue:value element:element isUnicode:NO];
}

-(void) replaceValue:(NSString*)value element:(SEWebElement*)element isUnicode:(BOOL)isUnicode {
    NSError *error;
    [self replaceValue:value isUnicode:isUnicode error:&error];
    [self.jsonWireClient addError:error];
}

-(void) replaceValue:(NSString*)value isUnicode:(BOOL)isUnicode error:(NSError**)error
{
    [self.jsonWireClient postReplaceValueForElement:self value:value isUnicode:isUnicode session:self.sessionId error:error];
}

@end
