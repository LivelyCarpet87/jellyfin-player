using Toybox.Communications as Comm;

class JellyfinApi {

    static function login(serverUrl, username, password, callback) {
        var url = serverUrl + "/Users/AuthenticateByName";
        var body = Toybox.Json.stringify({
            "Username": username,
            "Pw": password
        });

        Comm.makeWebRequest(url, body, {
            :method => "POST",
            :headers => {"Content-Type":"application/json"}
        }, callback);
    }

    static function fetchPlaylists(serverUrl, token, callback) {
        var url = serverUrl + "/Playlists";
        Comm.makeWebRequest(url, null, {
            :method => "GET",
            :headers => {"X-Emby-Token": token}
        }, callback);
    }

    static function fetchPlaylistItems(serverUrl, token, playlistId, callback) {
        var url = serverUrl + "/Playlists/" + playlistId + "/Items";
        Comm.makeWebRequest(url, null, {
            :method => "GET",
            :headers => {"X-Emby-Token": token}
        }, callback);
    }

    static function fetchMediaUrl(serverUrl, token, itemId, quality) {
        return serverUrl + "/Videos/" + itemId + "/stream?Quality=" + quality + "&api_key=" + token;
    }

    static function ticksToSeconds(ticks) {
        return Math.floor(ticks / 10000000);
    }
}