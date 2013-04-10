//
//  AppiumInspectorDelegate.h
//  Appium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebDriverElementNode.h"
#import "AppiumInspectorWindowController.h"

@class WebDriverElementNode;
@class AppiumInspectorWindowController;

@interface AppiumInspectorDelegate : NSObject {
@private
	IBOutlet AppiumInspectorWindowController *_windowController;
	WebDriverElementNode *_rootNode;
    WebDriverElementNode *_browserRootNode;
    BOOL _showDisabled;
    BOOL _showInvisible;
	BOOL _isRecording;
}

@property NSNumber *showDisabled;
@property NSNumber *showInvisible;
@property NSString *keysToSend;
@property BOOL domIsPopulating;
@property NSNumber *isRecording;

-(void)selectNodeNearestPoint:(NSPoint)point;

@end
