//
//  AppiumAppDelegate.h
//  Appium
//
//  Created by Dan Cuellar on 3/3/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppiumAppDelegate : NSObject <NSApplicationDelegate>

@property (strong) IBOutlet NSTextView *logTextView;
@property (assign) IBOutlet NSWindow *mainWindow;
@property (weak) IBOutlet NSButton *launchButton;
@property (weak) IBOutlet NSTextField *ipAddressTextField;
@property (weak) IBOutlet NSTextField *portTextField;
@property (weak) IBOutlet NSButton *verboseCheckBox;

@property (weak) IBOutlet NSNumber *isServerRunning;

@end
