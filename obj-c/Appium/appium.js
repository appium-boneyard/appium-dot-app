var appium = require('appium');
var argparse = require('argparse');

process.env['Appium_app'] = '1';

var parser = new argparse.ArgumentParser({
                   version: '~0.1.10',
                   addHelp: true,
                   description: 'Mac OS X GUI for Appium'
                   });

parser.addArgument([ '--app' ]
                   , { required: false, help: 'path to simulators .app file or the bundle_id of the desired target on device'
                   });

parser.addArgument([ '-V', '--verbose' ], { required: false, help: 'verbose mode' });
parser.addArgument([ '-U', '--udid' ]
                   , { required: false, help: 'unique device identifier of the SUT'
                   });

parser.addArgument([ '-a', '--address' ]
                   , { defaultValue: '127.0.0.1'
                   , required: false
                   , help: 'ip address to listen on'
                   });

parser.addArgument([ '-p', '--port' ]
                   , { defaultValue: 4723, required: false, help: 'port to listen on'
                   });

parser.addArgument([ '-r', '--remove' ]
                   , { defaultValue: true, required: false, help: 'remove Instruments trace directories'
                   });

parser.addArgument([ '-s', '--reset' ]
                   , { defaultValue: true, required: false, help: 'reset app plist/state after each session'
                   });

parser.addArgument([ '-l', '--launch' ]
                   , { defaultValue: false, required: false, help: 'pre-launch the ios-sim'
                   });

parser.addArgument([ '-g', '--log' ]
                   , { defaultValue: null, required: false, help: 'log to a file'
                   });

parser.addArgument([ '-G', '--webhook' ]
                   , { defaultValue: null, required: false, help: 'log to a webhook'
                   });

parser.addArgument([ '-w', '--warp' ]
                   , { defaultValue: false, required: false, help: 'use time warp to speed up test execution (WARNING, this modifies system clock, could be bad news bears!)'
                   });

var argsFromParser = parser.parseArgs();

var args = {
    verbose: argsFromParser.verbose
    , udid: argsFromParser.udid
    , address: argsFromParser.address
    , port: parseInt(argsFromParser.port,10)
    , app : argsFromParser.app
    , remove: argsFromParser.remove
    , warp: argsFromParser.warp
	, reset: argsFromParser.reset
};
  
appium.run(args, function() { console.log('Rock and roll.'.grey); });
