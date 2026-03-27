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

    function onSelect(item) {
        var id = item.getId();

        if (id == :playlists) {
            showPlaylistMenu();
        } else if (id == :audiobooks) {

        } else if (id == :sync_now) {
            // Modern API for triggering Audio Sync
            Communications.startSync2( {:message => "Pulling from Jellyfin."} ); 
                        
            // Pop the menu so the system sync UI (progress bar) takes over
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            
        
        }
    }

    function showPlaylistMenu() {
        var playlists = CollectionsManager.getPlaylists();
        var menu = new WatchUi.Menu2({:title => "Playlists"});

        if (playlists.size() == 0){
            WatchUi.showToast("No Playlists Found", null);
            return;
        }

        for (var i = 0; i < playlists.size(); i++) {
            var playlist = playlists[i];
            var ts = playlist[:lastSynced];
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

    function onSelect(item) {
        var id = item.getId();

        // Pop the menu off the stack to return to the main view
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}