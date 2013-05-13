An OS X GUI for Appium
=======================

To install:

1. Download the [latest version](https://bitbucket.org/appium/appium.app/downloads/appium.dmg) from appium.io
2. Mount the disk-image
3. Drag Appium.app to your Applications folder

Parameter Guide
------------

### Main Window

![Appium Main Window](/README-files/images/mainwindow.png "Appium Main Window")

**IP Address**: the IP addres on which you want the appium server to run (127.0.0.1 is localhost)<br />
**Port**: the port on which the appium server will listen for WebDriver commands (4723 is the default)<br />
**Use Remote Server Checkbox**: Used to connect Appium Inpector to a server that is already running.
(only appears in Developer Mode) <br />
**Inspector (i) Button**: launches the Appium Inspector<br />
**Launch / Stop Button**: launches or stops the Appium server<br />
**App Path**: the path to the iOS application (.app,.zip, or.ipa) or Android application (.apk) you wish to test.
When the checkbox is checked this will be provided to the server so that all connections will boot this application.
You only need to supply a path here if you are using the pre-launch preference or if you do not want to supply it as
part of the capabilities object when you connect.<br />
**Choose Button**: used to choose the path to your application<br />
**Clear Button**: clears the display of all log data<br/>

### iOS Tab

**UDID**: this is the UDID for the mobile device on which you want to run Appium. If this box is checked, Appium will
use the attached ios device. If this field is checked, bundle ID must be supplied and app path should be unchecked.<br />
**BundleID**: the bundle ID for the application you wish Appium to use (e.g. com.yourCompany.yourApp)<br />
**Force Device**: this will tell Appium to force the simulator to iPhone or iPad mode<br />
**Use Mobile Safari**: this will have Appium boot the Mobile Safari app instead of using a user-supplied application.
BundleID or App Path should both be unchecked when this option is used.<br />

### Android Tab

**Package**: Android Package you wish to use<br />
**Activity**: Android Activity you wish to launch with<br />
**Launch AVD**: Selected AVD will be launched using the Android Emulator.<br />
**Wait For Activity**: Android Activity you wish Appium to wait for upon launch.<br />

Preference Guide
------------
Preferences can be accessed by Going to Appium > Preferences or with the keyboard shortcut (COMMAND + ,)<br />
![Appium Preferences](/README-files/images/preferences.png "Appium Preferences")

**Check For Updates**: Appium will automatically check for updates upon boot.<br />
**Quiet Logging**: Appium will log out limited information.<br />
**Keep Artifactes**: Appium will keep artifacts like .trace files around after a session has ended. <br />
**Reset Application State After Each Session**: Appium will reset application state (e.g. delete user plists)
after each session. <br />
**Prelaunch Application**: Appium will prelaunch the application before beginning to listen for WebDriver
commands<br />
**Developer Mode**: will enable additional settings targeted at Appium project developers.

### iOS Settings
**Use Native Instruments Lib**: Appium will not use the "Instruments Without Delay" plugin. (commands will be
very slow)<br />
**Force Orientation**: Appium will rotate the device to Portrait or Landscape.<br />

### Android Settings
**Full Reset**: a full reset will be performed before launching the server. This includes uninstalling the .apk
under test.<br />
**Device Ready Timeout**: This is the maximum amount of time Appium will wait for a connected Android device to
be ready.<br />

### Developer Settings
**Use External NodeJS Binary**:  Appium will use the version of NodeJS supplied here instead of the one that ships
with the application.<br />
**Use External Appium Package**: Appium will use the version of the appium package supplied here instead of the one
bundled with the application.<br />
**NodeJS Debug Port**: Port on which the NodeJS debugger will run.<br />
**Break on Application Start**: The nodeJS debug server will break at the application start. (equivalent to
supplying the debug-brk switch to node)<br />

Inspector (BETA)
------------
Inspector can be accessed by clicking the blue "i" next to the launch button once the Appium server has launched.
Appium must be running with an app open for inspector to work. Otherwise, it may crash.<br />
![Appium Inspector](/README-files/images/inspector.png "Appium Inspector")
