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

- (NSString *)fileExtension
{
	return @"java";
}

-(NSString*) preCodeBoilerplateAndroid
{
	NSString *code = [NSString stringWithFormat:@"import io.appium.java_client.AppiumDriver;\n\
import org.openqa.selenium.remote.DesiredCapabilities;\n\
import java.net.URL;\n\
\n\
public class {scriptName} {\n\
\tpublic static void main(String[] args) {\n\
\t\tDesiredCapabilities capabilities = new DesiredCapabilities();\n\
\t\tcapabilities.setCapability(\"appium-version\", \"1.0\");\n\
\t\tcapabilities.setCapability(\"platformName\", \"%@\");\n\
\t\tcapabilities.setCapability(\"platformVersion\", \"%@\");\n", self.model.android.platformName, self.model.android.platformVersionNumber];
	
	if ([self.model.android.deviceName length] > 0)
	{
		code = [code stringByAppendingFormat:@"\t\tcapabilities.setCapability(\"deviceName\", \"%@\");\n", self.model.android.deviceName];
	}
	
	if ([self.model.android.appPath length] > 0)
	{
		code = [code stringByAppendingFormat:@"\t\tcapabilities.setCapability(\"app\", \"%@\");\n", self.model.android.appPath];
	}
	
	if ([self.model.android.package length] > 0)
	{
		code = [code stringByAppendingFormat:@"\t\tcapabilities.setCapability(\"appPackage\", \"%@\");\n", self.model.android.package];
	}
	
	if ([self.model.android.activity length] > 0)
	{
		code = [code stringByAppendingFormat:@"\t\tcapabilities.setCapability(\"appActivity\", \"%@\");\n", self.model.android.activity];
	}
	
	code = [code stringByAppendingFormat:@"\t\twd = new AppiumDriver(new URL(\"http://%@:%@/wd/hub\"), capabilities);\n\
\t\twd.manage().timeouts().implicitlyWait(60, TimeUnit.SECONDS);\n", self.model.general.serverAddress, self.model.general.serverPort];
	
	return code;
}

-(NSString*) preCodeBoilerplateiOS
{
	NSString *code = [NSString stringWithFormat:@"import io.appium.java_client.AppiumDriver;\n\
import org.openqa.selenium.remote.DesiredCapabilities;\n\
import java.net.URL;\n\
\n\
public class {scriptName} {\n\
\tpublic static void main(String[] args) {\n\
\t\tDesiredCapabilities capabilities = new DesiredCapabilities();\n\
\t\tcapabilities.setCapability(\"appium-version\", \"1.0\");\n\
\t\tcapabilities.setCapability(\"platformName\", \"iOS\");\n\
\t\tcapabilities.setCapability(\"platformVersion\", \"%@\");\n", self.model.iOS.platformVersion];
	
	if ([self.model.iOS.deviceName length] > 0)
	{
		code = [code stringByAppendingFormat:@"\t\tcapabilities.setCapability(\"deviceName\", \"%@\");\n", self.model.iOS.deviceName];
	}
	
	if ([self.model.iOS.appPath length] > 0)
	{
		code = [code stringByAppendingFormat:@"\t\tcapabilities.setCapability(\"app\", \"%@\");\n", self.model.iOS.appPath];
	}
	
	code = [code stringByAppendingFormat:@"\t\twd = new AppiumDriver(new URL(\"http://%@:%@/wd/hub\"), capabilities);\n\
\t\twd.manage().timeouts().implicitlyWait(60, TimeUnit.SECONDS);\n", self.model.general.serverAddress, self.model.general.serverPort];
	
	return code;
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

-(NSString*) executeScript:(AppiumCodeMakerActionExecuteScript*)action
{
	return [NSString stringWithFormat:@"%@(JavascriptExecutor)wd.executeScript(\"%@\", null);\n", self.indentation, [self escapeString:action.script]];
}

-(NSString*) preciseTap:(AppiumCodeMakerActionPreciseTap*)action
{
	NSDictionary *args = [((NSArray*)[action.params objectForKey:@"args"]) objectAtIndex:0];
	return [NSString stringWithFormat:@"(JavascriptExecutor)wd.executeScript(\"mobile: tap\", \
new HashMap<String, Double>() \
{{ \
put(\"tapCount\", %@); \
put(\"touchCount\", %@); \
put(\"duration\", %@); \
put(\"x\", %@); \
put(\"y\", %@); \
}});\n", [args objectForKey:@"tapCount"], [args objectForKey:@"touchCount"], [args objectForKey:@"duration"], [args objectForKey:@"x"], [args objectForKey:@"y"]];
}

- (NSString *)scrollTo:(AppiumCodeMakerActionScrollTo *)action
{
	return [NSString stringWithFormat:@"%@(JavascriptExecutor)wd.executeScript(\"mobile: scrollTo\", \
new HashMap<String, String>() \
{{ \
put(\"element\", %@.getId()); \
}});\n", self.indentation, [self locatorString:action.locator]];
}

-(NSString*) sendKeys:(AppiumCodeMakerActionSendKeys*)action
{
	return [NSString stringWithFormat:@"%@%@.sendKeys(\"%@\");\n", self.indentation, [self locatorString:action.locator], [self escapeString:action.keys]];
}

-(NSString*) shake:(AppiumCodeMakerActionShake*)action
{
	return [NSString stringWithFormat:@"%@wd.shake();\n", self.indentation];
}

-(NSString*) swipe:(AppiumCodeMakerActionSwipe*)action
{
	NSDictionary *args = [((NSArray*)[action.params objectForKey:@"args"]) objectAtIndex:0];
	return [NSString stringWithFormat:@"(JavascriptExecutor)wd.executeScript(\"mobile: swipe\", \
new HashMap<String, Double>() \
{{ \
put(\"touchCount\", %@); \
put(\"startX\", %@); \
put(\"startY\", %@); \
put(\"endX\", %@); \
put(\"endY\", %@); \
put(\"duration\", %@); \
}});\n", [args objectForKey:@"touchCount"], [args objectForKey:@"startX"], [args objectForKey:@"startY"], [args objectForKey:@"endX"], [args objectForKey:@"endY"], [args objectForKey:@"duration"]];
}

-(NSString*) tap:(AppiumCodeMakerActionTap*)action
{
	return [NSString stringWithFormat:@"%@%@.click();\n", self.indentation, [self locatorString:action.locator]];
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
			return [NSString stringWithFormat:@"wd.findElement(By.name(\"%@\"))", [self escapeString:newLocator.locatorString]];
		case APPIUM_CODE_MAKER_LOCATOR_TYPE_XPATH:
			return [NSString stringWithFormat:@"wd.findElement(By.xpath(\"%@\"))", [self escapeString:newLocator.locatorString]];
		default: return nil;
	}
}

@end
