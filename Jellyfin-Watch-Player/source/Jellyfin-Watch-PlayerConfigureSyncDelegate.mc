import Toybox.WatchUi;
using Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Lang;
import Toybox.Communications;

class Jellyfin_Watch_PlayerConfigureSyncDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

}

class MediaTypeMenuInputDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onMenuItem(item) {
        var id = item.getId();

        if (id == :music) {
            getPlaylists();
        } else if (id == :audiobooks) {

        } else if (id == :sync_now) {
            // 1. Tell the OS to start the sync process
            Communications.makeSyncRequest();
            // 2. Pop the menu so the user sees the system sync UI
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }

        // Pop the menu off the stack to return to the main view
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}

class SyncPlaylistMenuUI {
    function showPlaylistMenu() {
        var playlists = CollectionsManager.getPlaylists();
        var menu = new WatchUi.Menu2({:title => "Playlists"});

        for (var i = 0; i < playlists.size(); i++) {
            var playlist = playlists[i];
            var ts = pl[:lastSynced];
            // Inline logic: If ts is null, use "Never", else format the timestamp
            var syncTimeLabel = (ts == null) 
                ? "Never" 
                : Time.Gregorian.info(new Time.Moment(ts), Time.FORMAT_SHORT).month.format("%02d") + "/" + 
                Time.Gregorian.info(new Time.Moment(ts), Time.FORMAT_SHORT).day.format("%02d");

            // Add each playlist as a menu item
            // Use the 'id' as the identifier so the delegate knows which one was picked
            menu.addItem(
                new WatchUi.MenuItem(
                    playlist[:name],     // Label
                    syncTimeLabel,          // Sub-label
                    playlist[:id],       // Identifier
                    null                 // Options
                )
            );
        }

        WatchUi.pushView(menu, new SyncPlaylistSelectMenuDelegate(), WatchUi.SLIDE_UP);
    }
}

class SyncPlaylistSelectMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onMenuItem(item) {
        var id = item.getId();

        // Pop the menu off the stack to return to the main view
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}