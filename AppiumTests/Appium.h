/*
 * Appium.h
 */

#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>


@class AppiumApplication, AppiumInspectorWindowController;

// ios device
enum AppiumIosDevice {
	AppiumIosDeviceIpad = 'cipa' /* ipad */,
	AppiumIosDeviceIphone = 'ciph' /* iphone */,
	AppiumIosDeviceNoDevice = 'cdno' /* no device */
};
typedef enum AppiumIosDevice AppiumIosDevice;

// platform
enum AppiumPlatform {
	AppiumPlatformAndroid = 'cpan' /* android platform */,
	AppiumPlatformIos = 'cpio' /* ios platform */
};
typedef enum AppiumPlatform AppiumPlatform;

// platform
enum AppiumOrientation {
	AppiumOrientationPortrait = 'corp' /* portrait orientation */,
	AppiumOrientationLandscape = 'corl' /* landscape orientation */,
	AppiumOrientationNoOrientation = 'cdno' /* no device */
};
typedef enum AppiumOrientation AppiumOrientation;



/*
 * Appium Suite
 */

// Appium Application
@interface AppiumApplication : SBApplication

@property (copy) NSString *androidActivity;  // name of android activity
@property NSInteger androidDeviceReadyTimeout;  // time to allow for an android device to become ready
@property (copy) NSString *androidKeyAlias;  // android key alias
@property (copy) NSString *androidKeyPassword;  // android key password
@property (copy) NSString *androidKeystorePassword;  // android keystore password
@property (copy) NSString *androidKeystorePath;  // path to android keystore
@property (copy) NSString *androidPackage;  // name of android package
@property (copy) NSString *androidWaitActivity;  // name of android activity to wait for
@property (copy) NSString *appPath;  // path to mobile application
@property (copy) NSString *avdName;  // name of avd
@property BOOL breakOnNodeAppStart;  // true if a breakpoint will be set when the node application starts
@property (copy) NSString *bundleId;  // bundle id
@property BOOL checkForUpdates;  // true if appium will check for updates
@property (copy) NSString *customAndroidSdkPath;  // custom path to android sdk
@property (copy) NSString *customFlags;  // custom server flags
@property BOOL developerMode;  // true if appium is in developer mode
@property (copy) NSString *externalAppiumPackagePath;  // path to external appium package
@property (copy) NSString *externalNodePath;  // path to external node binaries
@property (readonly) BOOL isServerListening;  // true if the appium server is listening
@property (readonly) BOOL isServerRunning;  // true if the appium server is running
@property BOOL keepArtifacts;  // true if artifacts will be kept after the session
@property BOOL killProcessesUsingPort;  // true if appium will kill processes using the server port before launching the server
@property (copy, readonly) AppiumInspectorWindowController *inspectorWindow;  // appium inpsector window
@property BOOL launchAvd;  // true if appium should launch an avd
@property (copy) NSString *logFile;  // path to the log file appium will use
@property (copy, readonly) NSString *logText;  // text from the appium log
@property BOOL logToFile;  // true if appium will log to a file
@property BOOL logToWebhook;  // true if appium will log to a webhook
@property (copy) NSString *logWebhook;  // webhook to which appium will log
@property NSInteger nodeDebugPort;  // port for the nodeJS debugger
@property (copy, readonly) NSString *nodePath;  // path to nodejs binary
@property BOOL overrideExistingSessions;  // true if appium should override existing sessions when launching the server
@property BOOL prelaunchApplication;  // true if the application will prelaunch
@property BOOL resetAppState;  // true if warp application state will be reset after the session
@property (copy) NSString *robotAddress;  // ip address for the robot
@property NSInteger robotPort;  // port for the robot
@property (copy) NSString *serverAddress;  // ip address for the appium server
@property NSInteger selendroidPort;  // port for the selendroid server
@property (copy) NSString *seleniumGridConfigFile;  // path to the selenium grid config file for appium
@property NSInteger serverPort;  // port for the appium server
@property (copy) NSString *UDID;  // device udid
@property BOOL useAndroidActivity;  // true if an android activity is supplied
@property BOOL useAndroidBrowser;  // true if appium will use the android browser
@property BOOL useAndroidDeviceReadyTimeout;  // true if an android device wait timeout will be used
@property BOOL useAndroidPackage;  // true if an android package is supplied
@property BOOL useAndroidWaitActivity;  // true if an android wait activity is supplied
@property BOOL useAppPath;  // true if the app path is being used
@property BOOL useBundleId;  // true if appium is using the bundle id
@property BOOL useCustomAndroidKeystore;  // true if appium will sign the app with a user specified keystore
@property BOOL useCustomAndroidSdkPath;  // true if a custom android sdk path with be used
@property BOOL useCustomFlags;  // true if custom server flags will be used
@property BOOL useCustomSelendroidPort;  // true if a custom selendroid port is supplied
@property BOOL useExternalAppiumPackage;  // true if an external appium package path with be used
@property BOOL useExternalNodePath;  // true if an external nodeJS binary path with be used
@property BOOL useFullAndroidReset;  // true if appium will use full reset for android
@property BOOL useMobileSafari;  // true if appium will use mobile safari
@property BOOL useNativeInstrumentsLibrary;  // true if the native instruments library will be used
@property BOOL useNodeDebugger;  // true if appium will use node debugging
@property BOOL useRobot;  // true if a robot will be used
@property BOOL useQuietLogging;  // true if appium will use quiet logging
@property BOOL useRemoteServer;  // true if appium will use a remote server
@property BOOL useSeleniumGridConfigFile;  // true if appium will use a selenium grid config file
@property BOOL useUDID;  // true if the udid is being used

- (void) clearLog;  // clears the appium server log display
- (void) forceIosDevice:(AppiumIosDevice)x;  // force a device type
- (void) forceIosOrientation:(AppiumOrientation)x;  // force an orientation
- (BOOL) startServer;  // starts the appium server
- (BOOL) stopServer;  // stops the appium server
- (void) usePlatform:(AppiumPlatform)x;  // sets the platform

@end

// Appium Inspector Window
@interface AppiumInspectorWindowController : SBObject

@property (copy, readonly) NSString *details;  // details for the selected element


@end

