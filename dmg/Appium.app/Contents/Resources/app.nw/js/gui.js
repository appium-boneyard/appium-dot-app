var gui = require('nw.gui');

// Setup the tray menu
var tray = new gui.Tray({icon: 'img/appium_logo_small.png' });
var menu = new gui.Menu();
var appium_status = new gui.MenuItem({ label: 'Appium: On', enabled : false });
var appium_toggle = new gui.MenuItem({ label: 'Turn Appium Off'});
appium_toggle.click = function() { 
    if (this.label == "Turn Appium Off"){
        this.label = "Turn Appium On";
        appium_status.label = "Appium: Off";
        menu.remove(separator);
        menu.remove(listening_message);
        $('#appium-output').append('<p>' + 'Server stopped' + '</p>');
        $('#server-status').text('Server: Off');
    } else {
        this.label = "Turn Appium Off";
        appium_status.label = "Appium: On";
        listening_message.label = "Listening on port 4723";
        menu.append(separator);
        menu.append(listening_message);
        $('#appium-output').append('<p>' + 'Starting server...' + '</p>');
        $('#server-status').html('Server: On&nbsp;');
    } 
}

var separator = new gui.MenuItem({ label: 'Separator', type : 'separator' });
var listening_message = new gui.MenuItem({ label: 'Listening on port 4723', enabled : false });

menu.append(appium_status);
menu.append(appium_toggle);
menu.append(separator);
menu.append(listening_message);
tray.menu = menu;
