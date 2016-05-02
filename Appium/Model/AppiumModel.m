//
//  AppiumModel.m
//  Appium
//
//  Created by Dan Cuellar on 3/12/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumModel.h"

#import <Foundation/Foundation.h>
#import "AppiumAppDelegate.h"
#import "AppiumPreferencesFile.h"
#import "NSString+trimLeadingWhitespace.h"
#import "SBJsonParser.h"
#import "SocketIOPacket.h"
#import "Utility.h"
#import "NSObject+Properties.h"
#import "AppiumServerArgument.h"

#pragma  mark - Model

BOOL _isServerRunning;
BOOL _isServerListening;

@implementation AppiumModel

- (id)init
{
    self = [super init];
	
    if (self)
	{
		// initialize settings
		NSString *filePath = [[NSBundle mainBundle] pathForResource:@"defaults" ofType:@"plist"];
		NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
		[[NSUserDefaults standardUserDefaults] registerDefaults:settingsDict];
		[[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:settingsDict];

		// create submodels
	    [self setAndroid:[AppiumAndroidSettingsModel new]];
		[self setDeveloper:[AppiumDeveloperSettingsModel new]];
		[self setGeneral:[AppiumGeneralSettingsModel new]];
		[self setIOS:[AppiumiOSSettingsModel new]];
		[self setRobot:[AppiumRobotSettingsModel new]];
		
		// initialize members
		_isServerRunning = NO;
		_isServerListening = self.general.useRemoteServer;
        [self setDoctorSocketIsConnected:NO];
    }
	
    return self;
}

#pragma mark - Properties

-(BOOL) isAndroid { return self.platform == AppiumAndroidPlatform; }
-(void) setIsAndroid:(BOOL)isAndroid {
	[self setPlatform: isAndroid ? AppiumAndroidPlatform : AppiumiOSPlatform];
}
-(BOOL) isIOS { return self.platform == AppiumiOSPlatform; }
-(void) setIsIOS:(BOOL)isIOS {
	[self setPlatform: isIOS ? AppiumiOSPlatform : AppiumAndroidPlatform];
}

-(BOOL) isServerRunning { return _isServerRunning; }
-(void) setIsServerRunning:(BOOL)isServerRunning
{
	_isServerRunning = isServerRunning;
	_isServerListening = isServerRunning ? _isServerListening : NO;
	
	if (!isServerRunning)
	{
		[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] closeInspector];
	}
}

-(BOOL) isServerListening { return _isServerListening; }
-(void) setIsServerListening:(BOOL)isServerListening { _isServerListening = isServerListening; }


-(AppiumPlatform)platform
{
    return [DEFAULTS boolForKey:APPIUM_PLIST_PLATFORM_IS_ANDROID] ? AppiumAndroidPlatform : AppiumiOSPlatform;
}
-(void)setPlatform:(AppiumPlatform)platform
{
	[DEFAULTS setBool:(platform == AppiumAndroidPlatform) forKey:APPIUM_PLIST_PLATFORM_IS_ANDROID];
}

#pragma mark - Methods

-(BOOL)killServer
{
    if (self.serverTask != nil && [self.serverTask isRunning])
    {
        [self.serverTask terminate];
		[self setIsServerRunning:NO];
        return YES;
    }
    return NO;
}

