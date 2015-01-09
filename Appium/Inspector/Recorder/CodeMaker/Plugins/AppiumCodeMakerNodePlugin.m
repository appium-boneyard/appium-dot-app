//
//  AppiumCodeMakerNodePlugin.m
//  Appium
//
//  Created by Jamie Edge on 09/04/2014.
//  Copyright (c) 2014 Appium. All rights reserved.
//

#import "AppiumCodeMakerNodePlugin.h"
#import "AppiumCodeMakerActions.h"

@interface AppiumCodeMakerNodePlugin()

@property (readonly) NSString *indentation;

- (NSString *)escapeString:(NSString *)string;
- (NSString *)locatorString:(AppiumCodeMakerLocator *)locator;

@end

@implementation AppiumCodeMakerNodePlugin

- (id)initWithCodeMaker:(AppiumCodeMaker *)codeMaker
{
	self = [super init];
	
	if (self)
	{
		[self setCodeMaker:codeMaker];
	}
	
	return self;
}

#pragma mark AppiumCodeMakerPlugin
- (NSString *)name
{
	return @"node.js";
}

- (NSString *)fileExtension
{
	return @"js";
}

- (NSString *)preCodeBoilerplateAndroid
{
	return [NSString stringWithFormat:@"\"use strict\";\n\
\n\
var wd = require(\"wd\");\n\
var chai = require(\"chai\");\n\
var chaiAsPromised = require(\"chai-as-promised\");\n\
\n\
chai.use(chaiAsPromised);\n\
chai.should();\n\
chaiAsPromised.transferPromiseness = wd.transferPromiseness;\n\
\n\
var desired = {\n\
\t\"appium-version\": \"1.0\",\n\
\tplatformName: \"%@\",\n\
\tplatformVersion: \"%@\",\n\
\tdeviceName: \"%@\",\n\
\tapp: \"%@\",\n\
\t\"app-package\": \"%@\",\n\
\t\"app-activity\": \"%@\"\n\
};\n\
\n\
var browser = wd.promiseChainRemote(\"%@\", %@);\n\
\n\
browser.init(desired).then(function() {\n\
\treturn browser\n", self.model.android.platformName, self.model.android.platformVersionNumber, self.model.android.deviceName, self.model.android.appPath, self.model.android.package, self.model.android.activity, self.model.general.serverAddress, self.model.general.serverPort];
}

- (NSString *)preCodeBoilerplateiOS
{
	return [NSString stringWithFormat:@"\"use strict\";\n\
\n\
var wd = require(\"wd\");\n\
var chai = require(\"chai\");\n\
var chaiAsPromised = require(\"chai-as-promised\");\n\
\n\
chai.use(chaiAsPromised);\n\
chai.should();\n\
chaiAsPromised.transferPromiseness = wd.transferPromiseness;\n\
\n\
var desired = {\n\
\t\"appium-version\": \"1.0\",\n\
\tplatformName: \"iOS\",\n\
\tplatformVersion: \"%@\",\n\
\tdeviceName: \"%@\",\n\
\tapp: \"%@\",\n\
};\n\
\n\
var browser = wd.promiseChainRemote(\"%@\", %@);\n\
\n\
browser.init(desired).then(function() {\n\
\treturn browser\n", self.model.iOS.platformVersion, self.model.iOS.deviceName, self.model.iOS.appPath, self.model.general.serverAddress, self.model.general.serverPort];
}

- (NSString *)postCodeBoilerplate
{
	return @"\t\t.fin(function() {\n\
\t\t\treturn browser.quit();\n\
\t\t});\n\
}).done();\n";
}

- (NSString *)acceptAlert
{
	return [NSString stringWithFormat:@"%@.acceptAlert()\n", self.indentation];
}

- (NSString *)dismissAlert
{
	return [NSString stringWithFormat:@"%@.dismissAlert()\n", self.indentation];
}

- (NSString *)comment:(AppiumCodeMakerActionComment *)action
{
	return [self commentWithString:action.comment];
}

- (NSString *)commentWithString:(NSString *)comment
{
	return [NSString stringWithFormat:@"%@// %@\n", self.indentation, comment];
}

- (NSString *)preciseTap:(AppiumCodeMakerActionPreciseTap *)action
{
	NSDictionary *args = [((NSArray*)[action.params objectForKey:@"args"]) objectAtIndex:0];
	return [NSString stringWithFormat:@"%@.execute(\"mobile: tap\", \
{ \"tapCount\": %@, \
\"touchCount\": %@, \
\"duration\": %@, \
\"x\": %@, \
\"y\": %@ })\n", self.indentation, [args objectForKey:@"tapCount"], [args objectForKey:@"touchCount"], [args objectForKey:@"duration"], [args objectForKey:@"x"], [args objectForKey:@"y"]];
}

- (NSString *)scrollTo:(AppiumCodeMakerActionScrollTo *)action
{
	return [NSString stringWithFormat:@"%@.execute(\"mobile: scrollTo\", \
{ \"element\": %@.value })\n", self.indentation, [self locatorString:action.locator]];
}

- (NSString *)sendKeys:(AppiumCodeMakerActionSendKeys *)action
{
	return [NSString stringWithFormat:@"%@.%@.sendKeys(\"%@\")\n", self.indentation, [self locatorString:action.locator], action.keys];
}

- (NSString *)shake:(AppiumCodeMakerActionShake *)action
{
	return [NSString stringWithFormat:@"%@.shake()\n", self.indentation];
}

- (NSString *)swipe:(AppiumCodeMakerActionSwipe *)action
{
	NSDictionary *args = [((NSArray*)[action.params objectForKey:@"args"]) objectAtIndex:0];
	return [NSString stringWithFormat:@"%@.execute(\"mobile: swipe\", \
{ \"touchCount\": %@, \
\"startX\": %@, \
\"startY\": %@, \
\"endX\": %@, \
\"endY\": %@, \
\"duration\": %@ })\n", self.indentation, [args objectForKey:@"touchCount"], [args objectForKey:@"startX"], [args objectForKey:@"startY"], [args objectForKey:@"endX"], [args objectForKey:@"endY"], [args objectForKey:@"duration"]];
}

- (NSString *)tap:(AppiumCodeMakerActionTap *)action
{
	return [NSString stringWithFormat:@"%@.%@.click()\n", self.indentation, [self locatorString:action.locator]];
}

#pragma mark - Helper Methods

- (NSString *)escapeString:(NSString *)string
{
	return [string stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
}

- (NSString *)indentation
{
	return [self.codeMaker.useBoilerPlate boolValue] ? @"\t\t" : @"";
}

- (NSString *)locatorString:(AppiumCodeMakerLocator *)locator
{
	AppiumCodeMakerLocator *newLocator = [self.codeMaker.useXPathOnly boolValue] ? [[AppiumCodeMakerLocator alloc] initWithLocatorType:APPIUM_CODE_MAKER_LOCATOR_TYPE_XPATH locatorString:locator.xPath xPath:locator.xPath] : [locator copy];
	
	switch (newLocator.locatorType) {
		case APPIUM_CODE_MAKER_LOCATOR_TYPE_NAME:
			return [NSString stringWithFormat:@"elementByName(\"%@\")", [self escapeString:newLocator.locatorString]];
			break;
		case APPIUM_CODE_MAKER_LOCATOR_TYPE_XPATH:
			return [NSString stringWithFormat:@"elementByXPath(\"%@\")", [self escapeString:newLocator.locatorString]];
			break;
		default:
			return nil;
	}
}

@end
