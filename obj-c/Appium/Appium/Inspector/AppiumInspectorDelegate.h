//
//  AppiumInspectorDelegate.h
//  Appium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebDriverElementNode.h"

@interface AppiumInspectorDelegate : NSObject {
@private

	IBOutlet NSTextView *_detailsTextView;
	WebDriverElementNode *_rootNode;
}

@end
