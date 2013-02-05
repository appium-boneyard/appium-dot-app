var gui = require('nw.gui');

// Setup the tray menu
var tray = new gui.Tray({icon: 'img/appium_logo_small.png' });
var menu = new gui.Menu();
menu.append(new gui.MenuItem({ label: 'Appium: On', enabled : false }));
menu.append(new gui.MenuItem({ label: 'Turn Appium Off' }));
menu.append(new gui.MenuItem({ label: 'Separator', type : 'separator' }));
menu.append(new gui.MenuItem({ label: 'Listening on port 4723', enabled : false }));
tray.menu = menu;
