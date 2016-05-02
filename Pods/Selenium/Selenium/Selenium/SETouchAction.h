//
// Created by Mark Corbyn on 08/01/15.
// Copyright (c) 2015 Mark Corbyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SEWebElement;

@interface SETouchAction : NSObject

@property (nonatomic, strong) NSMutableArray *commands;

#pragma mark - Standard Press
-(void) pressElement:(SEWebElement *)element;
-(void) pressAtX:(NSInteger)x y:(NSInteger)y;
-(void) pressElement:(SEWebElement *)element atX:(NSInteger)x y:(NSInteger)y;

#pragma mark - Withdraw/Release
-(void) withdrawTouch;

#pragma mark - Move To
-(void) moveToElement:(SEWebElement *)element;
-(void) moveToX:(NSInteger)x y:(NSInteger)y; // Coordinates are relative to current touch position
-(void) moveToElement:(SEWebElement *)element atX:(NSInteger)x y:(NSInteger)y;
-(void) moveByX:(NSInteger)x y:(NSInteger)y; // An alias of moveToX:y

#pragma mark - Tap
-(void) tapElement:(SEWebElement *)element;
-(void) tapAtX:(NSInteger)x y:(NSInteger)y;
-(void) tapElement:(SEWebElement *)element atX:(NSInteger)x y:(NSInteger)y;

#pragma mark - Wait
-(void) wait;
-(void) waitForTimeInterval:(NSTimeInterval)timeInterval;

#pragma mark - Long Press
-(void) longPressElement:(SEWebElement *)element;
-(void) longPressAtX:(NSInteger)x y:(NSInteger)y;
-(void) longPressElement:(SEWebElement *)element atX:(NSInteger)x y:(NSInteger)y;

#pragma mark - Cancel
-(void) cancel;

@end