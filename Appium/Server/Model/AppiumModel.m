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

#pragma  mark - Model

NSUserDefaults* _defaults;
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
		_defaults = [NSUserDefaults standardUserDefaults];

		// create submodels
	    [self setAndroid:[[AppiumAndroidSettingsModel alloc] initWithDefaults:_defaults]];
		[self setIOS:[[AppiumiOSSettingsModel alloc] initWithDefaults:_defaults]];
		
		// initialize members
		_isServerRunning = NO;
		_isServerListening = [self useRemoteServer];
        [self setDoctorSocketIsConnected:NO];
    }
    return self;
}

#pragma mark - Properties


-(BOOL) breakOnNodeApplicationStart { return self.developerMode && self.useNodeDebugging && [_defaults boolForKey:APPIUM_PLIST_BREAK_ON_NODEJS_APP_START]; }
-(void) setBreakOnNodeApplicationStart:(BOOL)breakOnNodeApplicationStart { [_defaults setBool:breakOnNodeApplicationStart forKey:APPIUM_PLIST_BREAK_ON_NODEJS_APP_START]; }

-(BOOL) checkForUpdates { return [_defaults boolForKey:APPIUM_PLIST_CHECK_FOR_UPDATES]; }
-(void) setCheckForUpdates:(BOOL)checkForUpdates { [_defaults setBool:checkForUpdates forKey:APPIUM_PLIST_CHECK_FOR_UPDATES]; }

-(NSString*) customFlags { return [_defaults stringForKey:APPIUM_PLIST_CUSTOM_FLAGS]; }
-(void) setCustomFlags:(NSString *)customFlags { [_defaults setValue:customFlags forKey:APPIUM_PLIST_CUSTOM_FLAGS]; }

-(NSString*) externalAppiumPackagePath { return [_defaults stringForKey:APPIUM_PLIST_EXTERNAL_APPIUM_PACKAGE_PATH]; }
-(void) setExternalAppiumPackagePath:(NSString *)externalAppiumPackagePath { [_defaults setValue:externalAppiumPackagePath forKey:APPIUM_PLIST_EXTERNAL_APPIUM_PACKAGE_PATH]; }

-(NSString*) externalNodeJSBinaryPath { return [_defaults stringForKey:APPIUM_PLIST_EXTERNAL_NODEJS_BINARY_PATH]; }
-(void) setExternalNodeJSBinaryPath:(NSString *)externalNodeJSBinaryPath { [_defaults setValue:externalNodeJSBinaryPath forKey:APPIUM_PLIST_EXTERNAL_NODEJS_BINARY_PATH]; }

-(BOOL) developerMode { return [_defaults boolForKey:APPIUM_PLIST_DEVELOPER_MODE]; }
-(void) setDeveloperMode:(BOOL)developerMode { [_defaults setBool:developerMode forKey:APPIUM_PLIST_DEVELOPER_MODE]; }

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

-(BOOL) killProcessesUsingPort { return [_defaults boolForKey:APPIUM_PLIST_KILL_PROCESSES_USING_PORT]; }
-(void) setKillProcessesUsingPort:(BOOL)killProcessesUsingPort { [_defaults setBool:killProcessesUsingPort forKey:APPIUM_PLIST_KILL_PROCESSES_USING_PORT];}

-(BOOL) logColors { return [_defaults boolForKey:APPIUM_PLIST_LOG_COLORS]; }
-(void) setLogColors:(BOOL)logColors { [_defaults setBool:logColors forKey:APPIUM_PLIST_LOG_COLORS]; }

-(NSString*) logFile { return [_defaults stringForKey:APPIUM_PLIST_LOG_FILE]; }
-(void) setLogFile:(NSString *)logFile { [_defaults setValue:logFile forKey:APPIUM_PLIST_LOG_FILE]; }

-(BOOL) logTimestamps { return [_defaults boolForKey:APPIUM_PLIST_LOG_TIMESTAMPS]; }
-(void) setLogTimestamps:(BOOL)logTimestamps { [_defaults setBool:logTimestamps forKey:APPIUM_PLIST_LOG_TIMESTAMPS]; }

-(NSString*) logWebHook { return [_defaults stringForKey:APPIUM_PLIST_LOG_WEBHOOK]; }
-(void) setLogWebHook:(NSString *)logWebHook { [_defaults setValue:logWebHook forKey:APPIUM_PLIST_LOG_WEBHOOK]; }

-(NSNumber*) newCommandTimeout { return [NSNumber numberWithInt:[[_defaults stringForKey:APPIUM_PLIST_NEW_COMMAND_TIMEOUT] intValue]]; }
-(void) setNewCommandTimeout:(NSNumber *)newCommandTimeout { [[NSUserDefaults standardUserDefaults] setValue:newCommandTimeout forKey:APPIUM_PLIST_NEW_COMMAND_TIMEOUT]; }

