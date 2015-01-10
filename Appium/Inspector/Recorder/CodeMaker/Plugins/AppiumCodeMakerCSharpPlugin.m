//
//  AppiumCSharpCodeMaker.m
//  Appium
//
//  Created by Dan Cuellar on 4/8/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerCSharpPlugin.h"
#import "AppiumCodeMakerActions.h"

@interface AppiumCodeMakerCSharpPlugin ()

@property (readonly) NSString* indentation;

@end

@implementation AppiumCodeMakerCSharpPlugin 

-(id) initWithCodeMaker:(AppiumCodeMaker*)codeMaker
{
	self = [super init];
	if (self) {
		[self setCodeMaker:codeMaker];
	}
	return self;
}

#pragma mark - AppiumCodeMakerPlugin Implementation
-(NSString*) name { return @"C#"; }

- (NSString *)fileExtension
{
	return @"cs";
}

-(NSString*) preCodeBoilerplateAndroid
{
	NSString *code = [NSString stringWithFormat:@"using OpenQA.Selenium;\n\
using OpenQA.Selenium.Remote;\n\
using OpenQA.Selenium.Support.UI;\n\
using System;\n\
using System.Threading;\n\
\n\
namespace AppiumTests {\n\
\tpublic class RecordedTest {\n\
\t\tstatic void Main(string[] args) {\n\
\t\t\tDesiredCapabilities capabilities = new DesiredCapabilities();\n\
\t\t\tcapabilities.SetCapability(\"appium-version\", \"1.0\");\n\
\t\t\tcapabilities.SetCapability(\"platformName\", \"%@\");\n\
\t\t\tcapabilities.SetCapability(\"platformVersion\", \"%@\");\n", self.model.android.platformName, self.model.android.platformVersionNumber];
	
	if ([self.model.android.deviceName length] > 0)
	{
		code = [code stringByAppendingFormat:@"\t\t\tcapabilities.SetCapability(\"deviceName\", \"%@\");\n", self.model.android.deviceName];
	}
	
	if ([self.model.android.appPath length] > 0)
	{
		code = [code stringByAppendingFormat:@"\t\t\tcapabilities.SetCapability(\"app\", \"%@\");\n", self.model.android.appPath];
	}
	
	if ([self.model.android.package length] > 0)
	{
		code = [code stringByAppendingFormat:@"\t\t\tcapabilities.SetCapability(\"appPackage\", \"%@\");\n", self.model.android.package];
	}
	
	if ([self.model.android.activity length] > 0)
	{
		code = [code stringByAppendingFormat:@"\t\t\tcapabilities.SetCapability(\"appActivity\", \"%@\");\n", self.model.android.activity];
	}
	
	code = [code stringByAppendingFormat:@"\t\t\tRemoteWebDriver wd = new RemoteWebDriver(new Uri(\"http://%@:%@/wd/hub\"), capabilities);\n\
\t\t\ttry {\n", self.model.general.serverAddress, self.model.general.serverPort];

	return code;
}

-(NSString*) preCodeBoilerplateiOS
{
	NSString *code = [NSString stringWithFormat: @"using OpenQA.Selenium;\n\
using OpenQA.Selenium.Remote;\n\
using OpenQA.Selenium.Support.UI;\n\
using System;\n\
using System.Threading;\n\
\n\
namespace AppiumTests {\n\
\tpublic class RecordedTest {\n\
\t\tstatic void Main(string[] args) {\n\
\t\t\tDesiredCapabilities capabilities = new DesiredCapabilities();\n\
\t\t\tcapabilities.SetCapability(\"appium-version\", \"1.0\");\n\
\t\t\tcapabilities.SetCapability(\"platformName\", \"iOS\");\n\
\t\t\tcapabilities.SetCapability(\"platformVersion\", \"%@\");\n", self.model.iOS.platformVersion];
		
	if ([self.model.iOS.deviceName length] > 0)
	{
		code = [code stringByAppendingFormat:@"\t\t\tcapabilities.SetCapability(\"deviceName\", \"%@\");\n", self.model.iOS.deviceName];
	}
	
	if ([self.model.iOS.appPath length] > 0)
	{
		code = [code stringByAppendingFormat:@"\t\t\tcapabilities.SetCapability(\"app\", \"%@\");\n", self.model.iOS.appPath];
	}
	
	code = [code stringByAppendingFormat:@"\t\t\tRemoteWebDriver wd = new RemoteWebDriver(new Uri(\"http://%@:%@/wd/hub\"), capabilities);\n\
\t\t\ttry {\n", self.model.general.serverAddress, self.model.general.serverPort];
	
	return code;
}

