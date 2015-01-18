//
//  AppiumInstallationWindowController.m
//  Appium
//
//  Created by Dan Cuellar on 3/3/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumInstallationWindowController.h"
#import <QuartzCore/QuartzCore.h>

@interface AppiumInstallationWindowController ()

@end

@implementation AppiumInstallationWindowController

-(id)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-init is not a valid initializer for the class AppiumInstallationWindowController"
                                 userInfo:nil];
    return nil;
}

-(void) awakeFromNib {
	[self installRotationAnimation];
}

-(void) installRotationAnimation {
	CABasicAnimation* rotate =  [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
	rotate.removedOnCompletion = NO;
	rotate.fillMode = kCAFillModeForwards;
	[rotate setToValue: [NSNumber numberWithFloat: -M_PI / 2]];
	rotate.repeatCount = HUGE_VALF;
	rotate.duration = 1.5f;
	rotate.beginTime = 0;
	rotate.cumulative = TRUE;
	rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	[_appiumLogoImageView.layer addAnimation: rotate forKey: @"rotateAnimation"];
	CGRect frame = _appiumLogoImageView.layer.frame;
	CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
	_appiumLogoImageView.layer.position = center;
	_appiumLogoImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
}

@end
