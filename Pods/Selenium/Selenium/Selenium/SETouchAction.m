//
// Created by Mark Corbyn on 08/01/15.
// Copyright (c) 2015 Mark Corbyn. All rights reserved.
//

#import "SETouchAction.h"
#import "SEWebElement.h"
#import "SETouchActionCommand.h"

static NSString * const SETouchPressKey         = @"press";
static NSString * const SETouchWithdrawKey      = @"release";
static NSString * const SETouchMoveToKey        = @"moveTo";
static NSString * const SETouchTapKey           = @"tap";
static NSString * const SETouchWaitKey          = @"wait";
static NSString * const SETouchLongPressKey     = @"longPress";

@interface SETouchAction()

@end

@implementation SETouchAction

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.commands = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Standard Press
-(void) pressElement:(SEWebElement *)element
{
    SETouchActionCommand *actionEvent = [[SETouchActionCommand alloc] initWithName:SETouchPressKey];
    [actionEvent addParameterWithKey:@"element" value:[element opaqueId]];
    [self.commands addObject:actionEvent];
}

-(void) pressAtX:(NSInteger)x y:(NSInteger)y
{
    SETouchActionCommand *actionEvent = [[SETouchActionCommand alloc] initWithName:SETouchPressKey];
    [actionEvent addParameterWithKey:@"x" value:@(x)];
    [actionEvent addParameterWithKey:@"y" value:@(y)];
    [self.commands addObject:actionEvent];
}


-(void) pressElement:(SEWebElement *)element atX:(NSInteger)x y:(NSInteger)y
{
    SETouchActionCommand *actionEvent = [[SETouchActionCommand alloc] initWithName:SETouchPressKey];
    [actionEvent addParameterWithKey:@"element" value:[element opaqueId]];
    [actionEvent addParameterWithKey:@"x" value:@(x)];
    [actionEvent addParameterWithKey:@"y" value:@(y)];
    [self.commands addObject:actionEvent];
}

#pragma mark - Withdraw/Release
-(void) withdrawTouch
{
    SETouchActionCommand *actionEvent = [[SETouchActionCommand alloc] initWithName:SETouchWithdrawKey];
    [self.commands addObject:actionEvent];
}

#pragma mark - Move To
-(void) moveToElement:(SEWebElement *)element
{
    SETouchActionCommand *actionEvent = [[SETouchActionCommand alloc] initWithName:SETouchMoveToKey];
    [actionEvent addParameterWithKey:@"element" value:[element opaqueId]];
    [self.commands addObject:actionEvent];
}

-(void) moveToX:(NSInteger)x y:(NSInteger)y
{
    SETouchActionCommand *actionEvent = [[SETouchActionCommand alloc] initWithName:SETouchMoveToKey];
    [actionEvent addParameterWithKey:@"x" value:@(x)];
    [actionEvent addParameterWithKey:@"y" value:@(y)];
    [self.commands addObject:actionEvent];
}

-(void) moveToElement:(SEWebElement *)element atX:(NSInteger)x y:(NSInteger)y
{
    SETouchActionCommand *actionEvent = [[SETouchActionCommand alloc] initWithName:SETouchMoveToKey];
    [actionEvent addParameterWithKey:@"element" value:[element opaqueId]];
    [actionEvent addParameterWithKey:@"x" value:@(x)];
    [actionEvent addParameterWithKey:@"y" value:@(y)];
    [self.commands addObject:actionEvent];
}

// An alias of moveToX:y
- (void) moveByX:(NSInteger)x y:(NSInteger)y
{
    [self moveToX:x y:y];
}

#pragma mark - Tap
-(void) tapElement:(SEWebElement *)element
{
    SETouchActionCommand *actionEvent = [[SETouchActionCommand alloc] initWithName:SETouchTapKey];
    [actionEvent addParameterWithKey:@"element" value:[element opaqueId]];
    [self.commands addObject:actionEvent];
}

-(void) tapAtX:(NSInteger)x y:(NSInteger)y
{
    SETouchActionCommand *actionEvent = [[SETouchActionCommand alloc] initWithName:SETouchTapKey];
    [actionEvent addParameterWithKey:@"x" value:@(x)];
    [actionEvent addParameterWithKey:@"y" value:@(y)];
    [self.commands addObject:actionEvent];
}

-(void) tapElement:(SEWebElement *)element atX:(NSInteger)x y:(NSInteger)y
{
    SETouchActionCommand *actionEvent = [[SETouchActionCommand alloc] initWithName:SETouchTapKey];
    [actionEvent addParameterWithKey:@"element" value:[element opaqueId]];
    [actionEvent addParameterWithKey:@"x" value:@(x)];
    [actionEvent addParameterWithKey:@"y" value:@(y)];
    [self.commands addObject:actionEvent];
}


#pragma mark - Wait
-(void) wait
{
    SETouchActionCommand *actionEvent = [[SETouchActionCommand alloc] initWithName:SETouchWaitKey];
    [self.commands addObject:actionEvent];
}

-(void) waitForTimeInterval:(NSTimeInterval)timeInterval
{
    SETouchActionCommand *actionEvent = [[SETouchActionCommand alloc] initWithName:SETouchWaitKey];

    double milliseconds = timeInterval * 1000;
    [actionEvent addParameterWithKey:@"ms" value:@(milliseconds)];

    [self.commands addObject:actionEvent];
}

#pragma mark - Long Press
-(void) longPressElement:(SEWebElement *)element
{
    SETouchActionCommand *actionEvent = [[SETouchActionCommand alloc] initWithName:SETouchLongPressKey];
    [actionEvent addParameterWithKey:@"element" value:[element opaqueId]];
    [self.commands addObject:actionEvent];
}

-(void) longPressAtX:(NSInteger)x y:(NSInteger)y
{
    SETouchActionCommand *actionEvent = [[SETouchActionCommand alloc] initWithName:SETouchLongPressKey];
    [actionEvent addParameterWithKey:@"x" value:@(x)];
    [actionEvent addParameterWithKey:@"y" value:@(y)];
    [self.commands addObject:actionEvent];
}


-(void) longPressElement:(SEWebElement *)element atX:(NSInteger)x y:(NSInteger)y {
    SETouchActionCommand *actionEvent = [[SETouchActionCommand alloc] initWithName:SETouchLongPressKey];
    [actionEvent addParameterWithKey:@"element" value:[element opaqueId]];
    [actionEvent addParameterWithKey:@"x" value:@(x)];
    [actionEvent addParameterWithKey:@"y" value:@(y)];
    [self.commands addObject:actionEvent];
}

#pragma mark - Cancel
-(void) cancel
{
    [self wait];
}

@end