-(BOOL)startServer
{
    int myPid = (self.serverTask != nil) ? self.serverTask.processIdentifier : -1;
    if ([self killServer])
    {
        return NO;
    }
	
    // kill any processes using the appium server port
    if (self.general.killProcessesUsingPort)
    {
        NSNumber *procPid = [Utility getPidListeningOnPort:self.general.serverPort];
        if (procPid != nil && myPid != [procPid intValue])
        {
            NSString *script = [NSString stringWithFormat:@"kill `lsof -t -i:%@`", self.general.serverPort];
            system([script UTF8String]);
			system([@"killall -z lsof" UTF8String]);
        }
    }
	
	NSMutableString *nodeDebugArguments = [NSMutableString string];
	
	if (self.developer.useNodeDebugging)
	{
		[nodeDebugArguments appendFormat:@" --debug=%@", [AppiumServerArgument parseIntegerValue:self.developer.nodeJSDebugPort]];
		
		if (self.developer.breakOnNodeApplicationStart)
		{
			[nodeDebugArguments appendFormat:@" --debug-brk"];
		}
	}
	
	NSMutableArray  *arguments = [NSMutableArray array];
	NSMutableString *command;
	
	if (self.developer.developerMode && self.developer.useExternalNodeJSBinary)
	{
		command = [NSMutableString stringWithFormat:@"'%@'%@ build/lib/main.js", self.developer.externalNodeJSBinaryPath, nodeDebugArguments];
	}
	else
	{
		command = [NSMutableString stringWithFormat:@"'%@%@'%@ build/lib/main.js", [[NSBundle mainBundle] resourcePath], @"/node/bin/node", nodeDebugArguments];
	}
	
#pragma mark General Preferences
	
	if (![self.general.serverAddress isEqualTo:@"0.0.0.0"])
	{
		[arguments addObject:[AppiumServerArgument argumentWithName:@"--address"
														  withValue:self.general.serverAddress]];
    }
	
	if (![[self.general.serverPort stringValue] isEqualToString:@"4723"])
	{
		[arguments addObject:[AppiumServerArgument argumentWithName:@"--port"
														  withValue:[AppiumServerArgument parseIntegerValue:self.general.serverPort]]];
    }
	
	if (self.general.useCallbackAddress)
	{
		[arguments addObject:[AppiumServerArgument argumentWithName:@"--callback-address"
														  withValue:self.general.callbackAddress]];
	}
	
	if (self.general.useCallbackPort)
	{
		[arguments addObject:[AppiumServerArgument argumentWithName:@"--callback-port"
														  withValue:[AppiumServerArgument parseIntegerValue:self.general.callbackPort]]];
	}
	
	if (self.general.useCommandTimeout)
	{
		[arguments addObject:[AppiumServerArgument argumentWithName:@"--command-timeout"
														  withValue:[AppiumServerArgument parseIntegerValue:self.general.commandTimeout]]];
	}
	
    if (self.general.overrideExistingSessions)
	{
		[arguments addObject:[AppiumServerArgument argumentWithName:@"--session-override"]];
    }
	
	if (self.general.bypassPermissionsCheck)
	{
		[arguments addObject:[AppiumServerArgument argumentWithName:@"--no-perms-check"]];
	}
	
	if (self.general.prelaunchApp)
	{
		[arguments addObject:[AppiumServerArgument argumentWithName:@"--pre-launch"]];
    }
	
	if (!self.general.logColors)
	{
		[arguments addObject:[AppiumServerArgument argumentWithName:@"--log-no-colors"]];
    }

	if (!self.general.useAdditionalLogSpacing)
	{
		[arguments addObject:[AppiumServerArgument argumentWithName:@"--debug-log-spacing"]];
	}
	
	if (self.general.useLogFile)
	{
		[arguments addObject:[AppiumServerArgument argumentWithName:@"--log"
														  withValue:self.general.logFile]];
    }
	
	if (self.general.logTimestamps)
	{
		[arguments addObject:[AppiumServerArgument argumentWithName:@"--log-timestamp"]];
    }
	
	if (![self.general.logLevel isEqualToString:@"default"] && self.general.logLevel.length > 0)
	{
		[arguments addObject:[AppiumServerArgument argumentWithName:@"--log-level"
														  withValue:self.general.logLevel]];
	}
	
    if (self.general.useLogWebHook)
	{
		[arguments addObject:[AppiumServerArgument argumentWithName:@"--webhook"
														  withValue:self.general.logWebHook]];
    }
	
	if (self.general.useTempFolderPath)
	{
		[arguments addObject:[AppiumServerArgument argumentWithName:@"--tmp"
														  withValue:self.general.tempFolderPath]];
	}
	
    if (self.general.useSeleniumGridConfigFile)
	{
		[arguments addObject:[AppiumServerArgument argumentWithName:@"--nodeconfig"
														  withValue:self.general.seleniumGridConfigFile]];
    }
	
	if (self.general.useLocalTimezone)
	{
		[arguments addObject:[AppiumServerArgument argumentWithName:@"--local-timezone"]];
	}
	
	if (self.general.useStrictCapabilities)
	{
		[arguments addObject:[AppiumServerArgument argumentWithName:@"--strict-caps"]];
	}
	
#pragma mark Robot Preferences
	
	if (self.robot.useRobot)
    {
		[arguments addObject:[AppiumServerArgument argumentWithName:@"--robot-address"
														  withValue:self.robot.robotAddress]];
		[arguments addObject:[AppiumServerArgument argumentWithName:@"--robot-port"
														  withValue:[AppiumServerArgument parseIntegerValue:self.robot.robotPort]]];
	}
	
	// platform specific preferences
	switch (self.platform)
	{
#pragma mark Android Preferences
		case AppiumAndroidPlatform:
		{
			// get version number from string
			[arguments addObject:[AppiumServerArgument argumentWithName:@"--automation-name"
															  withValue:self.android.automationName]];
			[arguments addObject:[AppiumServerArgument argumentWithName:@"--platform-name"
															  withValue:self.android.platformName]];
			[arguments addObject:[AppiumServerArgument argumentWithName:@"--platform-version"
															  withValue:self.android.platformVersionNumber]];
			
			if (self.android.useAppPath || self.android.useBrowser)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--app"
																  withValue:self.android.useBrowser ? @"browser" : self.android.appPath]];
			}
			
			if (self.android.fullReset)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--full-reset"]];
			}
			else if (self.android.noReset)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--no-reset"]];
			}
			if (self.android.dontStopAppOnReset) {
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--dont-stop-app-on-reset"]];
			}
			
			if (self.android.useAVD)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--avd"
																  withValue:self.android.avd]];
				
				if (self.android.useAVDArguments)
				{
					[arguments addObject:[AppiumServerArgument argumentWithName:@"--avd-args"
																	  withValue:self.android.avdArguments]];
				}
			}
			
			if (!self.android.useBrowser)
			{
				if (self.android.useChromedriverExecutablePath) {
					[arguments addObject:[AppiumServerArgument argumentWithName:@"--chromedriver-executable"
																	  withValue:self.android.chromedriverExecutablePath]];
				}
				
				if (self.android.useChromedriverPort)
				{
					[arguments addObject:[AppiumServerArgument argumentWithName:@"--chromedriver-port"
																	  withValue:[AppiumServerArgument parseIntegerValue:self.android.chromedriverPort]]];
				}
				
				if (self.android.usePackage)
				{
					[arguments addObject:[AppiumServerArgument argumentWithName:@"--app-pkg"
																	  withValue:self.android.package]];
				}
				
				if (self.android.useActivity)
				{
					[arguments addObject:[AppiumServerArgument argumentWithName:@"--app-activity"
																	  withValue:self.android.activity]];
				}
				
				if (self.android.useWaitPackage)
				{
					[arguments addObject:[AppiumServerArgument argumentWithName:@"--app-wait-package"
																	  withValue:self.android.waitPackage]];
				}
				
				if (self.android.useWaitActivity)
				{
					[arguments addObject:[AppiumServerArgument argumentWithName:@"--app-wait-activity"
																	  withValue:self.android.waitActivity]];
				}
			}
			else
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--browser-name"
																  withValue:(self.android.browserName.length != 0) ? self.android.browserName : @"Chrome"]];
			}
			
			if (self.android.useCoverageClass)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--coverage-class"
																  withValue:self.android.coverageClass]];
			}
			
			if (self.android.useDeviceName)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--device-name"
																  withValue:self.android.deviceName]];
			}
			
			if (self.android.useDeviceReadyTimeout)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--device-ready-timeout"
																  withValue:[AppiumServerArgument parseIntegerValue:self.android.deviceReadyTimeout]]];
			}
			
			if (self.android.useLanguage)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--language"
																  withValue:self.android.language]];
			}
			
			if (self.android.useLocale)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--locale"
																  withValue:self.android.locale]];
			}
			
			if ([self.android.automationName isEqualToString:@"Selendroid"])
			{
				if (self.android.selendroidPort)
				{
					[arguments addObject:[AppiumServerArgument argumentWithName:@"--selendroid-port"
																	  withValue:[AppiumServerArgument parseIntegerValue:self.android.selendroidPort]]];
				}
			}
			else if (self.android.useBootstrapPort)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--bootstrap-port"
																  withValue:[AppiumServerArgument parseIntegerValue:self.android.bootstrapPort]]];
			}
			
			if (self.android.useIntentAction)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--intent-action"
																  withValue:self.android.intentAction]];
			}
			
			if (self.android.useIntentCategory)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--intent-category"
																  withValue:self.android.intentCategory]];
			}
			
			if (self.android.useIntentFlags)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--intent-flags"
																  withValue:self.android.intentFlags]];
			}
			
			if (self.android.useIntentArguments)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--intent-args"
																  withValue:self.android.intentArguments]];
			}
			
			if (self.android.useKeystore)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--use-keystore"]];
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--keystore-path"
																  withValue:self.android.keystorePath]];
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--keystore-password"
																  withValue:self.android.keystorePassword]];
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--key-alias"
																  withValue:self.android.keyAlias]];
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--key-password"
																  withValue:self.android.keyPassword]];
			}
			
			break;
		}
