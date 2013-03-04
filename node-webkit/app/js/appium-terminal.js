// Convert the 'terminal' DOM element into a live terminal.
// This example defines several custom commands for the terminal.
var terminal = new Terminal('terminal', {welcome: 'Ohai! Welcome to Appium!'}, {
    execute: function(cmd, args) {
        switch (cmd) {
            case 'clear':
                terminal.clear();
                return '';

            case 'help':
                return 'Commands: clear, help,  version<br>More help available <a class="external" href="http://github.com/SDA/terminal" target="_blank">here</a>';

            case 'version':
                return '1.0.0';

            default:
                // Unknown command.
                return false;
        };
    }
});
