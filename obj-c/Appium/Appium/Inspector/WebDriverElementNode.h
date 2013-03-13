//
//  UIAElementNode.h
//  Appium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebDriverElementNode : NSObject<NSToolbarDelegate> {
@private
	NSDictionary *_jsonDict;
    NSMutableDictionary *_children;
    BOOL _childrenDirty;
}

// The designated initializer
- (id)initWithJSONDict:(NSDictionary *)jsonDict;

@property(readonly, copy) NSString *displayName;
@property(readonly, retain) NSImage *icon;
@property(readonly, retain) NSArray *children;
@property(readonly) BOOL isDirectory;
@property(readonly, retain) NSColor *labelColor;

@end
