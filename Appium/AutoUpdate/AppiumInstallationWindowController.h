//
//  AppiumInstallationWindowController.h
//  Appium
//
//  Created by Dan Cuellar on 3/3/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppiumInstallationWindowController : NSWindowController{
	@private
	IBOutlet NSImageView *_appiumLogoImageView;
}

@property (weak) IBOutlet NSTextField *messageLabel;

@end
