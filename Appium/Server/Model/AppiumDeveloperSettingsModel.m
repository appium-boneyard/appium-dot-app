//
//  AppiumDeveloperSettingsModel.m
//  Appium
//
//  Created by Dan Cuellar on 5/13/14.
//  Copyright (c) 2014 Appium. All rights reserved.
//

#import "AppiumDeveloperSettingsModel.h"
#import "AppiumPreferencesFile.h"

@implementation AppiumDeveloperSettingsModel

-(NSScriptObjectSpecifier*) objectSpecifier
{
	NSScriptClassDescription *containerClassDesc = (NSScriptClassDescription *)
    [NSScriptClassDescription classDescriptionForClass:[NSApp class]];
	return [[NSNameSpecifier alloc]
			initWithContainerClassDescription:containerClassDesc
			containerSpecifier:nil key:@"developer"
			name:@"developer settings"];
}

-(BOOL) breakOnNodeApplicationStart { return self.developerMode && self.useNodeDebugging && [DEFAULTS boolForKey:APPIUM_PLIST_BREAK_ON_NODEJS_APP_START]; }
-(void) setBreakOnNodeApplicationStart:(BOOL)breakOnNodeApplicationStart { [DEFAULTS setBool:breakOnNodeApplicationStart forKey:APPIUM_PLIST_BREAK_ON_NODEJS_APP_START]; }

-(NSString*) customFlags { return [DEFAULTS stringForKey:APPIUM_PLIST_CUSTOM_FLAGS]; }
-(void) setCustomFlags:(NSString *)customFlags { [DEFAULTS setValue:customFlags forKey:APPIUM_PLIST_CUSTOM_FLAGS]; }

-(BOOL) developerMode { return [DEFAULTS boolForKey:APPIUM_PLIST_DEVELOPER_MODE]; }
-(void) setDeveloperMode:(BOOL)developerMode { [DEFAULTS setBool:developerMode forKey:APPIUM_PLIST_DEVELOPER_MODE]; }

-(NSString*) externalAppiumPackagePath { return [DEFAULTS stringForKey:APPIUM_PLIST_EXTERNAL_APPIUM_PACKAGE_PATH]; }
-(void) setExternalAppiumPackagePath:(NSString *)externalAppiumPackagePath { [DEFAULTS setValue:externalAppiumPackagePath forKey:APPIUM_PLIST_EXTERNAL_APPIUM_PACKAGE_PATH]; }

-(NSString*) externalNodeJSBinaryPath { return [DEFAULTS stringForKey:APPIUM_PLIST_EXTERNAL_NODEJS_BINARY_PATH]; }
-(void) setExternalNodeJSBinaryPath:(NSString *)externalNodeJSBinaryPath { [DEFAULTS setValue:externalNodeJSBinaryPath forKey:APPIUM_PLIST_EXTERNAL_NODEJS_BINARY_PATH]; }

-(NSNumber*) nodeJSDebugPort { return [NSNumber numberWithInt:[[DEFAULTS stringForKey:APPIUM_PLIST_NODEJS_DEBUG_PORT] intValue]]; }
-(void) setNodeJSDebugPort:(NSNumber *)nodeJSDebugPort { [[NSUserDefaults standardUserDefaults] setValue:nodeJSDebugPort forKey:APPIUM_PLIST_NODEJS_DEBUG_PORT]; }

-(BOOL) useCustomFlags { return [DEFAULTS boolForKey:APPIUM_PLIST_USE_CUSTOM_FLAGS]; }
-(void) setUseCustomFlags:(BOOL)useCustomFlags { [DEFAULTS setBool:useCustomFlags forKey:APPIUM_PLIST_USE_CUSTOM_FLAGS]; }

-(BOOL) useExternalAppiumPackage { return self.developerMode && [DEFAULTS boolForKey:APPIUM_PLIST_USE_EXTERNAL_APPIUM_PACKAGE]; }
-(void) setUseExternalAppiumPackage:(BOOL)useCustomAppiumPackage { [DEFAULTS setBool:useCustomAppiumPackage forKey:APPIUM_PLIST_USE_EXTERNAL_APPIUM_PACKAGE]; }

-(BOOL) useExternalNodeJSBinary { return self.developerMode && [DEFAULTS boolForKey:APPIUM_PLIST_USE_EXTERNAL_NODEJS_BINARY]; }
-(void) setUseExternalNodeJSBinary:(BOOL)useCustomNodeJSBinary { [DEFAULTS setBool:useCustomNodeJSBinary forKey:APPIUM_PLIST_USE_EXTERNAL_NODEJS_BINARY]; }

-(BOOL) useNodeDebugging { return self.developerMode && [DEFAULTS boolForKey:APPIUM_PLIST_USE_NODEJS_DEBUGGING]; }
-(void) setUseNodeDebugging:(BOOL)useNodeDebugging { [DEFAULTS setBool:useNodeDebugging forKey:APPIUM_PLIST_USE_NODEJS_DEBUGGING]; }

@end