-(NSString*) postCodeBoilerplate
{
	return
@"\t\t\t} finally { wd.Quit(); }\n\
\t\t}\n\
\n\
\t\tpublic static bool isAlertPresent(IWebDriver wd) {\n\
\t\t\ttry {\n\
\t\t\t\twd.SwitchTo().Alert();\n\
\t\t\t\t\treturn true;\n\
\t\t\t\t} catch (NoAlertPresentException e) {\n\
\t\t\t\t\treturn false;\n\
\t\t\t\t}\n\
\t\t\t}\n\
\t\t}\n}\n";
}

-(NSString*) acceptAlert
{
	return [NSString stringWithFormat:@"%@wd.SwitchTo().Alert().Accept();\n", self.indentation];
}

-(NSString*) comment:(AppiumCodeMakerActionComment*)action
{
	return [self commentWithString:action.comment];
}

-(NSString*) commentWithString:(NSString *)comment
{
	return [NSString stringWithFormat:@"%@// %@\n", self.indentation, comment];
}

-(NSString*) dismissAlert
{
	return [NSString stringWithFormat:@"%@wd.SwitchTo().Alert().Dismiss();\n", self.indentation];
}

-(NSString*) executeScript:(AppiumCodeMakerActionExecuteScript*)action
{
	return [NSString stringWithFormat:@"%@wd.ExecuteScript(\"%@\", null);\n", self.indentation, [self escapeString:action.script]];
}

-(NSString*) preciseTap:(AppiumCodeMakerActionPreciseTap*)action
{
	NSDictionary *args = [((NSArray*)[action.params objectForKey:@"args"]) objectAtIndex:0];
	return [NSString stringWithFormat:@"wd.ExecuteScript(\"mobile: tap\", \
new Dictionary<string, double>() \
{ \
{ \"tapCount\", %@ }, \
{ \"touchCount\", %@ }, \
{ \"duration\", %@ }, \
{ \"x\", %@ }, \
{ \"y\", %@ } \
});\n", [args objectForKey:@"tapCount"], [args objectForKey:@"touchCount"], [args objectForKey:@"duration"], [args objectForKey:@"x"], [args objectForKey:@"y"]];
}

-(NSString*) sendKeys:(AppiumCodeMakerActionSendKeys*)action
{
	return [NSString stringWithFormat:@"%@wd.FindElement(%@).SendKeys(\"%@\");\n", self.indentation, [self locatorString:action.locator], [self escapeString:action.keys]];
}

-(NSString*) swipe:(AppiumCodeMakerActionSwipe*)action
{
	NSDictionary *args = [((NSArray*)[action.params objectForKey:@"args"]) objectAtIndex:0];
	return [NSString stringWithFormat:@"wd.ExecuteScript(\"mobile: swipe\", \
new Dictionary<string, double>() \
{ \
{ \"touchCount\", %@ }, \
{ \"startX\", %@ }, \
{ \"startY\", %@ }, \
{ \"endX\", %@ }, \
{ \"endY\", %@ }, \
{ \"duration\", %@ } \
});\n", [args objectForKey:@"touchCount"], [args objectForKey:@"startX"], [args objectForKey:@"startY"], [args objectForKey:@"endX"], [args objectForKey:@"endY"], [args objectForKey:@"duration"]];
}

-(NSString*) shake:(AppiumCodeMakerActionShake*)action
{
	return [NSString stringWithFormat:@"%@wd.ShakeDevice();\n", self.indentation];
}

-(NSString*) tap:(AppiumCodeMakerActionTap*)action
{
	return [NSString stringWithFormat:@"%@wd.Click(%@);\n", self.indentation, [self locatorString:action.locator]];
}

#pragma mark - Helper Methods
-(NSString*) escapeString:(NSString *)string
{
	return [string stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
}

-(NSString*) indentation { return [self.codeMaker.useBoilerPlate boolValue] ? @"\t\t\t\t" : @""; }

-(NSString*) locatorString:(AppiumCodeMakerLocator*)locator
{
	AppiumCodeMakerLocator *newLocator = [self.codeMaker.useXPathOnly boolValue] ? [[AppiumCodeMakerLocator alloc] initWithLocatorType:APPIUM_CODE_MAKER_LOCATOR_TYPE_XPATH locatorString:locator.xPath xPath:locator.xPath] : [locator copy];
	
	switch(newLocator.locatorType)
	{
		case APPIUM_CODE_MAKER_LOCATOR_TYPE_NAME:
			return [NSString stringWithFormat:@"By.Name(\"%@\")", [self escapeString:newLocator.locatorString]];
		case APPIUM_CODE_MAKER_LOCATOR_TYPE_XPATH:
			return [NSString stringWithFormat:@"By.Xpath(\"%@\")", [self escapeString:newLocator.locatorString]];
		default: return nil;
	}
}

@end
