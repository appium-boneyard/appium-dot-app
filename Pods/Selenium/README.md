# Selenium.framework

Selenium WebDriver Bindings for Objective-C

To embed in your project take a look at [Appium.app](https://github.com/appium/appium-dot-app) or follow the instructions
[here](http://wiki.remobjects.com/wiki/Linking_Custom_Frameworks_from_your_Xcode_Projects_(Xcode_(Mac))).

## Getting It

  * download it from [cocoapods](https://www.cocoapods.org) by adding Selenium to your .podfile
  * download it as a [ZIP](https://github.com/appium/selenium-objective-c/releases/download/v1.0.1/Selenium.framework.zip).
  * build it yourself

## Building It 

  1. Clone this repository at [https://github.com/appium/selenium-objective-c](https://github.com/appium/selenium-objective-c)
  2. Open the `Selenium.xcodeproj` from the `Selenium` directory.
  3. Ensure that the `Selenium` framework is chosen as the target (not `libSelenium`).
  4. Go to Product > Build For > Running.
  5. Retrive the `Selenium.framework` from the `publish` directory.
