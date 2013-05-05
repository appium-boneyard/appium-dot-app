//
//  AppiumCodeMakerJavaPlugin.m
//  Appium
//
//  Created by Dan Cuellar on 4/11/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerJavaPlugin.h"
#import "AppiumCodeMakerActions.h"

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


#pragma mark - AppiumCodeMakerPlugin Implementation
-(NSString*) name { return @"Java"; }

-(NSString*) preCodeBoilerplateAndroid
{
    return [NSString stringWithFormat:@"import java.util.concurrent.TimeUnit;\n\
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
\t\tDesiredCapabilities capabilities = new DesiredCapabilities();\n\
\t\tcapabilities.setCapability(\"device\", \"Android\");\n\
\t\tcapabilities.setCapability(CapabilityType.BROWSER_NAME, \"\");\n\
\t\tcapabilities.setCapability(CapabilityType.VERSION, \"6.1\");\n\
\t\tcapabilities.setCapability(CapabilityType.PLATFORM, \"Mac\");\n\
\t\tcapabilities.setCapability(\"app\", \"%@\");\n\
\t\tcapabilities.setCapability(\"app-package\", \"%@\");\n\
\t\tcapabilities.setCapability(\"app-activity\", \"%@\");\n\
\t\twd = new RemoteWebDriver(new URL(\"http://%@:%@/wd/hub\"), capabilities);\n\
\t\twd.manage().timeouts().implicitlyWait(60, TimeUnit.SECONDS);\n", self.model.appPath, self.model.androidPackage, self.model.androidActivity, self.model.ipAddress, self.model.port];
}

-(NSString*) preCodeBoilerplateiOS
{
    return [NSString stringWithFormat:@"import java.util.concurrent.TimeUnit;\n\
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
\t\tDesiredCapabilities capabilities = new DesiredCapabilities();\n\
\t\tcapabilities.setCapability(CapabilityType.BROWSER_NAME, \"iOS\");\n\
\t\tcapabilities.setCapability(CapabilityType.VERSION, \"6.1\");\n\
\t\tcapabilities.setCapability(CapabilityType.PLATFORM, \"Mac\");\n\
\t\tcapabilities.setCapability(\"app\", \"%@\");\n\
\t\twd = new RemoteWebDriver(new URL(\"http://%@:%@/wd/hub\"), capabilities);\n\
\t\twd.manage().timeouts().implicitlyWait(60, TimeUnit.SECONDS);\n", self.model.appPath, self.model.ipAddress, self.model.port];
}

-(NSString*) postCodeBoilerplate
{
    return
@"\t\twd.close();\n\
\t}\n\
}\n";
}

-(NSString*) acceptAlert
{
	return [NSString stringWithFormat:@"%@wd.switchTo().alert().accept();\n", self.indentation];
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
	return [NSString stringWithFormat:@"%@wd.switchTo().alert().dismiss();\n", self.indentation];
}

-(NSString*) sendKeys:(AppiumCodeMakerActionSendKeys*)action
{
	return [NSString stringWithFormat:@"%@wd.FindElement(%@).sendKeys(\"%@\");\n", self.indentation, [self locatorString:action.locator], [self escapeString:action.keys]];
}

-(NSString*) tap:(AppiumCodeMakerActionTap*)action
{
	return [NSString stringWithFormat:@"%@wd.click(%@);\n", self.indentation, [self locatorString:action.locator]];
}

#pragma mark - Helper Methods
-(NSString*) escapeString:(NSString *)string
{
    return [string stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
}

-(NSString*) indentation { return [self.codeMaker.useBoilerPlate boolValue] ? @"\t\t" : @""; }

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
