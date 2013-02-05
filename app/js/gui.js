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
    } else {
        this.label = "Turn Appium Off";
        appium_status.label = "Appium: On";
    } 
}

menu.append(appium_status);
menu.append(appium_toggle);
menu.append(new gui.MenuItem({ label: 'Separator', type : 'separator' }));
menu.append(new gui.MenuItem({ label: 'Listening on port 4723', enabled : false }));
tray.menu = menu;

//tray.on('click', function(){
//   alert('yo');
//}