#pragma mark iOS Preferences
		case AppiumiOSPlatform:
		{
			[arguments addObject:[AppiumServerArgument argumentWithName:@"--platform-version" withValue:self.iOS.platformVersion]];
			[arguments addObject:[AppiumServerArgument argumentWithName:@"--platform-name" withValue:@"iOS"]];
			
			if (self.iOS.useMobileSafari)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--safari"]];
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--browser-name"
																  withValue:@"Safari"]];
			}
			else if (self.iOS.useBundleID)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--app"
																  withValue:self.iOS.bundleID]];
			}
			else if (self.iOS.useAppPath)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--app"
																  withValue:self.iOS.appPath]];
			}
			
			if (self.iOS.useUDID)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--udid"
																  withValue:self.iOS.udid]];
			}
			
			if (self.iOS.fullReset)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--full-reset"]];
			}
			
			if (self.iOS.noReset)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--no-reset"]];
			}
			
			if (self.iOS.keepKeychains)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--keep-keychains"]];
			}
			
			if (self.iOS.showSimulatorLog)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--show-ios-log"]];
			}
			
			if (self.iOS.showSystemLog)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--show-ios-log"]];
			}
			
			
			if (self.iOS.useBackendRetries)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--backend-retries"
																  withValue:[AppiumServerArgument parseIntegerValue:self.iOS.backendRetries]]];
			}
			
			if (self.iOS.useCalendar)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--calendar"
																  withValue:self.iOS.calendarFormat]];
			}
			
			if (self.iOS.useCustomTraceTemplate)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--tracetemplate"
																  withValue:self.iOS.customTraceTemplatePath]];
			}
			
			if (self.iOS.useDefaultDevice)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--default-device"]];
			}
			else
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--device-name"
																  withValue:self.iOS.deviceName]];
			}
			
			if (self.iOS.useLanguage)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--language"
																  withValue:self.iOS.language]];
			}
			
			if (self.iOS.useLaunchTimeout)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--launch-timeout"
																  withValue:[AppiumServerArgument parseIntegerValue:self.iOS.launchTimeout]]];
			}
			
			if (self.iOS.useLocale)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--locale"
																  withValue:self.iOS.locale]];
			}
			
			if (self.iOS.useLocalizableStringsDirectory)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--localizable-strings-dir"
																  withValue:self.iOS.localizableStringsDirectory]];
			}
			
			if (self.iOS.useInstrumentsBinaryPath)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--instruments"
																  withValue:self.iOS.instrumentsBinaryPath]];
			}
			
			if (self.iOS.useNativeInstrumentsLibrary)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--native-instruments-lib"]];
			}
			
			if (self.iOS.useOrientation)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--orientation"
																  withValue:[self.iOS.orientation capitalizedString]]];
			}
			
			if (self.iOS.useTraceDirectory)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--trace-dir"
																  withValue:self.iOS.traceDirectory]];
			}
			
			if (self.iOS.isolateSimDevice)
			{
				[arguments addObject:[AppiumServerArgument argumentWithName:@"--isolate-sim-device"]];
			}
			
			break;
		}
		default:
		{
			break;
		}
	}
	
	for (AppiumServerArgument *argument in arguments)
	{
		if (argument.value != nil)
		{
			[command appendFormat:@" %@ \"%@\"", argument.name, argument.value];
		}
		else
		{
			[command appendFormat:@" %@", argument.name];
		}
	}
	
	// Add custom flags
	if (self.developer.developerMode && self.developer.useCustomFlags && [self.developer.customFlags length] != 0)
	{
		[command appendFormat:@" %@", self.developer.customFlags];
	}
	
	// Add environment variables
	if (self.isAndroid && self.android.useCustomSDKPath)
	{
		[command insertString:[NSString stringWithFormat:@"export ANDROID_HOME=\"%@\"; ", self.android.customSDKPath] atIndex:0];
	}
	NSArray *environmentVariables = [self.general.environmentVariables copy];
	for (NSDictionary *kvp in environmentVariables) {
		[command insertString:[NSString stringWithFormat:@"export %@=\"%@\"; ", [kvp valueForKey:@"key"], [kvp valueForKey:@"value"]] atIndex:0];
	}
	
	[self setupServerTask:command];
	
	// Log command
	NSAttributedString *logString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Launching Appium with command: %@\n\n", command]
																	attributes:@{NSFontAttributeName: [NSFont fontWithName:@"Menlo" size:12],
																				 NSForegroundColorAttributeName: [NSColor whiteColor]}];
	[[(AppiumAppDelegate*)[[NSApplication sharedApplication] delegate] mainWindowController] appendToLog:logString];
	
	// launch
    [self.serverTask launch];
    [self setIsServerRunning:self.serverTask.isRunning];
	[self performSelectorInBackground:@selector(monitorListenStatus) withObject:nil];
    return self.isServerRunning;
}

