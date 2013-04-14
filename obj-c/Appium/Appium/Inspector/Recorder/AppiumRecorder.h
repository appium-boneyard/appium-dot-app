//
//  AppiumRecorderDelegate.h
//  Appium
//
//  Created by Dan Cuellar on 4/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppiumCodeMaker.h"

@class AppiumCodeMaker;
@class AppiumInspectorWindowController;

@interface AppiumRecorder : NSObject {
    @private
    IBOutlet AppiumInspectorWindowController *_windowController;
    BOOL _isRecording;
}

@property NSNumber *isRecording;
@property NSString *keysToSend;
@property AppiumCodeMaker *codeMaker;

@end
