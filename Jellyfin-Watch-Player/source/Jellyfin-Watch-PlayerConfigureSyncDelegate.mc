import Toybox.WatchUi;
using Toybox.System;

class Jellyfin_Watch_PlayerConfigureSyncDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        var menu = new WatchUi.Menu();
        var delegate;
        menu.setTitle("Sync Content");
        menu.addItem("Music", :music);
        menu.addItem("Audiobooks", :audiobooks);
        delegate = new MediaTypeMenuInputDelegate(); // a WatchUi.MenuInputDelegate
        WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

}

class MediaTypeMenuInputDelegate extends WatchUi.MenuInputDelegate {
    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if (item == :music) {
            System.println("Managing music.");
        } else if (item == :audiobooks) {
            System.println("Managing audiobooks.");
        }
    }
}