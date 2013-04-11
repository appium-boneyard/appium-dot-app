//
//  AppiumCSharpCodeMaker.m
//  Appium
//
//  Created by Dan Cuellar on 4/8/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerPluginCSharp.h"

@implementation AppiumCodeMakerPluginCSharp

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

-(NSString*) xPath:(NSString*)xpath
{
	
	return [NSString stringWithFormat:@"By.Xpath(\"%@\")", [self escapeString:xpath]];
}

-(NSString*) escapeString:(NSString *)string
{
    return [string stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
}

-(NSString*) renderAction:(AppiumCodeMakerAction*)action
{
	switch(action.actionType)
	{
		case APPIUM_CODE_MAKER_ACTION_COMMENT:
			return [self comment:[action.params objectAtIndex:0]];
		case APPIUM_CODE_MAKER_ACTION_SEND_KEYS:
			return [self sendKeys:[action.params objectAtIndex:0] element:[action.params objectAtIndex:1]];
		case APPIUM_CODE_MAKER_ACTION_TAP:
			return [self tap:[action.params objectAtIndex:0]];
		default:
			return nil;
	}
}

-(NSString*) comment:(NSString *)comment
{
	return [NSString stringWithFormat:@"\t\t\t\t// %@\n", comment];
}

-(NSString*) sendKeys:(NSString *)keys element:(NSString*)xpath
{
	return [NSString stringWithFormat:@"\t\t\t\twd.FindElement(%@).SendKeys(\"%@\");\n", [self xPath:xpath], [self escapeString:keys]];
}

-(NSString*) tap:(NSString *)xpath
{
	return [NSString stringWithFormat:@"\t\t\t\twd.Click(%@);\n", [self xPath:xpath]];
}


@end