-(BOOL) startDoctor
{
	NSString *nodeCommandString;
	if (self.developer.useExternalNodeJSBinary)
	{
		nodeCommandString = [NSString stringWithFormat:@"'%@' bin/appium-doctor.js --port 4722", self.developer.externalNodeJSBinaryPath];
	}
	else
	{
		nodeCommandString = [NSString stringWithFormat:@"'%@%@' bin/appium-doctor.js --port 4722", [[NSBundle mainBundle]resourcePath], @"/node/bin/node"];
		
	}
    
	[self setupServerTask:nodeCommandString];
    
	// launch
    [self.serverTask launch];
    [self setIsServerRunning:self.serverTask.isRunning];
    
    self.doctorSocket = [[SocketIO alloc] initWithDelegate:self];
    [self performSelector:@selector(connectDoctorSocketIO:) withObject:[NSNumber numberWithInt:0] afterDelay:1];
    return self.serverTask.isRunning;
}

- (void)startExternalDoctor
{
	NSString *doctorPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/node_modules/appium/bin/appium-doctor.js"];
    
	NSString *command;
    
	if (self.developer.useExternalNodeJSBinary)
	{
		command = [NSString stringWithFormat:@"'%@' '%@'", self.developer.externalNodeJSBinaryPath, doctorPath];
	}
	else
	{
		command = [NSString stringWithFormat:@"'%@%@' '%@'", [[NSBundle mainBundle] resourcePath], @"/node/bin/node", doctorPath];
	}
	
	NSAppleScript *script = [[NSAppleScript alloc] initWithSource:[NSString stringWithFormat:@"tell application \"Terminal\" to do script \"%@\"\nactivate application \"Terminal\"", command]];
	[script executeAndReturnError:nil];
}