-(NSNumber*) nodeDebugPort { return [NSNumber numberWithInt:[[_defaults stringForKey:APPIUM_PLIST_NODEJS_DEBUG_PORT] intValue]]; }
-(void) setNodeDebugPort:(NSNumber *)nodeDebugPort { [[NSUserDefaults standardUserDefaults] setValue:nodeDebugPort forKey:APPIUM_PLIST_NODEJS_DEBUG_PORT]; }

-(BOOL) overrideExistingSessions { return [_defaults boolForKey:APPIUM_PLIST_OVERRIDE_EXISTING_SESSIONS]; }
-(void) setOverrideExistingSessions:(BOOL)overrideExistingSessions { [_defaults setBool:overrideExistingSessions forKey:APPIUM_PLIST_OVERRIDE_EXISTING_SESSIONS]; }


-(Platform)platform
{
    return [_defaults boolForKey:APPIUM_PLIST_PLATFORM_IS_ANDROID] ? Platform_Android : Platform_iOS;
}
-(void)setPlatform:(Platform)platform {
	[_defaults setBool:(platform == Platform_Android) forKey:APPIUM_PLIST_PLATFORM_IS_ANDROID];
}


-(BOOL) prelaunchApp { return [_defaults boolForKey:APPIUM_PLIST_PRELAUNCH_APPLICATION]; }
-(void) setPrelaunchApp:(BOOL)preLaunchApp { [_defaults setBool:preLaunchApp forKey:APPIUM_PLIST_PRELAUNCH_APPLICATION]; }

-(NSString*) robotAddress { return [_defaults stringForKey:APPIUM_PLIST_ROBOT_ADDRESS]; }
-(void) setRobotAddress:(NSString *)robotAddress { [_defaults setValue:robotAddress forKey:APPIUM_PLIST_ROBOT_ADDRESS]; }

-(NSNumber*) robotPort { return [NSNumber numberWithInt:[[_defaults stringForKey:APPIUM_PLIST_ROBOT_PORT] intValue]]; }
-(void) setRobotPort:(NSNumber *)robotPort { [[NSUserDefaults standardUserDefaults] setValue:robotPort forKey:APPIUM_PLIST_ROBOT_PORT]; }

-(NSString*) seleniumGridConfigFile { return [_defaults stringForKey:APPIUM_PLIST_SELENIUM_GRID_CONFIG_FILE]; }
-(void) setSeleniumGridConfigFile:(NSString *)seleniumGridConfigFile { [_defaults setValue:seleniumGridConfigFile forKey:APPIUM_PLIST_SELENIUM_GRID_CONFIG_FILE]; }

-(NSString*) serverAddress { return [_defaults stringForKey:APPIUM_PLIST_SERVER_ADDRESS]; }
-(void) setServerAddress:(NSString *)serverAddress { [_defaults setValue:serverAddress forKey:APPIUM_PLIST_SERVER_ADDRESS]; }

-(NSNumber*) serverPort { return [NSNumber numberWithInt:[[_defaults stringForKey:APPIUM_PLIST_SERVER_PORT] intValue]]; }
-(void) setServerPort:(NSNumber *)serverPort { [[NSUserDefaults standardUserDefaults] setValue:serverPort forKey:APPIUM_PLIST_SERVER_PORT]; }

-(BOOL) useCustomFlags { return [_defaults boolForKey:APPIUM_PLIST_USE_CUSTOM_FLAGS]; }
-(void) setUseCustomFlags:(BOOL)useCustomFlags { [_defaults setBool:useCustomFlags forKey:APPIUM_PLIST_USE_CUSTOM_FLAGS]; }

-(BOOL) useExternalAppiumPackage { return self.developerMode && [_defaults boolForKey:APPIUM_PLIST_USE_EXTERNAL_APPIUM_PACKAGE]; }
-(void) setUseExternalAppiumPackage:(BOOL)useCustomAppiumPackage { [_defaults setBool:useCustomAppiumPackage forKey:APPIUM_PLIST_USE_EXTERNAL_APPIUM_PACKAGE]; }

-(BOOL) useExternalNodeJSBinary { return self.developerMode && [_defaults boolForKey:APPIUM_PLIST_USE_EXTERNAL_NODEJS_BINARY]; }
-(void) setUseExternalNodeJSBinary:(BOOL)useCustomNodeJSBinary { [_defaults setBool:useCustomNodeJSBinary forKey:APPIUM_PLIST_USE_EXTERNAL_NODEJS_BINARY]; }

-(BOOL) useLogFile { return [_defaults boolForKey:APPIUM_PLIST_USE_LOG_FILE]; }
-(void) setUseLogFile:(BOOL)useLogFile { [_defaults setBool:useLogFile forKey:APPIUM_PLIST_USE_LOG_FILE]; }

