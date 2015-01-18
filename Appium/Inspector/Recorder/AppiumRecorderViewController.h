//
//  AppiumRecorderDelegate.h
//  Appium
//
//  Created by Dan Cuellar on 4/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMaker.h"

@class AppiumCodeMaker;
@class AppiumInspector;
@class AppiumInspectorWindowController;

@interface AppiumRecorderViewController : NSViewController {
    @private
    IBOutlet AppiumInspector *_inspector;
}

@property NSString *keysToSend;
@property IBOutlet AppiumCodeMaker *codeMaker;

@end