- (void)setupServerTask:(NSString *)commandString
{
	[self setServerTask:[NSTask new]];
	
	if (self.developer.developerMode && self.developer.useExternalAppiumPackage)
	{
		[self.serverTask setCurrentDirectoryPath:self.developer.externalAppiumPackagePath];
	}
	else
	{
		[self.serverTask setCurrentDirectoryPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle]resourcePath], @"node_modules/appium"]];
	}
	
	// Add a cd call to the start of the command in case the .bash_profile or .bashrc changes the current directory
	commandString = [NSString stringWithFormat:@"cd \"%@\" ; %@", self.serverTask.currentDirectoryPath, commandString];
	
    [self.serverTask setLaunchPath:@"/bin/bash"];
    [self.serverTask setArguments: [NSArray arrayWithObjects: @"-l", @"-c", commandString, nil]];
	
	// Redirect I/O
    [self.serverTask setStandardOutput:[NSPipe pipe]];
	[self.serverTask setStandardError:[NSPipe pipe]];
    [self.serverTask setStandardInput:[NSPipe pipe]];
	
	// Convert the NSNumber value to a NSInteger and keep it locally, as it is referenced every time the log is appened to
	self.maxLogLength = [self.general.maxLogLength integerValue];
}

-(void) connectDoctorSocketIO:(NSNumber*)attemptNumber
{
    if (!self.doctorSocketIsConnected)
    {
        [self.doctorSocket connectToHost:@"localhost" onPort:4722];
		
        if ([attemptNumber intValue] < 5)
        {
            [self performSelector:@selector(connectDoctorSocketIO:) withObject:[NSNumber numberWithInt:[attemptNumber intValue] + 1] afterDelay:0];
        }
    }
}

