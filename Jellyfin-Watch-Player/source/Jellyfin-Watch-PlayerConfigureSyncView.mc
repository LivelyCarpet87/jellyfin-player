import Toybox.Graphics;
import Toybox.WatchUi;

// This is the View that is used to configure the songs
// to sync. New pages may be pushed as needed to complete
// the configuration.
class Jellyfin_Watch_PlayerConfigureSyncView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        // setLayout(Rez.Layouts.ConfigureSyncLayout(dc));
        // Clear the screen so it's not messy behind the menu
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        var menu = new WatchUi.Menu2({:title=>"Sync Settings"});
        var delegate;
        menu.addItem(new WatchUi.MenuItem("Music", null, :music, null));
        menu.addItem(new WatchUi.MenuItem("Audiobooks", null, :audiobooks, null));
        delegate = new MediaTypeMenuInputDelegate(); // a WatchUi.MenuInputDelegate
        WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
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