import Toybox.WatchUi;
using Toybox.System;

class Jellyfin_Watch_PlayerConfigureSyncDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        var menu = new WatchUi.Menu2({:title=>"Sync Settings"});
        var delegate;
        menu.addItem(new WatchUi.MenuItem("Music", null, :music, null));
        menu.addItem(new WatchUi.MenuItem("Audiobooks", null, :audiobooks, null));
        delegate = new MediaTypeMenuInputDelegate(); // a WatchUi.MenuInputDelegate
        WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

}

class MediaTypeMenuInputDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onMenuItem(item) {
        var id = item.getId();

        if (id.equals(:music)) {
            System.println("Manage music.");
        } else if (id.equals(:audiobooks)) {
            System.println("Manage audiobooks.");
        }

        // Pop the menu off the stack to return to the main view
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}