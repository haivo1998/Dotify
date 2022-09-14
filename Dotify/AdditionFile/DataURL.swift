//
//  DataURL.swift
//  Dotify
//
//  Created by Lucas Pham on 7/10/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import Foundation

class DataURL {
    fileprivate var baseURL = "https://dotify-6872f.firebaseio.com"
    fileprivate var baseStorageURL = "gs://dotify-6872f.appspot.com"
    var jsonExt = ".json"
}

class UserDataURL: DataURL {
    static let instance = UserDataURL()
    
    var userBaseURL: String {
        return baseURL + "/users"
    }
    
    func getAllUserJson() -> String {
        return self.userBaseURL + jsonExt
    }
    func getUserJson(id: String) -> String{
        return self.userBaseURL + "/" + id + jsonExt
    }
}

class SongDataURL: DataURL {
    static let instance = SongDataURL()
    
    var songBaseURL: String { return baseURL + "/songs" }
    var songBaseStorageURL: String { return baseStorageURL + "/Music" }
    
    func getAllSongJson() -> String {
        return songBaseURL + jsonExt
    }
    func getSongJson(id: String) -> String{
        return songBaseURL + "/" + id + jsonExt
    }
    func getSongFileURL(filename: String) -> String {
        return songBaseStorageURL + "/" + filename
    }
}

class ArtistDataURL: DataURL {
    static let instance = ArtistDataURL()
    
    var artistBaseURL: String { return baseURL + "/artists" }
    
    func getAllArtistJson() -> String {
        return artistBaseURL + jsonExt
    }
    func getArtistJson(id: String) -> String{
        return artistBaseURL + "/" + id + jsonExt
    }
}
class AlbumDataURL: DataURL {
    static let instance = AlbumDataURL()
    
    var albumBaseURL: String { return baseURL + "/albums" }
    
    func getAllAlbumJson() -> String {
        return albumBaseURL + jsonExt
    }
    func getAlbumJson(id: String) -> String{
        return albumBaseURL + "/" + id + jsonExt
    }
}
class GenreDataURL: DataURL {
    static let instance = GenreDataURL()
    
    var genreBaseURL: String { return baseURL + "/genres" }
    
    func getAllGenreJson() -> String {
        return genreBaseURL + jsonExt
    }
    func getGenreJson(id: String) -> String{
        return genreBaseURL + "/" + id + jsonExt
    }
}
class PlaylistDataURL: DataURL {
    static let instance = PlaylistDataURL()
    var playlistBaseURL: String { return baseURL + "/playlists" }
    func getAllPlaylistJson() -> String { return playlistBaseURL + jsonExt }
    func getPlaylistJson(id: String) -> String { return playlistBaseURL + "/" + id + jsonExt }
}

class RelUserArtistDataURL: DataURL {
    static let instance = RelUserArtistDataURL()
    var relUserArtistBaseURL: String {
        return baseURL + "/relUserArtist"
    }
    func getAllRelUserArtistJson() -> String {
        return relUserArtistBaseURL + jsonExt
    }
}
class RelUserSongDataURL: DataURL {
    static let instance = RelUserSongDataURL()
    var relUserSongBaseURL: String {
        return baseURL + "/relUserSong"
    }
    func getAllRelUserSongJson() -> String {
        return relUserSongBaseURL + jsonExt
    }
}
class RelUserAlbumDataURL: DataURL {
    static let instance = RelUserAlbumDataURL()
    var relUserAlbumBaseURL: String {
        return baseURL + "/relUserAlbum"
    }
    func getAllRelUserAlbumJson() -> String {
        return relUserAlbumBaseURL + jsonExt
    }
}
class RelUserPlaylistDataURL: DataURL {
    static let instance = RelUserPlaylistDataURL()
    var relUserPlaylistDataURL: String {
        return baseURL + "/relUserPlaylist"
    }
    func getAllRelUserPlaylistJson() -> String {
        return relUserPlaylistDataURL + jsonExt
    }
}
class RelPlaylistSongDataURL: DataURL {
    static let instance = RelPlaylistSongDataURL()
    var relPlaylistSongBaseURL: String {
        return baseURL + "/relPlaylistSong"
    }
    func getAllRelPlaylistSongJson() -> String {
        return relPlaylistSongBaseURL + jsonExt
    }
    func getRelPlaylistSongJson(id: String) -> String {
        return relPlaylistSongBaseURL + "/" + id + jsonExt
    }
}
