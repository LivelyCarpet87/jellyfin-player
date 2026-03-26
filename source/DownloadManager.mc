using Toybox.System as System;
using Toybox.Storage as Storage;
using Toybox.Communications as Comm;

class DownloadManager {

    static var downloadQueue = [];

    static function loadQueue() {
        if (Storage.hasKey("downloadQueue")) {
            downloadQueue = Storage.getValue("downloadQueue");
        }
    }

    static function saveQueue() {
        Storage.setValue("downloadQueue", downloadQueue);
    }

    static function enqueue(track, serverUrl, token, useBLE) {
        // Avoid duplicates
        for (var i=0; i<downloadQueue.size(); i++) {
            if (downloadQueue[i].Id == track.Id) return;
        }

        var item = {
            Id: track.Id,
            Name: track.Name,
            Type: track.Type,
            Duration: track.Duration,
            MediaSources: track.MediaSources,
            Thumbnail: track.Thumbnail,
            Progress: 0,
            Downloaded: false,
            Quality: (track.Type=="Audio" && !useBLE) ? "Medium" : "Low",
            HttpErrors: 0,
            serverUrl: serverUrl,
            token: token,
            useBLE: useBLE
        };

        downloadQueue.push(item);
        saveQueue();
        processQueue();
    }

    static function processQueue() {
        for (var i=0; i<downloadQueue.size(); i++) {
            var item = downloadQueue[i];
            if (item.Downloaded) continue;

            var url = item.MediaSources[0].DirectUrl + "?Quality=" + item.Quality;
            Comm.makeWebRequest(url, null, {
                :headers => {"X-Emby-Token": item.token},
                :responseType => Comm.HTTP_RESPONSE_CONTENT_TYPE_BYTE_ARRAY
            }, method(:onDownloadComplete, item));
        }
    }

    static function onDownloadComplete(item, code, data) {
        if (code==200 && data) {
            Storage.setValue(item.Id, data); // store media file
            item.Downloaded = true;
            item.Progress = 100;
            saveQueue();
        } else {
            item.HttpErrors += 1;
            if (item.HttpErrors >= 3 || item.useBLE) {
                // fallback to Low quality for Audio
                if (item.Quality != "Low") {
                    item.Quality = "Low";
                    processQueue(); // retry
                }
            }
        }
    }

    static function deleteTrack(trackId) {
        for (var i=0; i<downloadQueue.size(); i++) {
            if (downloadQueue[i].Id == trackId) {
                Storage.removeValue(trackId); // remove media
                downloadQueue.removeAt(i);
                saveQueue();
                return;
            }
        }
    }
}