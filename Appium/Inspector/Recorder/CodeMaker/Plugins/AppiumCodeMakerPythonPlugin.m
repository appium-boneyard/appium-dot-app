//
//  AppiumCodeMakerPythonPlugin.m
//  Appium
//
//  Created by Dan Cuellar on 4/11/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumCodeMakerPythonPlugin.h"
#import "AppiumCodeMakerActions.h"

@interface AppiumCodeMakerPythonPlugin ()

@property (readonly) NSString* indentation;

@end

@implementation AppiumCodeMakerPythonPlugin

-(id) initWithCodeMaker:(AppiumCodeMaker*)codeMaker
{
	self = [super init];
	if (self) {
		[self setCodeMaker:codeMaker];
	}
	return self;
}

#pragma mark - AppiumCodeMakerPlugin Implementation
-(NSString*) name { return @"Python"; }

- (NSString *)fileExtension
{
	return @"py";
}

-(NSString*) preCodeBoilerplateAndroid
{
	NSString *code = [NSString stringWithFormat:@"from selenium.webdriver.firefox.webdriver import WebDriver\n\
from selenium.webdriver.common.action_chains import ActionChains\n\
import time\n\
\n\
success = True\n\
desired_caps = {}\n\
desired_caps['appium-version'] = '1.0'\n\
desired_caps['platformName'] = '%@'\n\
desired_caps['platformVersion'] = '%@'\n", self.model.android.platformName, self.model.android.platformVersionNumber];
	
	if ([self.model.android.deviceName length] > 0)
	{
		code = [code stringByAppendingFormat:@"desired_caps['deviceName'] = '%@'\n", self.model.android.deviceName];
	}
	
	if ([self.model.android.appPath length] > 0)
	{
		code = [code stringByAppendingFormat:@"desired_caps['app'] = os.path.abspath('%@')\n", self.model.android.appPath];
	}
	
	if ([self.model.android.package length] > 0)
	{
		code = [code stringByAppendingFormat:@"desired_caps['appPackage'] = '%@'\n", self.model.android.package];
	}
	
	if ([self.model.android.activity length] > 0)
	{
		code = [code stringByAppendingFormat:@"desired_caps['appActivity'] = '%@'\n", self.model.android.activity];
	}
	
	code = [code stringByAppendingFormat:@"\n\
wd = webdriver.Remote('http://%@:%@/wd/hub', desired_caps)\n\
wd.implicitly_wait(60)\n\
\n\
def is_alert_present(wd):\n\
\ttry:\n\
\t\twd.switch_to_alert().text\n\
\t\treturn True\n\
\texcept:\n\
\t\treturn False\n\
\n\
try:\n", self.model.general.serverAddress, self.model.general.serverPort];
	
	return code;
}

-(NSString*) preCodeBoilerplateiOS
{
	NSString *code = [NSString stringWithFormat:@"from selenium.webdriver.firefox.webdriver import WebDriver\n\
from selenium.webdriver.common.action_chains import ActionChains\n\
import time\n\
\n\
success = True\n\
desired_caps = {}\n\
desired_caps['appium-version'] = '1.0'\n\
desired_caps['platformName'] = 'iOS'\n\
desired_caps['platformVersion'] = '%@'\n", self.model.iOS.platformVersion];
	
	if ([self.model.iOS.deviceName length] > 0)
	{
		code = [code stringByAppendingFormat:@"desired_caps['deviceName'] = '%@'\n", self.model.iOS.deviceName];
	}
	
	if ([self.model.iOS.appPath length] > 0)
	{
		code = [code stringByAppendingFormat:@"desired_caps['app'] = os.path.abspath('%@')\n", self.model.iOS.appPath];
	}
	
	code = [code stringByAppendingFormat:@"\n\
wd = webdriver.Remote('http://%@:%@/wd/hub', desired_caps)\n\
wd.implicitly_wait(60)\n\
\n\
def is_alert_present(wd):\n\
\ttry:\n\
\t\twd.switch_to_alert().text\n\
\t\treturn True\n\
\texcept:\n\
\t\treturn False\n\
\n\
try:\n", self.model.general.serverAddress, self.model.general.serverPort];
	
	return code;
}

