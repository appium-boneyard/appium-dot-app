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

#pragma  mark - Model

BOOL _isServerRunning;
BOOL _isServerListening;

@implementation AppiumModel

- (id)init
{
    self = [super init];
    if (self) {
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

-(BOOL) isAndroid { return self.platform == Platform_Android; }
-(void) setIsAndroid:(BOOL)isAndroid {
	[self setPlatform: isAndroid ? Platform_Android : Platform_iOS];
}
-(BOOL) isIOS { return self.platform == Platform_iOS; }
-(void) setIsIOS:(BOOL)isIOS {
	[self setPlatform: isIOS ? Platform_iOS : Platform_Android];
}

-(BOOL) isServerRunning { return _isServerRunning; }
-(void) setIsServerRunning:(BOOL)isServerRunning
{
	_isServerRunning = isServerRunning;
	_isServerListening = isServerRunning ? _isServerListening : NO;
}

-(BOOL) isServerListening { return _isServerListening; }
-(void) setIsServerListening:(BOOL)isServerListening { _isServerListening = isServerListening; }


-(Platform)platform
{
    return [DEFAULTS boolForKey:APPIUM_PLIST_PLATFORM_IS_ANDROID] ? Platform_Android : Platform_iOS;
}
-(void)setPlatform:(Platform)platform
{
	[DEFAULTS setBool:(platform == Platform_Android) forKey:APPIUM_PLIST_PLATFORM_IS_ANDROID];
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
            NSString* script = [NSString stringWithFormat: @"kill `lsof -t -i:%@`", self.general.serverPort];
            system([script UTF8String]);
			system([@"killall -z lsof" UTF8String]);
        }
    }

	NSString *nodeDebuggingArguments = @"";
	if (self.developer.useNodeDebugging) {
		nodeDebuggingArguments = [nodeDebuggingArguments stringByAppendingString:[NSString stringWithFormat:@" --debug=%@", [self.developer.nodeJSDebugPort stringValue]]];
		if (self.developer.breakOnNodeApplicationStart) {
			nodeDebuggingArguments = [nodeDebuggingArguments stringByAppendingString:@" --debug-brk"];
		}
	}
	
	NSString *nodeCommandString;
	if (self.developer.developerMode && self.developer.useExternalNodeJSBinary) {
		nodeCommandString = [NSString stringWithFormat:@"'%@'%@ lib/server/main.js", self.developer.externalNodeJSBinaryPath, nodeDebuggingArguments];
	} else {
		nodeCommandString = [NSString stringWithFormat:@"'%@%@'%@ lib/server/main.js", [[NSBundle mainBundle]resourcePath], @"/node/bin/node", nodeDebuggingArguments];
	}
	if (![self.general.serverAddress isEqualTo:@"0.0.0.0"]) {
		nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--address", self.general.serverAddress];
    }
	// TODO: Strcmp with int???
	if (![self.general.serverPort isEqualTo:@"4723"]) {
		nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--port", [self.general.serverPort stringValue]];
    }
	if (self.general.useCallbackAddress) {
		nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--callback-address", self.general.callbackAddress];
	}
	if (self.general.useCallbackPort) {
		nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--callback-port", [self.general.callbackPort stringValue]];
	}
	if (self.general.useCommandTimeout) {
	nodeCommandString = [nodeCommandString stringByAppendingFormat:@" --command-timeout %d", [self.general.commandTimeout intValue]];
	}
    if (self.general.overrideExistingSessions) {
        nodeCommandString = [nodeCommandString stringByAppendingString:@" --session-override"];
    }
	if (self.general.prelaunchApp) {
		nodeCommandString = [nodeCommandString stringByAppendingString:@" --pre-launch"];
    }
	if (!self.general.logColors) {
        nodeCommandString = [nodeCommandString stringByAppendingString:@" --log-no-colors"];
    }
	if (self.general.useLogFile) {
        nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--log", [self.general.logFile stringByReplacingOccurrencesOfString:@" " withString:@"\\ "]];
    }
	if (self.general.logTimestamps) {
        nodeCommandString = [nodeCommandString stringByAppendingString:@" --log-timestamp"];
    }
    if (self.general.useLogWebHook) {
        nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--webhook", self.general.logWebHook];
    }
	if (self.general.useQuietLogging) {
		nodeCommandString = [nodeCommandString stringByAppendingString:@" --quiet"];
    }
    if (self.general.useSeleniumGridConfigFile) {
        nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--nodeconfig", [self.general.seleniumGridConfigFile stringByReplacingOccurrencesOfString:@" " withString:@"\\ "]];
    }
	if (self.general.useLocalTimezone) {
		NSLog(@"using local timezone");
		nodeCommandString = [nodeCommandString stringByAppendingString:@" --local-timezone"];
	}
	
	// robot preferences
	if (self.robot.useRobot)
    {
		nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%@\"", @"--robot-address", self.robot.robotAddress];
		nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%d\"", @"--robot-port", [self.robot.robotPort intValue]];
	}
	
	// developer preferences
	if (self.developer.developerMode && self.developer.useCustomFlags && self.developer.customFlags != nil)
	{
		nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@", self.developer.customFlags];
	}
	
	// platform specific preferences
	if (self.platform == Platform_Android) {
		
		  //////////////
	     // Android ///
	    //////////////
		
		// get version number from string
		
		nodeCommandString = [nodeCommandString stringByAppendingFormat:@" --automation-name %@ --platform-name %@ --platform-version %@", self.android.automationName, self.android.platformName, self.android.platformVersionNumber];
		if (self.android.useCustomSDKPath) {
			nodeCommandString = [NSString stringWithFormat:@"export ANDROID_HOME=\"%@\"; %@", self.android.customSDKPath, nodeCommandString];
		}
		if (self.android.useAppPath || self.android.useBrowser) {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" --app \"%@\"", self.android.useBrowser ? @"browser" : self.android.appPath];
		}
		if (self.android.fullReset) {
			nodeCommandString = [nodeCommandString stringByAppendingString:@" --full-reset"];
		} else if (self.android.noReset) {
			nodeCommandString = [nodeCommandString stringByAppendingString:@" --no-reset"];
		}
		if (self.android.useAVD) {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"@%@\"", @"--avd", self.android.avd];
			if (self.android.useAVDArguments) {
				nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%@\"", @"--avd-args", self.android.avdArguments];
			}
		}
		if (!self.android.useBrowser) {
			if (self.android.useChromedriverPort) {
				nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%d\"", @"--chromedriver-port", [self.android.chromedriverPort intValue]];
			}
			if (self.android.usePackage) {
				nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%@\"", @"--app-pkg", self.android.package];
			}
			if (self.android.useActivity) {
				nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%@\"", @"--app-activity", self.android.activity];
			}
			if (self.android.useWaitPackage) {
				nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%@\"", @"--app-wait-package", self.android.waitPackage];
			}
			if (self.android.useWaitActivity) {
				nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%@\"", @"--app-wait-activity", self.android.waitActivity];
			}
		} else {
			if (self.android.browserName.length != 0) {
				nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--browser-name", self.android.browserName];
			} else {
				nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--browser-name", @"Chrome"];
			}
		}
		if (self.android.useCoverageClass) {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%@\"", @"--coverage-class", self.android.coverageClass];
		}
		if (self.android.useDeviceName) {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" --device-name \"%@\"", self.android.deviceName];
		}
		if (self.android.useDeviceReadyTimeout) {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%d\"", @"--device-ready-timeout", [self.android.deviceReadyTimeout intValue]];
		}
		if (self.android.useLanguage) {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" --language %@", self.android.language];
        }
		if (self.android.useLocale) {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" --locale %@", self.android.locale];
        }
		if ([self.android.automationName isEqualToString:@"Selendroid"]) {
			if (self.android.selendroidPort) {
				nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%d\"", @"--selendroid-port", [self.android.selendroidPort intValue]];
			}
		} else if (self.android.useBootstrapPort) {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%d\"", @"--bootstrap-port", [self.android.bootstrapPort intValue]];
		}
		if (self.android.useIntentAction)
		{
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%@\"", @"--intent-action", self.android.intentAction];
		}
		if (self.android.useIntentCategory)
		{
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%@\"", @"--intent-category", self.android.intentCategory];
		}
		if (self.android.useIntentFlags)
		{
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%@\"", @"--intent-flags", self.android.intentFlags];
		}
		if (self.android.useIntentArguments)
		{
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%@\"", @"--intent-args", self.android.intentArguments];
		}
		if (self.android.useKeystore)
		{
			nodeCommandString = [nodeCommandString stringByAppendingString:@" --use-keystore"];
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--keystore-path", [self.android.keystorePath stringByReplacingOccurrencesOfString:@" " withString:@"\\ "]];
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--keystore-password", [self.android.keystorePassword stringByReplacingOccurrencesOfString:@" " withString:@"\\ "]];
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--key-alias", [self.android.keyAlias stringByReplacingOccurrencesOfString:@" " withString:@"\\ "]];
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--key-password", [self.android.keyPassword stringByReplacingOccurrencesOfString:@" " withString:@"\\ "]];
		}
	} else if (self.platform == Platform_iOS) {
		
		  /////////
		 // iOS //
	    /////////
		
		if (self.iOS.useMobileSafari) {
			nodeCommandString = [nodeCommandString stringByAppendingString:@" --safari"];
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--browser-name", @"Safari"];
		} else if (self.iOS.useBundleID) {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" --app \"%@\"", self.iOS.bundleID];
		} else if (self.iOS.useAppPath) {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" --app \"%@\"", self.iOS.appPath];
		}
		if (self.iOS.useUDID) {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" --udid %@", self.iOS.udid];
		}
		if (self.iOS.fullReset) {
			nodeCommandString = [nodeCommandString stringByAppendingString:@" --full-reset"];
		}
		if (self.iOS.noReset) {
			nodeCommandString = [nodeCommandString stringByAppendingString:@" --no-reset"];
		}
		if (self.iOS.showSimulatorLog) {
			nodeCommandString = [nodeCommandString stringByAppendingString:@" --show-sim-log"];
        }
		if (self.iOS.useBackendRetries) {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" --backend-retries %d", [self.iOS.backendRetries intValue]];
        }
		if (self.iOS.useCalendar) {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" --calendar %@", self.iOS.calendarFormat];
        }
		if (self.iOS.useCustomTraceTemplate) {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" --trace-template \"%@\"", self.iOS.customTraceTemplatePath];
        }
        if (self.iOS.useDefaultDevice) {
			nodeCommandString = [nodeCommandString stringByAppendingString:@" --default-device"];
		} else {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" --device-name \"%@\"", self.iOS.deviceName];
        }
		if (self.iOS.useLanguage) {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" --language %@", self.iOS.language];
        }
		if (self.iOS.useLaunchTimeout) {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" --launch-timeout %d", [self.iOS.launchTimeout intValue]];
        }

		if (self.iOS.useLocale) {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" --locale %@", self.iOS.locale];
        }

        if (self.iOS.useNativeInstrumentsLibrary) {
			nodeCommandString = [nodeCommandString stringByAppendingString:@" --native-instruments-lib"];
        }
		if (self.iOS.useOrientation) {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@"%@ %@", @" --orientation ", [self.iOS.orientation capitalizedString]];
        }
	}

	[self setupServerTask:nodeCommandString];
	
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
    [self.serverTask setLaunchPath:@"/bin/bash"];
    [self.serverTask setArguments: [NSArray arrayWithObjects: @"-l",
									@"-c", commandString, nil]];
	
	// Redirect I/O
    [self.serverTask setStandardOutput:[NSPipe pipe]];
	[self.serverTask setStandardError:[NSPipe pipe]];
    [self.serverTask setStandardInput:[NSPipe pipe]];
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
	NSString *prefsPath = [[NSBundle mainBundle] pathForResource:@"defaults" ofType:@"plist"];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:prefsPath]) {

		// grab values that should not be reset
		BOOL hasAuthorizediOS = self.iOS.authorized;
		BOOL checkForUodates = self.general.checkForUpdates;
		
		// read the defaults.plist file and reset all the values
		NSDictionary *defaultPrefs = [[NSDictionary alloc] initWithContentsOfFile:prefsPath];
		for(NSString *key in defaultPrefs) {
			NSObject *value = [defaultPrefs objectForKey:key];
			[defaults setObject:value forKey:key];
		}
		
		// set back values that should not be reset
		[self.iOS setAuthorized:hasAuthorizediOS];
		[self.general setCheckForUpdates:checkForUodates];
	}
	
	// update the bindings through notifications
	for (NSString *propName in [self allPropertyNames]) {
		[self willChangeValueForKey:propName];
		[self didChangeValueForKey:propName];
	}
}

@end
