//
//  WebDriverElementNode.h
//  Appium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppiumModel.h"

@interface WebDriverElementNode : NSObject<NSToolbarDelegate> {

@private
	NSDictionary *_jsonDict;
    NSMutableArray *_children;
	NSMutableArray *_visibleChildren;
    BOOL _showDisabled;
    BOOL _showInvisible;
}

- (id)initWithJSONDict:(NSDictionary *)jsonDict parent:(WebDriverElementNode*) parent showDisabled:(BOOL)showDisabled showInvisible:(BOOL)showInvisible;

#pragma mark - NSBrowerCell Implementation
@property(readonly, copy) NSString *displayName;
@property(readonly, retain) NSImage *icon;
@property(readonly, retain) NSArray *children;
@property(readonly, retain) NSArray *visibleChildren;
@property(readonly) BOOL isLeaf;
@property(readonly, retain) NSColor *labelColor;

#pragma mark - Common Properties
@property AppiumPlatform platform;
@property WebDriverElementNode *parent;
@property (readonly) BOOL shouldDisplay;
@property BOOL enabled;
@property BOOL visible;
@property NSString *value;
@property NSString *name;
@property NSRect rect;
@property NSString *type;
@property NSString *path;
@property (readonly) NSAttributedString* infoText;
-(NSAttributedString*) infoTextWithXPath:(NSString*)xpath;

#pragma mark - iOS-Specific properties
@property NSString *label;
@property BOOL valid;

#pragma mark - Android-Specific Properties
@property BOOL focusable;
@property BOOL checkable;
@property BOOL scrollable;
@property BOOL password;
@property BOOL longClickable;
@property BOOL selected;
@property NSUInteger index;
@property NSString *contentDesc;
@property NSString *package;
@property NSString *text;
@property NSString *resourceId;
@property BOOL clickable;
@property BOOL focused;
@property BOOL checked;

@end
