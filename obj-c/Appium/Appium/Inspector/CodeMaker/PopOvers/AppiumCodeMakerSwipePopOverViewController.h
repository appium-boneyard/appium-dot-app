//
//  AppiumCodeMakerSwipePopOverViewController.h
//  Appium
//
//  Created by Dan Cuellar on 4/12/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppiumCodeMakerSwipePopOverViewController : NSViewController {
	@private
	NSUInteger _numberOfFingers;
	float _duration;
	NSPoint _beginPoint;
	NSPoint _endPoint;
	NSString *_beginPointLabel;
	NSString *_endPointLabel;
	BOOL _isReady;
}

@property (readonly) NSUInteger numberOfFingers;
@property NSString *numberOfFingersString;
@property NSNumber *duration;
@property NSPoint beginPoint;
@property NSString *beginPointLabel;
@property NSPoint endPoint;
@property NSString *endPointLabel;
@property NSNumber *isReady;
@property BOOL beginPointWasSetLast;

-(void)reset;

@end
