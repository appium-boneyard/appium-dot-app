//
//  AppiumCodeMakerJavaPlugin.m
//  Appium
//
//  Created by Dan Cuellar on 4/11/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerJavaPlugin.h"

@interface AppiumCodeMakerJavaPlugin ()

@property (readonly) NSString* indentation;

@end

@implementation AppiumCodeMakerJavaPlugin

-(id) initWithCodeMaker:(AppiumCodeMaker*)codeMaker
{
	self = [super init];
    if (self) {
        [self setCodeMaker:codeMaker];
    }
    return self;
}

-(NSString*) name { return @"Java"; }

-(NSString*) preCodeBoilerplate
{
    return
@"import java.util.concurrent.TimeUnit;\n\
import java.util.Date;\n\
import java.io.File;\n\
import org.openqa.selenium.support.ui.Select;\n\
import org.openqa.selenium.interactions.Actions;\n\
import org.openqa.selenium.firefox.FirefoxDriver;\n\
import org.openqa.selenium.*;\n\
import static org.openqa.selenium.OutputType.*;\n\
\n\
public class {scriptName} {\n\
\tpublic static void main(String[] args) {\n\
\t\tFirefoxDriver wd = new FirefoxDriver();\n\
\t\twd.manage().timeouts().implicitlyWait(60, TimeUnit.SECONDS);\n";
}

-(NSString*) postCodeBoilerplate
{
    return
@"\t\twd.close();\n\
\t}\n\
}\n";
}

-(NSString*) renderAction:(AppiumCodeMakerAction*)action
{
	switch(action.actionType)
	{
		case APPIUM_CODE_MAKER_ACTION_COMMENT:
			return [self comment:[action.params objectAtIndex:0]];
		case APPIUM_CODE_MAKER_ACTION_SEND_KEYS:
			return [self sendKeys:[action.params objectAtIndex:0] locator:[action.params objectAtIndex:1]];
		case APPIUM_CODE_MAKER_ACTION_TAP:
			return [self tap:[action.params objectAtIndex:0]];
		default:
			return nil;
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

-(NSString*) indentation { return [self.codeMaker.useBoilerPlate boolValue] ? @"\t\t" : @""; }

-(NSString*) comment:(NSString *)comment
{
	return [NSString stringWithFormat:@"%@// %@\n", self.indentation, comment];
}

-(NSString*) sendKeys:(NSString *)keys locator:(AppiumCodeMakerLocator*)locator
{
	return [NSString stringWithFormat:@"%@wd.FindElement(%@).sendKeys(\"%@\");\n", self.indentation, [self locatorString:locator], [self escapeString:keys]];
}

-(NSString*) tap:(AppiumCodeMakerLocator*)locator
{
	return [NSString stringWithFormat:@"%@wd.click(%@);\n", self.indentation, [self locatorString:locator]];
}

@end
