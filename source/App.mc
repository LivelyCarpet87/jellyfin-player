using Toybox.WatchUi as WatchUi;
using LibraryView as LV;
using DownloadQueueView as DQV;

class App extends WatchUi.Application {

    function initialize() {
        WatchUi.pushView(new LV.LibraryView());
    }

    function onKey(key) {
        if (key == WatchUi.KEY_MENU) {
            WatchUi.pushView(new DQV.DownloadQueueView());
        }
    }
}