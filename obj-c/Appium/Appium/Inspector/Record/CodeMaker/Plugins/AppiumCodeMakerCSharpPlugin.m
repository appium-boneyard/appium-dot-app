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

-(NSString*) name { return @"C#"; }

-(NSString*) preCodeBoilerplate
{
    return
@"using OpenQA.Selenium;\n\
using OpenQA.Selenium.Remote;\n\
using OpenQA.Selenium.Support.UI;\n\
using System;\n\
using System.Threading;\n\
\n\
namespace AppiumTests {\n\
\tpublic class RecordedTest {\n\
\t\tstatic void Main(string[] args) {\n\
\t\t\tIWebDriver wd = new RemoteWebDriver(DesiredCapabilities.Firefox());\n\
\t\t\ttry {\n";
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

-(NSString*) renderAction:(AppiumCodeMakerAction*)action
{
	switch(action.actionType)
	{
		case APPIUM_CODE_MAKER_ACTION_ALERT_ACCEPT:
			return [self acceptAlert];
		case APPIUM_CODE_MAKER_ACTION_ALERT_DISMISS:
			return [self dismissAlert];
		case APPIUM_CODE_MAKER_ACTION_COMMENT:
			return [self comment:((AppiumCodeMakerActionComment*)action).comment];
		case APPIUM_CODE_MAKER_ACTION_SEND_KEYS:
			return [self sendKeys:((AppiumCodeMakerActionSendKeys*)action).keys locator:((AppiumCodeMakerActionSendKeys*)action).locator];
		case APPIUM_CODE_MAKER_ACTION_TAP:
			return [self tap:((AppiumCodeMakerActionTap*)action).locator];
		default:
			return [self comment:@"Action cannot currently be transcribed by Appium Recorder"];
	}
}

-(NSString*) escapeString:(NSString *)string
{
    return [string stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
}

-(NSString*) locatorString:(AppiumCodeMakerLocator*)locator
{
	AppiumCodeMakerLocator *newLocator = [_codeMaker.useXPathOnly boolValue] ? [[AppiumCodeMakerLocator alloc] initWithLocatorType:APPIUM_CODE_MAKER_LOCATOR_TYPE_XPATH locatorString:locator.xPath] : [locator copy];
	
	switch(newLocator.locatorType)
	{
		case APPIUM_CODE_MAKER_LOCATOR_TYPE_NAME:
			return [NSString stringWithFormat:@"By.Name(\"%@\")", [self escapeString:newLocator.locatorString]];
		case APPIUM_CODE_MAKER_LOCATOR_TYPE_XPATH:
			return [NSString stringWithFormat:@"By.Xpath(\"%@\")", [self escapeString:newLocator.locatorString]];
		default: return nil;
	}
}

-(NSString*) indentation { return [self.codeMaker.useBoilerPlate boolValue] ? @"\t\t\t\t" : @""; }

-(NSString*) acceptAlert
{
	return [NSString stringWithFormat:@"%@wd.SwitchTo().Alert().Accept();\n", self.indentation];
}

-(NSString*) comment:(NSString *)comment
{
	return [NSString stringWithFormat:@"%@// %@\n", self.indentation, comment];
}

-(NSString*) dismissAlert
{
	return [NSString stringWithFormat:@"%@wd.SwitchTo().Alert().Dismiss();\n", self.indentation];
}

-(NSString*) sendKeys:(NSString *)keys locator:(AppiumCodeMakerLocator*)locator
{
	return [NSString stringWithFormat:@"%@wd.FindElement(%@).SendKeys(\"%@\");\n", self.indentation, [self locatorString:locator], [self escapeString:keys]];
}

-(NSString*) tap:(AppiumCodeMakerLocator*)locator
{
	return [NSString stringWithFormat:@"%@wd.Click(%@);\n", self.indentation, [self locatorString:locator]];
}

@end
