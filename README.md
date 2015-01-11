## An OS X GUI for Appium

[![Build Status](https://travis-ci.org/appium/appium-dot-app.svg?branch=master)](https://travis-ci.org/appium/appium-dot-app)

If you are new to Appium then please see the [Getting started](http://appium.io/getting-started.html) guide for more information
about the project.

To install:

1. Download the [latest version](https://bitbucket.org/appium/appium.app/downloads/appium.dmg) from [Appium.io](http://appium.io/).
2. Mount the disk image.
3. Drag Appium.app to your Applications folder.

### Parameter Guide

#### Main Window

![Appium Main Window](/README-files/images/mainwindow.png "Appium Main Window")

* **Android Button**: Displays the Android settings.
* **iOS Button**: Displays the iOS settings.
* **Settings Button**: Displays the General settings.
* **Developer Button**: Displays the Developer settings.
* **Robot Button**: Displays the Robot settings.
* **Inspector Button**: Launches the Appium Inspector.
* **Doctor Button**: Launches the Appium doctor.
* **Launch / Stop Button**: Launches or stops the Appium server.
 When the checkbox is checked this will be provided to the server so that all connections will launch this application.
 You only need to supply a path here if you are using the pre-launch preference or if you do not want to supply it as
 part of the capabilities object when you connect.
* **Clear Button**: Clears the display of all log data.

#### Android Settings

* **Application**
 * **App Path**: The path to the Android application (`.apk`) you wish to test.
 * **Choose Button**: Used to choose the path to your application.
 * **Package**: Java package of the Android app to run (e.g. `com.example.android.myApp`).
 * **Wait for Package**: Package name for the Android activity to wait for.
 * **Activity**: Activity name for the Android activity to launch from your package (e.g. `MainActivity`).
 * **Wait for Activity**: Activity name for the Android activity to wait for.
 * **Launch AVD**: Selected AVD will be launched using the Android Emulator.
 * **Wait For Activity**: Android Activity you wish Appium to wait for upon launch.
 * **Use Browser**: Launch the specified Android browser (e.g. `Chrome`).
 * **Full Reset**: Reset app state by uninstalling app instead of clearing app data and also remove the app after the
   session is complete.
 * **No Reset**: Prevent the device from being reset.
 * **Intent Action**: Intent action which will be used to start the activity.
 * **Intent Category**: Intent category which will be used to start the activity.
 * **Intent Flags**: Flags that will be used to start the activity.
 * **Intent Arguments**: Additional intent arguments that will be used to start the activity.
* **Launch Device**
 * **Launch AVD**: Name of the AVD to launch.
 * **Device Ready Timeout**: Timeout in seconds while waiting for device to become ready.
 * **Arguments**: Additional emulator arguments to launch the avd.
* **Capabilities**
 * **Platform Name**: Name of the mobile platform.
 * **Automation Name**: Name of the automation tool (Appium or Selendroid).
 * **Platform Version**: Version of the mobile platform.
 * **Device Name**: Name of the mobile device to use.
 * **Language**: Language for the Emulator.
 * **Locale**: Locale for the Emulator.
* **Advanced**
 * **Android SDK Path**: Path to Android SDK.
 * **Coverage Class**: Fully qualified instrumentation class.
 * **Bootstrap Port**: Port to use on device to talk to Appium.
 * **Selendroid Port**: Local port used for communication with Selendroid.
 * **Chromedriver Port**: Port upon which ChromeDriver will run.
* **Keystore Settings**
 * **Use Custom Settings**: When checked, the keystore will be used to sign apks.
 * **Keystore Path**: Path to keystore.
 * **Keystore Password**: Password to keystore.
 * **Key Alias**: Key alias.
 * **Password**: Key password.

#### iOS Settings

* **Application**
 * **App Path**: The path to the iOS application (`.app`, `.zip`, or `.ipa`) you wish to test.
 * **Choose Button**: Used to choose the path to your application.
 * **BundleID**: The bundle ID for the application you wish Appium to use (e.g. `com.yourCompany.yourApp`).
 * **Use Mobile Safari**: This will make Appium start the Mobile Safari app instead of using a user-supplied application.
   BundleID or App Path should both be unchecked when this option is used.
* **Device Settings**
 * **Force Device**: This will make Appium force the Simulator to iPhone or iPad mode.
 * **Platform Version**: Version of the mobile platform.
 * **Force Orientation**: Force the orientation of the Simulator.
 * **Force Language**: Language for the Simulator.
 * **Force Calendar**: Calendar format for the Simulator.
 * **Force Locale**: Locale for the Simulator.
 * **UDID**: This is the UDID for the mobile device on which you want to run Appium. If this box is checked, Appium will
   use the attached iOS device. If this field is checked, bundle ID must be supplied and app path should be unchecked.
 * **Full Reset**: Delete the entire simulator folder.
 * **No Reset**: Don't reset app state between sessions (don't delete app plist files).
 * **Show Simulator Log**: If checked, the iOS simulator log will be written to the console.
* **Advanced**
 * **Use Native Instruments Library**: Use the native Instruments library rather than the one included with Appium.
 * **Backend Retries**: How many times to retry launching Instruments before reporting that it crashed or timed out.
 * **Instruments Launch Timeout**: How long in ms to wait for Instruments to launch.
 * **Trace Template Path**: `.tracetemplate` file to use with Instruments.
 * **Trace Directory**: Absolute path to the directory used to save iOS Instruments traces.
 * **Xcode Path**: Path to Xcode application.

### Preference Guide

Preferences can be accessed by clicking on the appropriate button in the main window.

![Appium Preferences](/README-files/images/preferences.png "Appium General Settings")

#### General Settings

* **Server**
 * **Server Address**: The IP address on which you want the Appium server to run (127.0.0.1 is localhost).
 * **Port**: The port on which the Appium server will listen for WebDriver commands (4723 is the default).
 * **Use Remote Server Checkbox**: Used to connect Appium Inpector to a server that is already running.
 * **Check For Updates**: Appium will automatically check for updates when starting.
 * **Quiet Logging**: Appium will log out limited information.
 * **Keep Artifacts**: Appium will keep artifacts like `.trace` files around after a session has ended.
 * **Reset Application State After Each Session**: Appium will reset application state (e.g. delete user plists)
   after each session.
 * **Prelaunch Application**: Appium will prelaunch the application before beginning to listen for WebDriver
   commands.
 * **Developer Mode**: Will enable additional settings targeted at Appium project developers.
 * **Callback Address**: IP address to be used for HTTP callback.
 * **Callback Port**: Port to be used for HTTP callback.
* **Logging**
 * **Maximum Log Length**: The maximum number of characters that are allowed in the console. Lower this value if
   you find that the GUI slows down after long use.
 * **Quiet Logging**: Don't use verbose logging output.
 * **Use Colors**: Use colors in console output.
 * **Show Timestamps**: Show timestamps in console output.
 * **Log to File**: Send log output to this file.
 * **Log to WebHook**: Send log output to this HTTP listener.
 * **Force Scroll Log to Bottom**: Force the log to scroll to the bottom when there is new output, regardless of
   the position.
 * **Use Local Timezone**: Use local timezone for timestamps.

#### Developer Settings

* **Enabled**: If checked, developer settings will be observed.
* **Use External NodeJS Binary**: Appium will use the version of NodeJS supplied here instead of the one that ships
  with the application.
* **Use External Appium Package**: Appium will use the version of the Appium package supplied here instead of the one
  bundled with the application.
* **NodeJS Debug Port**: Port on which the NodeJS debugger will run.
* **Break on Application Start**: The NodeJS debug server will break at the application start. (equivalent to
  supplying the debug-brk switch to node)
* **Custom Server Flags**: Custom flags to be used when starting the Appium server. This should only be used if there is
  an option that cannot be adjusted using the Appium UI.

### Inspector / Recorder

Inspector can be accessed by clicking the magnifying glass next to the launch button once the Appium server has launched.
Appium must be running with an app open for inspector to work. Otherwise, it will not work.
![Appium Inspector](/README-files/images/inspector.png "Appium Inspector")

#### Inspector Window

* **Show Invisible Filter**: Elements which are not visible will be displayed in the DOM 3-column-view.
* **Show Disabled Filter**: Elements which are not enabled will be displayed in the DOM 3-column-view.
* **Record Button**: Opens the recording Panel and starts recording actions performed using controls in the Appium
  Inspector.
* **Refresh Button**: Refreshes the DOM 3-column view and the screenshot.
* **Screenshot Area**: Displays the last screenshot taken for the app. You can click this area to select elements
  in the DOM.
* **Details Area**: Displays details about the currently selected element.

#### Action Palette

The action pallete contains buttons that will trigger actions on the device under test. You can try out actions here
or enter them to be recorded.

* **Touch Section**: Contains buttons to perform touch events like tapping and swiping.
* **Text Section**: Contains buttons to perform text events like typing and executing JavaScript.
* **Alerts Section**: Contains buttons to perform events on alerts and actionsheets.

#### Recorder Drawer

The recorder draw contains the code generated by recorded actions you've performed while recording
is enabled.

* **Language Selection Dropdown**: Changes the language your recorded actions are displayed in.
* **Add Boilerplate Checkbox**: Checking this block will display code used to setup the Selenium instance along
  with code related to the actions you have recorded. Unchecking this box will only show only the code from the actions
  you have recorded.
* **XPath Only Checkbox**: Checking this will cause all element identifiers to be created using XPath.
* **Replay Button**: Replays the actions that you have recorded.
* **Undo Button**: Deletes the last recorded action.
* **Redo Button**: Adds back the last undone action.
* **Clear Button**: Removes all recorded actions.
