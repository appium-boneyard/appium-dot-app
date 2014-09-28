//
//  AppiumInspectorWindowController.m
//  Appium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumInspectorWindowController.h"

#import "AppiumAppDelegate.h"
#import "AppiumModel.h"

@implementation AppiumInspectorWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];

    if (self)
	{
        AppiumModel *model = [(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] model];
        
        self.driver = [[SERemoteWebDriver alloc] initWithServerAddress:model.general.serverAddress port:[model.general.serverPort integerValue]];
		
		if (self.driver == nil)
		{
			return [self closeWithError:@"Could not connect to Appium Server"];
		}

        NSArray *sessions = [self.driver allSessions];
		if (self.driver == nil || sessions == nil)
		{
			return [self closeWithError:@"Could not get list of sessions from Appium Server"];
		}

		// get session to use
		if (sessions.count > 0)
        {
			// use the existing session
            [self.driver setSession:[sessions objectAtIndex:0]];
			if (self.driver == nil || self.driver.session == nil)
			{
				return [self closeWithError:@"Could not set the session"];
			}
        }
        if (sessions.count == 0 || self.driver.session == nil || self.driver.session.capabilities.platform == nil)
        {
			// create a new session if one does not already exist
			SECapabilities *capabilities = [SECapabilities new];
            [capabilities addCapabilityForKey:@"automationName" andValue:(model.isAndroid ? model.android.automationName : @"Appium")];
            [capabilities addCapabilityForKey:@"platformName" andValue:(model.isAndroid ? model.android.platformName : @"iOS")];
			[capabilities addCapabilityForKey:@"platformVersion" andValue:model.isAndroid ? model.android.platformVersionNumber : model.iOS.platformVersion];
			[capabilities addCapabilityForKey:@"newCommandTimeout" andValue:@"999999"];
			if ((model.isAndroid && model.android.useDeviceName) || (model.isIOS && !model.iOS.useDefaultDevice)) {
				[capabilities addCapabilityForKey:@"deviceName" andValue:model.isAndroid ? model.android.deviceName : model.iOS.deviceName];
			}
			if ((model.isAndroid && model.android.useLanguage) || (model.isIOS && model.iOS.useLanguage)) {
				[capabilities addCapabilityForKey:@"language" andValue:model.isAndroid ? model.android.language : model.iOS.language];
			}
			if ((model.isAndroid && model.android.useLocale) || (model.isIOS && model.iOS.useLocale)) {
				[capabilities addCapabilityForKey:@"locale" andValue:model.isAndroid ? model.android.locale : model.iOS.locale];
			}

            [self.driver startSessionWithDesiredCapabilities:capabilities requiredCapabilities:nil];
			if (self.driver == nil || self.driver.session == nil || self.driver.session.sessionId == nil)
			{
				return [self closeWithError:@"Could not start a new session"];
			}
        }

        // detect the current platform (if using a remote server)
		if (model.general.useRemoteServer)
		{
			if ([[self.driver.session.capabilities.platformName lowercaseString] isEqualToString:@"ios"])
			{
				[model setPlatform:AppiumiOSPlatform];
			}
			else if ([[self.driver.session.capabilities.platformName lowercaseString] isEqualToString:@"android"])
			{
				[model setPlatform:AppiumAndroidPlatform];
			}
			else if ([[self.driver.session.capabilities.platformName lowercaseString] isEqualToString:@"selendroid"])
			{
				[model setPlatform:AppiumAndroidPlatform];
			}
		}
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResize:) name:NSWindowDidResizeNotification object:window];
    }

    return self;
}

-(void) windowDidLoad
{
    [super windowDidLoad];
    
	if ([self.recordButton respondsToSelector:@selector(setLayerUsesCoreImageFilters:)])
		// fix crash for pulse animation on record button
		[self.recordButton setLayerUsesCoreImageFilters:YES];
}

- (void)windowDidResize:(NSNotification *)notification
{
	if (!self.selectedElementHighlightView.isHidden)
	{
		[self.selectedElementHighlightView setHidden:YES];
	}
}

