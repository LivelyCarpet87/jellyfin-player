import Toybox.Application.Storage;
import Toybox.Lang;

module CollectionsManager {
    // Retrieves playlists or initializes them if they don't exist
    function getPlaylists() as Array<Dictionary> {
        var playlists = Storage.getValue("playlists");
        
        if (playlists == null) {
            // Create initial playlists store
            playlists = [
                // {:id => "p1", :name => "Workout Mix", :lastSynced => "Date Here"/null},
            ];
            Storage.setValue("playlists", playlists);
        }
        
        return playlists as Array<Dictionary>;
    }

    function getAudiobooks() as Array<Dictionary> {
        var audiobooks = Storage.getValue("audiobooks");
        
        if (audiobooks == null) {
            // Create initial audiobooks store
            audiobooks = [
                // {:id => "p1", :name => "The Expanse", :lastSynced => "Date Here"/null},
            ];
            Storage.setValue("audiobooks", audiobooks);
        }
        
        return audiobooks as Array<Dictionary>;
    }
}