-(void) monitorListenStatus
{
	uint pollInterval = self.isServerListening ? 60 : 1;
	while(self.isServerRunning)
	{
        // OPTION #1
        // poll with sockets api
        /*
		 sleep(.5);
		 BOOL newValue = [Utility checkIfTCPPortIsInUse:[self.port shortValue] atAddress:[self.ipAddress UTF8String]];
		 if (newValue == YES && self.isServerListening)
		 {
		 // sleep to avoid race condition where server is listening but not ready
		 sleep(1);
		 }
		 [self setIsServerListening:newValue];
		 */


        // OPTION #2
        // poll with lsof command

		/*
        // space out the checks by 1 second
		sleep(1);

        // check if there is a process listening on the port
        NSNumber *pidOnPort = [Utility getPidListeningOnPort:self.port];
        BOOL newValue = pidOnPort != nil;

        // set the value
	 	if (newValue == YES && !self.isServerListening)
	 	{
			// sleep to avoid race condition where server is listening but not ready
		 	sleep(1);
		}
		[self setIsServerListening:newValue];
		 */

        // OPTION #3
		// poll with web requests

		 sleep(pollInterval);
		 NSError *error = nil;
		 NSString *urlString = [NSString stringWithFormat:@"http://%@:%d/wd/hub/status", self.general.serverAddress, self.general.serverPort.intValue];
		 NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:1];

		 NSURLResponse *response;
		 NSData *urlData = [NSURLConnection sendSynchronousRequest:request
		 returningResponse:&response
		 error:&error];
		 if (error != nil && [error code] != 0)
		 {
			 [self setIsServerListening:NO];
			 pollInterval = 1;
			 continue;
		 }

		 NSDictionary *json = [NSJSONSerialization JSONObjectWithData:urlData
		 options: NSJSONReadingMutableContainers & NSJSONReadingMutableLeaves
		 error: &error];
		 if (error != nil && [error code] != 0)
		 {
			 [self setIsServerListening:NO];
			 pollInterval = 1;
			 continue;
		 }
		 else
		 {
			 NSObject *statusObj = [json objectForKey:@"status"];
			 sleep(1); // sleep to avoid race condition where server is listening but not ready
			 [self setIsServerListening:statusObj != nil && [statusObj isKindOfClass:[NSNumber class]] && [((NSNumber*)statusObj) intValue] == 0];
			 pollInterval = MIN(10*pollInterval, 60); // sleep for longer
			 continue;
		 }


	}
	[self setIsServerListening:NO];
}

