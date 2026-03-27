import Toybox.Application.Storage;
import Toybox.Lang;

module CollectionsManager {
    function initialize() {
        if (Storage.getValue("playlists") == null) {
            Storage.setValue("playlists", []);
            /*
            {
                :playlistId => "p1", // ID on Jellyfin
                :name => "Workout Mix", 
                :lastSynced => "Date Here"/null, 
                :state => stale/downloaded/wanted/unwanted,
                :contents => {:index => :songId}
            }
            */
        }

        if (Storage.getValue("songs") == null) {
            Storage.setValue("songs", {});
            /*
            :songId => "p1", // ID on Jellyfin
            {
                
                :title => "Neon Summer",
                :artist => "SynthWave Enthusiast",
                :contentId => sth,
                :artContentId => sth,
            }
            */
        }

        if (Storage.getValue("audiobooks") == null) {
            Storage.setValue("audiobooks", []); 
            /*
            {
                :audiobookId => "p1", // ID on Jellyfin
                :title => "Neon Summer",
                :artist => "SynthWave Enthusiast",
                :chapters => {:chapterNumber => :chapterId}
            }
            */
        }

        if (Storage.getValue("audiobook_chapters") == null) {
            Storage.setValue("audiobook_chapters", {}); 
            /*
                :chapterId => "p1", // ID on Jellyfin
            {
                :audiobookId => "p1",
                :chapterNumber => 0,
                :title => "Chapter 1",
                :state => stale/downloaded/wanted/unwanted,
                :contentId => sth,
                :artContentId => sth,
            }
            */
        }
    }

    // Retrieves playlists
    function getPlaylists() as Array<Dictionary> {
        var playlists = Storage.getValue("playlists");
        return playlists as Array<Dictionary>;
    }

    function addPlaylist(playlistId as String, name as String) as void {

    }

    function rmPlaylist(playlistId as String) as void {
        
    }

    function markPlaylist(playlistId as String, state as symbol) {
        
    }

    function setPlaylistSongs(playlistId as String, contents as Array<String>) as void {

    }

    function getSong(songId as String) as Dictionary or null {

    }

    function addSong(songId as String, title as String, artist as String, index as Number, contentId, artContentId) {

    }

    function tryRmSong(songId as String) as void { // When a song no longer exists in a playlist, but might exist in another

    }

    function getAudiobooks() as Array<Dictionary> {
        var audiobooks = Storage.getValue("audiobooks");
        return audiobooks as Array<Dictionary>;
    }

    function addAudiobook(audiobookId as String, audiobookTitle as String) as void {

    }

    function rmAudiobook(audiobookId as String) as void {
        
    }

    function addAudiobookChapter(audiobookChapterId as string, chapterTitle as String, audiobookId as String) as void {

    }

    function rmAudiobookChapter(audiobookChapterId as string) as void {
        
    }

    function markAudiobookChapter(audiobookChapterId as String, state as symbol) as void {
        
    }

    function saveAudiobookChapter(audiobookChapterId as String, contentId, artContentId) as void {
        
    }

    function wipeAudiobookChapter(audiobookChapterId as String) as void {
        
    }

}