-(BOOL) useLogWebHook { return [_defaults boolForKey:APPIUM_PLIST_USE_LOG_WEBHOOK]; }
-(void) setUseLogWebHook:(BOOL)useLogWebHook { [_defaults setBool:useLogWebHook forKey:APPIUM_PLIST_USE_LOG_WEBHOOK]; }

-(BOOL) useNewCommandTimeout { return [_defaults boolForKey:APPIUM_PLIST_USE_NEW_COMMAND_TIMEOUT]; }
-(void) setUseNewCommandTimeout:(BOOL)useNewCommandTimeout { [_defaults setBool:useNewCommandTimeout forKey:APPIUM_PLIST_USE_NEW_COMMAND_TIMEOUT]; }

-(BOOL) useNodeDebugging { return self.developerMode && [_defaults boolForKey:APPIUM_PLIST_USE_NODEJS_DEBUGGING]; }
-(void) setUseNodeDebugging:(BOOL)useNodeDebugging { [_defaults setBool:useNodeDebugging forKey:APPIUM_PLIST_USE_NODEJS_DEBUGGING]; }

-(BOOL) useRemoteServer { return [_defaults boolForKey:APPIUM_PLIST_USE_REMOTE_SERVER]; }
-(void) setUseRemoteServer:(BOOL)useRemoteServer
{
	[_defaults setBool:useRemoteServer forKey:APPIUM_PLIST_USE_REMOTE_SERVER];
	if (useRemoteServer)
	{
		[self killServer];
	}
	[self setIsServerListening:useRemoteServer];
}

-(BOOL) useRobot { return [_defaults boolForKey:APPIUM_PLIST_USE_ROBOT]; }
-(void) setUseRobot:(BOOL)useRobot { [_defaults setBool:useRobot forKey:APPIUM_PLIST_USE_ROBOT]; }

-(BOOL) useQuietLogging { return [_defaults boolForKey:APPIUM_PLIST_USE_QUIET_LOGGING]; }
-(void) setUseQuietLogging:(BOOL)useQuietLogging { [_defaults setBool:useQuietLogging forKey:APPIUM_PLIST_USE_QUIET_LOGGING]; }

