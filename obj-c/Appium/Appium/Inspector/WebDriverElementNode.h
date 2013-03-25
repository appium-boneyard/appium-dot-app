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
    NSMutableArray *_children;
    BOOL _showDisabled;
    BOOL _showInvisible;
}

- (id)initWithJSONDict:(NSDictionary *)jsonDict showDisabled:(BOOL)showDisabled showInvisible:(BOOL)showInvisible;

#pragma mark - NSBrowerCell Properties

@property(readonly, copy) NSString *displayName;
@property(readonly, retain) NSImage *icon;
@property(readonly, retain) NSArray *children;
@property(readonly) BOOL isLeaf;
@property(readonly, retain) NSColor *labelColor;

#pragma mark - Properties

@property BOOL enabled;
@property BOOL visible;
@property BOOL valid;
@property NSString *label;
@property NSRect rect;
@property NSString *type;
@property (readonly) NSString *typeShortcut;
@property NSString *value;
@property NSString *name;
@property (readonly) NSString* infoText;
@property (readonly) BOOL shouldDisplay;

@end
