//
//  AppiumMenuBarManager.h
//  Appium
//
//  Created by Dan Cuellar on 3/7/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppiumMenuBarManager : NSObject {
    @private
    NSStatusBar *_bar;
    NSStatusItem *_item;
}

@end
