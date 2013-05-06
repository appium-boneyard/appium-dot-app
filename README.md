An OS X GUI for Appium
=======================

To install:

1. Download the [latest version](https://bitbucket.org/appium/appium.app/downloads/appium-1.5.5.dmg) from appium.io
2. Mount the disk-image
3. Drag Appium.app to your Applications folder

Parameter Guide
------------

### Main Window

![Appium Main Window](/web/images/mainwindow.png "Appium Main Window")

**IP Address**: the IP addres on which you want the appium server to run (127.0.0.1 is localhost)<br />
**Port**: the port on which the appium server will listen for WebDriver commands (4723 is the default)<br />
**Launch / Stop Button**: launches or stops the Appium server<br />
**App Path**: the path to the iOS application (.app) or Android application (.apk) you wish to test.
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

Preference Guide
------------
Preferences can be accessed by Going to Appium > Preferences or with the keyboard shortcut (COMMAND + ,)<br />
![Appium Preferences](/web/images/preferences.png "Appium Preferences")

**Check For Updates**: Appium will automatically check for updates upon boot.<br />
**Verbose Logging**: Appium will log out verbose information.<br />
**Keep Artifactes**: Appium will keep artifacts like .trace files around after a session has ended. <br />
**Reset App After Each Session**: Appium will reset application state (e.g. delete user plists) after each session. <br />
**Prelaunch Simulator**: Appium will prelaunch the simulator before beginning to listen for WebDriver commands<br />
**Use Instruments Without Delay**: Appium will use the "Instruments Without Delay" plugin, which makes iOS automation much faster.<br />
**Warp Speed**: (DO NOT USE) This is an old way of making Appium faster. Please use "Use Instruments Without Delay" instead.<br />

Inspector (BETA)
------------
Inspector can be accessed by clicking the blue "i" next to the launch button once the Appium server has launched. Appium must be running with an app open for inspector to work. Otherwise, it may crash.<br />
![Appium Inspector](/web/images/inspector.png "Appium Inspector")
