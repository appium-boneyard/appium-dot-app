//
//  AppiumEnvironmentVariablesTableView.h
//  Appium
//
//  Created by Dan Cuellar on 09/01/2015.
//  Copyright (c) 2015 Appium. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppiumMainWindowPopOverViewController.h"


@interface AppiumGeneralSettingsPopOverViewController : AppiumMainWindowPopOverViewController<NSTableViewDataSource,NSTableViewDelegate>
@property IBOutlet NSTableView *environmentVariablesTableView;
@end

@interface AppiumEnvironmentVariableTextFieldDelegate : NSObject<NSTextFieldDelegate>

@property BOOL isKey;
@property NSInteger index;
@property NSTableView *tableView;

@end