#pragma mark - SocketIODelegateImplementation

- (void) socketIODidConnect:(SocketIO *)socket
{
    NSLog(@"Connected");
    [self setDoctorSocketIsConnected:YES];
    
}

- (void) socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error
{
    NSLog(@"Disconnected w/ Error: %@", error);
    [self setDoctorSocketIsConnected:NO];
    [self setIsServerListening:NO];
}

- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary *event = [jsonParser objectWithString:packet.data];
    NSString *eventName = [event objectForKey:@"name"];
    NSDictionary *eventArgs = [[event objectForKey:@"args"] objectAtIndex:0];
    
    if ([eventName isEqualToString:@"welcome"]) {
        NSLog(@"Welcome");
    } else if ([eventName isEqualToString:@"alert"]) {
        NSString *questionTitle = [eventArgs objectForKey:@"title"];
        NSString *questionMessage = [eventArgs objectForKey:@"message"];
        NSArray *choices = [eventArgs objectForKey:@"choices"];
        
        NSAlert *questionAlert = [NSAlert new];
        [questionAlert setMessageText:questionTitle];
        [questionAlert setInformativeText:questionMessage];
        for (NSString *choice in choices) {
            [questionAlert addButtonWithTitle:choice];
        }

        NSModalResponse response = [questionAlert runModal];
        NSString *selection = [choices objectAtIndex:response-1000];
        NSDictionary *answer = [NSDictionary dictionaryWithObjectsAndKeys:selection, @"selection", [eventArgs objectForKey:@"cbIndex"], @"cbIndex", nil];
        [self.doctorSocket sendEvent:@"answer" withData:answer];
    } else if ([eventName isEqualToString:@"done"]) {
        [self.doctorSocket disconnect];
        self.doctorSocket = nil;
        [self.serverTask terminate];
    }
}

- (void) socketIO:(SocketIO *)socket onError:(NSError *)err
{
    NSLog(@"Error: %@", err);
    self.doctorSocket = nil;
    [self.serverTask terminate];
}

-(void) reset
{
	[self resetWithFile:[[NSBundle mainBundle] pathForResource:@"defaults" ofType:@"plist"]];
}


-(BOOL) resetWithFile:(NSString*)prefsPath {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:prefsPath]) {
		
		// grab values that should not be reset
		BOOL hasAuthorizediOS = self.iOS.authorized;
		BOOL checkForUodates = self.general.checkForUpdates;
		
		// read the defaults.plist file and reset all the values
		NSDictionary *defaultPrefs = [[NSDictionary alloc] initWithContentsOfFile:prefsPath];
		
		for(NSString *key in defaultPrefs) {
			NSObject *value = [defaultPrefs objectForKey:key];
			if ([key hasPrefix:@"NS"]) {
				// ignore window positioning and other cocoa entries
				continue;
			} else {
				[defaults setObject:value forKey:key];
			}
		}
	
		// set back values that should not be reset
		[self.iOS setAuthorized:hasAuthorizediOS];
		[self.general setCheckForUpdates:checkForUodates];
	} else {
		return NO;
	}
	
	// update the bindings through notifications
	for (NSString *propName in [self allPropertyNames]) {
		[self willChangeValueForKey:propName];
		[self didChangeValueForKey:propName];
	}
	return YES;
}

@end