-(NSString*) postCodeBoilerplate
{
	return
@"finally:\n\
\twd.quit()\n\
\tif not success:\n\
\t\traise Exception(\"Test failed.\")\n";
}

-(NSString*) acceptAlert
{
	return [NSString stringWithFormat:@"%@wd.switch_to_alert().accept()\n", self.indentation];
}

-(NSString*) comment:(AppiumCodeMakerActionComment*)action
{
	return [self commentWithString:action.comment];
}

-(NSString*) commentWithString:(NSString*)comment
{
	return [NSString stringWithFormat:@"%@# %@\n", self.indentation, comment];
}

-(NSString*) dismissAlert
{
	return [NSString stringWithFormat:@"%@wd.switch_to_alert().dismiss()\n", self.indentation];
}

-(NSString*) executeScript:(AppiumCodeMakerActionExecuteScript*)action
{
	return [NSString stringWithFormat:@"%@wd.execute_script(\"%@\", None);\n", self.indentation, [self escapeString:action.script]];
}

-(NSString*) preciseTap:(AppiumCodeMakerActionPreciseTap*)action
{
	NSDictionary *args = [((NSArray*)[action.params objectForKey:@"args"]) objectAtIndex:0];
	return [NSString stringWithFormat:@"wd.execute_script(\"mobile: tap\", {\
\"tapCount\": %@, \
\"touchCount\": %@, \
\"duration\": %@, \
\"x\": %@, \
\"y\": %@ \
})\n", [args objectForKey:@"tapCount"], [args objectForKey:@"touchCount"], [args objectForKey:@"duration"], [args objectForKey:@"x"], [args objectForKey:@"y"]];
}

-(NSString*) sendKeys:(AppiumCodeMakerActionSendKeys*)action
{
	return [NSString stringWithFormat:@"%@%@.send_keys(\"%@\")\n", self.indentation, [self locatorString:action.locator], [self escapeString:action.keys]];
}

-(NSString*) shake:(AppiumCodeMakerActionShake*)action
{
	return [NSString stringWithFormat:@"%@wd.shake();\n", self.indentation];
}

-(NSString*) swipe:(AppiumCodeMakerActionSwipe*)action
{
	NSDictionary *args = [((NSArray*)[action.params objectForKey:@"args"]) objectAtIndex:0];
	return [NSString stringWithFormat:@"wd.execute_script(\"mobile: swipe\", {\
\"touchCount\": %@ , \
\"startX\": %@, \
\"startY\": %@, \
\"endX\": %@, \
\"endY\": %@, \
\"duration\": %@ \
})\n", [args objectForKey:@"touchCount"], [args objectForKey:@"startX"], [args objectForKey:@"startY"], [args objectForKey:@"endX"], [args objectForKey:@"endY"], [args objectForKey:@"duration"]];
}

-(NSString*) tap:(AppiumCodeMakerActionTap*)action
{
	return [NSString stringWithFormat:@"%@%@.click()\n", self.indentation, [self locatorString:action.locator]];
}

#pragma mark - Helper Methods
-(NSString*) escapeString:(NSString *)string
{
	return [string stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
}

-(NSString*) indentation { return [self.codeMaker.useBoilerPlate boolValue] ? @"\t" : @""; }

-(NSString*) locatorString:(AppiumCodeMakerLocator*)locator
{
	AppiumCodeMakerLocator *newLocator = [self.codeMaker.useXPathOnly boolValue] ? [[AppiumCodeMakerLocator alloc] initWithLocatorType:APPIUM_CODE_MAKER_LOCATOR_TYPE_XPATH locatorString:locator.xPath xPath:locator.xPath] : [locator copy];
	
	switch(newLocator.locatorType)
	{
		case APPIUM_CODE_MAKER_LOCATOR_TYPE_NAME:
			return [NSString stringWithFormat:@"wd.find_element_by_name(\"%@\")", [self escapeString:newLocator.locatorString]];
		case APPIUM_CODE_MAKER_LOCATOR_TYPE_XPATH:
			return [NSString stringWithFormat:@"wd.find_element_by_xpath(\"%@\")", [self escapeString:newLocator.locatorString]];
		default: return nil;
	}
}

@end
