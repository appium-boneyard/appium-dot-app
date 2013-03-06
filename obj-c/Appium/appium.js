var appium = require('appium');
var argparse = require('argparse');

process.env['Appium_app'] = '1';

var parser = new argparse.ArgumentParser({
                   version: '~0.1.10',
                   addHelp: true,
                   description: 'Mac OS X GUI for Appium'
                   });

parser.addArgument([ '--app' ]
                   , { required: false
				   , defaultValue: null
				   , help: 'IOS: abs path to simulator-compiled .app file or the bundle_id of the desired target on device; Android: abs path to .apk file'
				   , example: "/abs/path/to/my.app"
				   , nargs: 1
                   });

parser.addArgument([ '-V', '--verbose' ], { required: false
				   , defaultValue: false
				   , action: 'storeTrue'
				   , help: 'Get verbose logging output'
				   , nargs: 0
				   });

parser.addArgument([ '-U', '--udid' ]
                   , { required: false
				   , defaultValue: null
				   , example: "1adsf-sdfas-asdf-123sdf"
				   , help: '(IOS-only) Unique device identifier of the connected physical device'
				   , nargs: 0
                   });

parser.addArgument([ '-a', '--address' ]
                   , { defaultValue: '0.0.0.0'
				   , required: false
				   , example: "0.0.0.0"
				   , help: 'IP Address to listen on'
				   , nargs: 1
                   });

parser.addArgument([ '-p', '--port' ]
                   , { defaultValue: 4723
				   , required: false
				   , example: "4723"
				   , help: 'Port to listen on'
				   , nargs: 1
                   });

parser.addArgument([ '-k', '--keep-artifacts' ]
                   , { defaultValue: false
				   , dest: 'keepArtifacts'
				   , action: 'storeTrue'
				   , required: false
				   , help: '(IOS-only) Keep Instruments trace directories'
				   , nargs: 0
                   });

parser.addArgument([ '--no-reset' ]
                   , { defaultValue: false
				   , dest: 'noReset'
				   , action: 'storeTrue'
				   , required: false
				   , help: 'Reset app state after each session (IOS: delete plist; Android: ' +
				   'install app before session and uninstall after session)'
				   , nargs: 0
                   });

parser.addArgument([ '-l', '--pre-launch' ]
                   , { defaultValue: false
				   , dest: 'launch'
				   , action: 'storeTrue'
				   , required: false
				   , help: 'Pre-launch the application before allowing the first session ' +
				   '(Requires --app and, for Android, --app-pkg and --app-activity)'
				   , nargs: 0
                   });

parser.addArgument([ '-g', '--log' ]
                   , { defaultValue: null
				   , required: false
				   , example: "/path/to/appium.log"
				   , help: 'Log output to this file instead of stdout'
				   , nargs: 1
                   });

parser.addArgument([ '-G', '--webhook' ]
                   , {  defaultValue: null
				   , required: false
				   , example: "localhost:9876"
				   , help: 'Also send log output to this HTTP listener'
				   , nargs: 1
                   });

parser.addArgument([ '-w', '--warp' ]
                   , { defaultValue: false
				   , action: 'storeTrue'
				   , required: false
				   , help: '(IOS-only) IOS has a weird built-in unavoidable sleep. One way ' +
				   'around this is to speed up the system clock. Use this time warp ' +
				   'hack to speed up test execution (WARNING, actually alters clock, ' +
				   'could be bad news bears!)'
				   , nargs: 0
                   });

parser.addArgument([ '--app-pkg' ]
                   , { dest: 'androidPackage'
				   , defaultValue: null
				   , required: false
				   , example: "com.example.android.myApp"
				   , help: "(Android-only) Java package of the Android app you want to run " +
				   "(e.g., com.example.android.myApp)"
				   , nargs: 1                   });

parser.addArgument([ '--app-activity' ]
                   , { dest: 'androidActivity'
				   , defaultValue: 'MainActivity'
				   , required: false
				   , example: "MainActivity"
				   , help: "(Android-only) Activity name for the Android activity you want " +
				   "to launch from your package (e.g., MainActivity)"
				   , nargs: 1
                   });

parser.addArgument([ '--skip-install' ]
                   , {  dest: 'skipAndroidInstall'
				   , defaultValue: false
				   , action: 'storeTrue'
				   , required: false
				   , help: "(Android-only) Don't install the app; assume it's already on the " +
				   'device with a recent version. Useful for test development ' +
				   'against an unchanging app.'
				   , nargs: 0
                   });

var argsFromParser = parser.parseArgs();

var args = {
    verbose: argsFromParser.verbose
    , udid: argsFromParser.udid
    , address: argsFromParser.address
    , port: parseInt(argsFromParser.port,10)
    , app : argsFromParser.app
    , keepArtifacts: argsFromParser.keepArtifacts
    , warp: argsFromParser.warp
	, noReset: argsFromParser.noReset
};
  
appium.run(args, function() { console.log('Rock and roll.'.grey); });
