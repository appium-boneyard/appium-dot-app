/*
 * Appium.h
 */

#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>


@class AppiumApplication, AppiumAndroidSettingsModel, AppiumDeveloperSettingsModel, AppiumGeneralSettingsModel, AppiumInspectorWindowController, AppiumIosSettingsModel, AppiumRobotSettingsModel;

enum AppiumPlatformSetting {
	AppiumPlatformSettingAndroid = 'epad',
	AppiumPlatformSettingIos = 'epio'
};
typedef enum AppiumPlatformSetting AppiumPlatformSetting;

enum AppiumOrientationSetting {
	AppiumOrientationSettingPortrait = 'eopt' /* portrait orientation */,
	AppiumOrientationSettingLandscape = 'eols' /* landscape orientation */
};
typedef enum AppiumOrientationSetting AppiumOrientationSetting;



/*
 * Appium Suite
 */

// Appium application
@interface AppiumApplication : SBApplication

@property (copy, readonly) AppiumInspectorWindowController *inspectorWindow;
@property (copy, readonly) AppiumAndroidSettingsModel *androidSettings;
@property (copy, readonly) AppiumDeveloperSettingsModel *developerSettings;
@property (copy, readonly) AppiumGeneralSettingsModel *generalSettings;
@property (copy, readonly) AppiumIosSettingsModel *iosSettings;
@property (copy, readonly) NSString *logText;
@property (copy, readonly) AppiumRobotSettingsModel *robotSettings;
@property (readonly) BOOL isServerRunning;
@property (readonly) BOOL isServerListening;
@property (copy, readonly) NSString *platform;

- (void) clearLog;  // clears the appium server log display
- (BOOL) startServer;  // starts the appium server
- (BOOL) stopServer;  // stops the appium server
- (void) usePlatform:(AppiumPlatformSetting)x;  // sets the platform
- (void) resetPreferences;  // resets the preferences to their default values

@end

// android Settings
@interface AppiumAndroidSettingsModel : SBObject

@property (copy) NSString *activity;
@property (copy) NSString *androidAppPath;
@property (copy) NSString *automationName;
@property (copy) NSString *avd;
@property (copy) NSString *avdArguments;
@property (copy) NSNumber *bootstrapPort;
@property (copy) NSString *browserName;
@property (copy) NSNumber *chromedriverPort;
@property (copy) NSString *coverageClass;
@property (copy) NSString *customAndroidSdkPath;
@property (copy) NSString *androidDeviceName;
@property (copy) NSNumber *deviceReadyTimeout;
@property BOOL fullAndroidReset;
@property (copy) NSString *intentAction;
@property (copy) NSString *intentCategory;
@property (copy) NSString *intentFlags;
@property (copy) NSString *intentArguments;
@property (copy) NSString *keyAlias;
@property (copy) NSString *keyPassword;
@property (copy) NSString *keystorePassword;
@property (copy) NSString *keystorePath;
@property BOOL noAndroidReset;
@property (copy) NSString *package;
@property (copy) NSString *androidPlatformName;
@property (copy) NSString *androidPlatformVersion;
@property (copy) NSNumber *selendroidPort;
@property BOOL useActivity;
@property BOOL useAndroidAppPath;
@property BOOL useAvd;
@property BOOL useAvdArguments;
@property BOOL useBootstrapPort;
@property BOOL useBrowser;
@property BOOL useChromedriverPort;
@property BOOL useCoverageClass;
@property BOOL useCustomAndroidSdkPath;
@property BOOL useAndroidDeviceName;
@property BOOL useAndroidDeviceReadyTimeout;
@property BOOL useIntentAction;
@property BOOL useIntentCategory;
@property BOOL useIntentFlags;
@property BOOL useIntentArguments;
@property BOOL useKeystore;
@property BOOL usePackage;
@property BOOL useSelendroidPort;
@property BOOL useWaitActivity;
@property BOOL useWaitPackage;
@property (copy) NSString *waitActivity;
@property (copy) NSString *waitPackage;


@end

// develoepr settings
@interface AppiumDeveloperSettingsModel : SBObject

@property BOOL breakOnNodeApplicationStart;
@property (copy) NSString *customFlags;
@property BOOL developerMode;
@property (copy) NSString *externalAppiumPackagePath;
@property (copy) NSString *externalNodejsBinary;
@property (copy) NSNumber *nodejsDebugPort;
@property BOOL useCustomFlags;
@property BOOL useExternalAppiumPackagePath;
@property BOOL useExternalNodejsBinary;
@property BOOL useNodejsDebugging;


@end

// general settings
@interface AppiumGeneralSettingsModel : SBObject

@property BOOL checkForUpdates;
@property (copy) NSNumber *newCommandTimeout;
@property BOOL killProcessesUsingServerPort;
@property BOOL useLogColors;
@property BOOL useLogFile;
@property BOOL useLogTimestamps;
@property (copy) NSString *logFile;
@property (copy) NSString *logWebhook;
@property BOOL forceScrollLog;
@property (copy) NSNumber *maxLogLength;
@property BOOL overrideExistingSessions;
@property BOOL prelaunchApplication;
@property (copy) NSString *seleniumGridConfigurationFile;
@property (copy) NSString *serverAddress;
@property (copy) NSNumber *serverPort;
@property BOOL useLogWebhook;
@property BOOL useNewCommandTimeout;
@property BOOL useQuietLogging;
@property BOOL useRemoteServer;
@property BOOL useLocalTimezone;
@property BOOL useCallbackAddress;
@property BOOL useCallbackPort;
@property (copy) NSString *callbackAddress;
@property (copy) NSNumber *callbackPort;

@end

// inspector window
@interface AppiumInspectorWindowController : SBObject

@property (copy, readonly) NSString *details;  // details for the selected element


@end

// iOS Settings
@interface AppiumIosSettingsModel : SBObject

@property (copy) NSString *iosAppPath;
@property (readonly) BOOL authorized;
@property (copy) NSNumber *backendRetries;
@property (copy) NSString *bundleId;
@property (copy) NSString *iosCalendarFormat;
@property (copy) NSString *customTraceTemplatePath;
@property (copy) NSString *iosDeviceName;
@property BOOL fullIosReset;
@property BOOL keepArtifacts;
@property BOOL keepKeychains;
@property (copy) NSString *iosLanguage;
@property (copy) NSString *iosLocale;
@property BOOL noIosReset;
@property BOOL killUnresponsiveInstrumentsProcesses;
@property (copy) NSString *iosOrientation;
@property (copy) NSString *iosPlatformVersion;
@property BOOL showSimulatorLog;
@property (copy) NSString *iosTraceDirectory;
@property (copy) NSString *udid;
@property BOOL useIosAppPath;
@property BOOL useBackendRetries;
@property BOOL useBundleId;
@property BOOL useIosCalendarFormat;
@property BOOL useCustomTraceTemplatePath;
@property BOOL useIosDeviceName;
@property BOOL useIosLanguage;
@property BOOL useLaunchTimeout;
@property (copy) NSNumber *launchTimeout;
@property BOOL useIosLocale;
@property BOOL useMobileSafari;
@property BOOL useNativeInstrumentsLibrary;
@property BOOL useIosOrientation;
@property BOOL useIosTraceDirectory;
@property BOOL useUdid;
@property (copy, readonly) NSString *xcodePath;


@end

// robot settings
@interface AppiumRobotSettingsModel : SBObject

@property (copy) NSString *robotAddress;
@property (copy) NSNumber *robotPort;
@property BOOL useRobot;


@end