-(void) awakeFromNib
{
	// setup drawer
    NSSize contentSize = NSMakeSize(self.window.minSize.width, 200.0f);
    self.bottomDrawer = [[NSDrawer alloc] initWithContentSize:contentSize preferredEdge:NSMinYEdge];
    [self.bottomDrawer setParentWindow:self.window];
    [self.bottomDrawer setMinContentSize:contentSize];
	[self.bottomDrawer setContentView:self.bottomDrawerContentView];
	[self.bottomDrawer.contentView setAutoresizingMask:NSViewHeightSizable];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(IBAction)locatorSearchButtonClicked:(id)sender {
	
	[self.findElementButton setEnabled:NO];
	@try {
		SEBy *locator = nil;
		if ([self.inspector.selectedLocatorStrategy isEqualToString:@"accessibility id"]) {
			locator = [SEBy accessibilityId:self.inspector.suppliedLocator];
		} else if ([self.inspector.selectedLocatorStrategy isEqualToString:@"android uiautomator"]) {
			locator = [SEBy androidUIAutomator:self.inspector.suppliedLocator];
		} else if ([self.inspector.selectedLocatorStrategy isEqualToString:@"class name"]) {
			locator = [SEBy className:self.inspector.suppliedLocator];
		} else if ([self.inspector.selectedLocatorStrategy isEqualToString:@"id"]) {
			locator = [SEBy idString:self.inspector.suppliedLocator];
		} else if ([self.inspector.selectedLocatorStrategy isEqualToString:@"ios uiautomation"]) {
			locator = [SEBy iOSUIAutomation:self.inspector.suppliedLocator];
		} else if ([self.inspector.selectedLocatorStrategy isEqualToString:@"name"]) {
			locator = [SEBy name:self.inspector.suppliedLocator];
		} else if ([self.inspector.selectedLocatorStrategy isEqualToString:@"xpath"]) {
			locator = [SEBy xPath:self.inspector.suppliedLocator];
		}
		
		NSMutableArray *elements = [NSMutableArray new];
		SEWebElement *element = nil;
		NSRect rect;
		NSString *className;

		// find elements and grab identifying information
		if (locator != nil) {
			[elements addObjectsFromArray:[self.driver findElementsBy:locator]];
			if ([elements count] == 1) {
				element = (SEWebElement*)[elements objectAtIndex:0];
				if (element.opaqueId != nil) {
					NSPoint origin = element.location;
					NSSize size = element.size;
					rect = NSMakeRect(origin.x, origin.y, size.width, size.height);
					className = element.tagName;
				}
			}
		}
		
		if (element == nil || element.opaqueId == nil) {
			NSAlert *alert = [NSAlert new];
			if (elements.count > 1) {
				// multiple elements were found, show an alert
				alert.messageText = @"Multiple Elements Were Found";
				alert.informativeText = [NSString stringWithFormat:@"%ld elements were found using the locator value \"%@\" and the locator strategy \"%@\"", elements.count, self.inspector.suppliedLocator, self.inspector.selectedLocatorStrategy];
			} else {
			// element was not found, show an alert
			alert.messageText = @"No Matching Elements Were Found";
			alert.informativeText = [NSString stringWithFormat:@"An element could not be found using the locator value \"%@\" and the locator strategy \"%@\"", self.inspector.suppliedLocator, self.inspector.selectedLocatorStrategy];
			}
			[alert runModal];

		} else {
			// select the node that was found
			[self.inspector selectNodeWithRect:rect className:className fromNode:nil];
		}
	}
	@catch (NSException *exception) {
		NSLog(@"Could not locate element: %@" , exception);
	}
	@finally {
		[self.findElementButton setEnabled:YES];
	}
}

-(id) closeWithError:(NSString*)informativeText
{
	dispatch_sync(dispatch_get_main_queue(), ^{
		NSAlert *alert = [NSAlert new];
		[alert setMessageText:@"Could Not Launch Appium Inspector"];
		[alert setInformativeText:[NSString stringWithFormat:@"%@\n\n%@", informativeText, @"Be sure the Appium server is running with an application opened by using the \"App Path\" parameter in Appium.app (along with package and activity for Android) or by connecting with selenium client and supplying this in the desired capabilities object."]];
		[alert runModal];
		[self close];
	});
	
	return nil;
}

@end