-(BOOL) useSeleniumGridConfigFile { return [_defaults boolForKey:APPIUM_PLIST_USE_SELENIUM_GRID_CONFIG_FILE]; }
-(void) setUseSeleniumGridConfigFile:(BOOL)useSeleniumGridConfigFile { [_defaults setBool:useSeleniumGridConfigFile forKey:APPIUM_PLIST_USE_SELENIUM_GRID_CONFIG_FILE]; }


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
    if (self.killProcessesUsingPort)
    {
        NSNumber *procPid = [Utility getPidListeningOnPort:self.serverPort];
        if (procPid != nil && myPid != [procPid intValue])
        {
            NSString* script = [NSString stringWithFormat: @"kill `lsof -t -i:%@`", self.serverPort];
            system([script UTF8String]);
			system([@"killall -z lsof" UTF8String]);
        }
    }

	NSString *nodeDebuggingArguments = @"";
	if (self.useNodeDebugging) {
		nodeDebuggingArguments = [nodeDebuggingArguments stringByAppendingString:[NSString stringWithFormat:@" --debug=%@", [self.nodeDebugPort stringValue]]];
		if (self.breakOnNodeApplicationStart) {
			nodeDebuggingArguments = [nodeDebuggingArguments stringByAppendingString:@" --debug-brk"];
		}
	}
	
	NSString *nodeCommandString;
	if (self.developerMode && self.useExternalNodeJSBinary) {
		nodeCommandString = [NSString stringWithFormat:@"'%@'%@ lib/server/main.js", self.externalNodeJSBinaryPath, nodeDebuggingArguments];
	} else {
		nodeCommandString = [NSString stringWithFormat:@"'%@%@'%@ lib/server/main.js", [[NSBundle mainBundle]resourcePath], @"/node/bin/node", nodeDebuggingArguments];
	}
	if (![self.serverAddress isEqualTo:@"0.0.0.0"]) {
		nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--address", self.serverAddress];
    }
	// TODO: Strcmp with int???
	if (![self.serverPort isEqualTo:@"4723"]) {
		nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--port", [self.serverPort stringValue]];
    }
	if (self.useNewCommandTimeout) {
	nodeCommandString = [nodeCommandString stringByAppendingFormat:@" --command-timeout %d", [self.newCommandTimeout intValue]];
	}
    if (self.overrideExistingSessions) {
        nodeCommandString = [nodeCommandString stringByAppendingString:@" --session-override"];
    }
	if (self.prelaunchApp) {
		nodeCommandString = [nodeCommandString stringByAppendingString:@" --pre-launch"];
    }
	if (!self.logColors) {
        nodeCommandString = [nodeCommandString stringByAppendingString:@" --log-no-colors"];
    }
	if (self.useLogFile) {
        nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--log", [self.logFile stringByReplacingOccurrencesOfString:@" " withString:@"\\ "]];
    }
	if (self.logTimestamps) {
        nodeCommandString = [nodeCommandString stringByAppendingString:@" --log-timestamp"];
    }
    if (self.useLogWebHook) {
        nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--webhook", self.logWebHook];
    }
	if (self.useQuietLogging) {
		nodeCommandString = [nodeCommandString stringByAppendingString:@" --quiet"];
    }
    if (self.useSeleniumGridConfigFile) {
        nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--nodeconfig", [self.seleniumGridConfigFile stringByReplacingOccurrencesOfString:@" " withString:@"\\ "]];
    }
	
	// robot preferences
	if (self.useRobot)
    {
		nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%@\"", @"--robot-address", self.robotAddress];
		nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%d\"", @"--robot-port", [self.robotPort intValue]];
	}
	
	// developer preferences
	if (self.developerMode && self.useCustomFlags && self.customFlags != nil)
	{
		nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@", self.customFlags];
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
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ @%@", @"--avd", self.android.avd];
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
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ %@", @"--browser-name", @"Chrome"];
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
		if ([self.android.automationName isEqualToString:@"Selendroid"]) {
			if (self.android.selendroidPort) {
				nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%d\"", @"--selendroid-port", [self.android.selendroidPort intValue]];
			}
		} else if (self.android.useBootstrapPort) {
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%d\"", @"--bootstrap-port", [self.android.bootstrapPort intValue]];
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
			nodeCommandString = [nodeCommandString stringByAppendingFormat:@" %@ \"%@\"", ([self.iOS.appPath hasSuffix:@"ipa"]) ? @"--ipa" : @"--app", self.iOS.appPath];
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
		if (self.iOS.notMerciful) {
			nodeCommandString = [nodeCommandString stringByAppendingString:@" --force-quit-instruments"];
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

	[self setServerTask:[NSTask new]];
	if (self.developerMode && self.useExternalAppiumPackage)
	{
		[self.serverTask setCurrentDirectoryPath:self.externalAppiumPackagePath];
	}
	else
	{
		[self.serverTask setCurrentDirectoryPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle]resourcePath], @"node_modules/appium"]];
	}
    [self.serverTask setLaunchPath:@"/bin/bash"];
    [self.serverTask setArguments: [NSArray arrayWithObjects: @"-l",
									@"-c", nodeCommandString, nil]];

	// redirect i/o
    [self.serverTask setStandardOutput:[NSPipe pipe]];
	[self.serverTask setStandardError:[NSPipe pipe]];
    [self.serverTask setStandardInput:[NSPipe pipe]];

	// launch
    [self.serverTask launch];
    [self setIsServerRunning:self.serverTask.isRunning];
	[self performSelectorInBackground:@selector(monitorListenStatus) withObject:nil];
    return self.isServerRunning;
}

-(BOOL) startDoctor {
    [self setServerTask:[NSTask new]];
	NSString *nodeCommandString;
	if (self.useExternalNodeJSBinary)
	{
		nodeCommandString = [NSString stringWithFormat:@"'%@' bin/appium-doctor.js --port 4722", self.externalNodeJSBinaryPath];
	}
	else
	{
		nodeCommandString = [NSString stringWithFormat:@"'%@%@' bin/appium-doctor.js --port 4722", [[NSBundle mainBundle]resourcePath], @"/node/bin/node"];
		
	}
    
	if (self.useExternalAppiumPackage)
	{
		[self.serverTask setCurrentDirectoryPath:self.externalAppiumPackagePath];
	}
	else
	{
		[self.serverTask setCurrentDirectoryPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle]resourcePath], @"node_modules/appium"]];
	}
    [self.serverTask setLaunchPath:@"/bin/bash"];
    [self.serverTask setArguments: [NSArray arrayWithObjects: @"-l",
									@"-c", nodeCommandString, nil]];
    
	// redirect i/o
    [self.serverTask setStandardOutput:[NSPipe pipe]];
	[self.serverTask setStandardError:[NSPipe pipe]];
    [self.serverTask setStandardInput:[NSPipe pipe]];
    
	// launch
    [self.serverTask launch];
    [self setIsServerRunning:self.serverTask.isRunning];
    
    self.doctorSocket = [[SocketIO alloc] initWithDelegate:self];
    [self performSelector:@selector(connectDoctorSocketIO:) withObject:[NSNumber numberWithInt:0] afterDelay:1];
    return self.serverTask.isRunning;
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
		 NSString *urlString = [NSString stringWithFormat:@"http://%@:%d/wd/hub/status", self.serverAddress, self.serverPort.intValue];
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

@end
