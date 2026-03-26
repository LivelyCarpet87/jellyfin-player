using Toybox.WatchUi as WatchUi;
using Toybox.Graphics as Graphics;
using Toybox.System as System;
using JellyfinApi as JF;
using ImageSelector as IS;
using DownloadManager as DM;

class LibraryView extends WatchUi.View {

    var playlists = [];
    var items = [];
    var selected = 0;
    var scrollOffset = 0;
    var token = nil;
    var serverUrl = nil;
    var useBLE = false;

    function initialize() {
        serverUrl = System.getDeviceSettings("serverUrl");
        var username  = System.getDeviceSettings("username");
        var password  = System.getDeviceSettings("password");

        useBLE = System.getNetworkType() == System.NETWORK_BLUETOOTH;

        JF.login(serverUrl, username, password, method(:onLogin));
    }

    function onLogin(code, data) {
        if (code != 200) return;
        var resp = Toybox.Json.parse(data);
        token = resp.SessionInfo.AccessToken;
        JF.fetchPlaylists(serverUrl, token, method(:onPlaylistsFetched));
    }

    function onPlaylistsFetched(code, data) {
        if (code != 200) return;
        var resp = Toybox.Json.parse(data);
        playlists = resp.Items;
        if (playlists.size() > 0) fetchPlaylistItems(playlists[0].Id);
    }

    function fetchPlaylistItems(playlistId) {
        JF.fetchPlaylistItems(serverUrl, token, playlistId, method(:onPlaylistItemsFetched));
    }

    function onPlaylistItemsFetched(code, data) {
        if (code != 200) return;
        var resp = Toybox.Json.parse(data);
        items = [];

        var totalSong = 0;
        var totalAudiobook = 0;
        var maxSongSeconds = 90*60;
        var maxAudiobookSeconds = 120*60;

        for (var i=0; i<resp.Items.size(); i++) {
            var t = resp.Items[i];
            var duration = JF.ticksToSeconds(t.RunTimeTicks);

            if (t.Type=="Audio" && totalSong + duration > maxSongSeconds) continue;
            if (t.Type=="Audiobook" && totalAudiobook + duration > maxAudiobookSeconds) continue;

            if (t.Type=="Audio") totalSong += duration;
            if (t.Type=="Audiobook") totalAudiobook += duration;

            var track = {
                Id: t.Id,
                Name: t.Name,
                Type: t.Type,
                Duration: duration,
                MediaSources: t.MediaSources,
                Thumbnail: nil,
                Progress: 0,
                Quality: (t.Type=="Audio" && !useBLE) ? "Medium" : "Low"
            };

            IS.fetchBestImage(serverUrl, token, t.Id, method(:onThumbnailFetched, track));
            DM.enqueue(track, serverUrl, token, useBLE);
            items.push(track);
        }

        scrollOffset = 0;
        selected = 0;
    }

    function onThumbnailFetched(track, code, data) {
        if (code == 200 && data) track.Thumbnail = data;
        System.println("Thumbnail fetched for: " + track.Name);
    }

    function onUpdate(dc) {
        dc.clear();
        dc.drawText(5,0,Graphics.FONT_SMALL,"Playlists:");
    }

    function onKey(key) {
        if (key == WatchUi.KEY_BACK) WatchUi.popView();
    }
}