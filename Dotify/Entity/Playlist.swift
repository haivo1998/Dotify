//
//  Playlist.swift
//  Dotify
//
//  Created by An Nguyen Thanh on 7/17/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import Foundation
import ObjectMapper
import FirebaseDatabase

class Playlist: Mappable {
    //MARK: Attribute
    var id: String?
    var name: String?
    var userId: String?
    var ownerOfPlaylist: String?
    var listSongIds: [String] = []
    var imageUrl: String?
    var dateCreated: Date? {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
            guard let dateCreatedString = dateCreatedString else { return nil }
            return dateFormatter.date(from: dateCreatedString)
        }
    }
    var dateCreatedString: String?
    init(){}
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name                <- map["name"]
        userId              <- map["user_id"]
        dateCreatedString   <- map["date_create"]
        imageUrl            <- map["imageUrl"]
    }
}

class PlaylistFirebase {
    static let instance = PlaylistFirebase()
    var playlistRef: DatabaseReference {
        return Database.database().reference().child("playlists")
    }
    var relRef: DatabaseReference {
        return Database.database().reference().child("relUserPlaylist")
    }
    func addRel(userId: String, playlistId: String, _ completion: @escaping (Error?, DatabaseReference) -> Void){
        let rel = RelUserPlaylist()
        rel.userId = userId
        rel.playlistId = playlistId
        rel.dateStr = convertDateToStr(Date())
        relRef.childByAutoId().setValue(rel.toJSON()) { (error, ref) in
            completion(nil, ref)
        }
    }
    func removeRel(userId: String, playlistId: String, _ completion: @escaping (Error?, DatabaseReference) -> Void){
        relRef.observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.value as? [String: [String: Any]] else { return }
            let myGroup = DispatchGroup()
            data.forEach({ (key, value) in
                let ref = RelUserPlaylist.init(JSON: value)
                if ref?.userId == userId && ref?.playlistId == playlistId {
                    myGroup.enter()
                    self.relRef.child(key).setValue(nil, withCompletionBlock: { (error, ref) in
                        myGroup.leave()
                    })
                }
            })
            myGroup.notify(queue: .main, execute: {
                completion(nil, self.relRef)
            })
        }
        
    }
    func loadRel(userId: String, playlistId: String, _ completion: @escaping ( RelUserPlaylist?, Error?) -> Void) {
        relRef.observe(.value) { (snapshot) in
            let records = snapshot.value as? [String: [String: Any]]
            var isFound = false
            records?.forEach({ (key, value) in
                let rel = RelUserPlaylist.init(JSON: value)
                if userId == rel?.userId && playlistId == rel?.playlistId {
                    isFound = true
                    completion(rel, nil)
                    return
                }
            })
            if !isFound { completion(nil, nil) }
        }
    }
    var playlistSongRelRef: DatabaseReference {
        return Database.database().reference().child("relPlaylistSong")
    }
    func loadPlaylist(id: String, _ completion: @escaping (Playlist, Error?) -> Void){
        playlistRef.child(id).observe(.value) { (snapshot) in
            if let value = snapshot.value as? [String: Any] {
                let playlist = Playlist.init(JSON: value)
                completion(playlist!, nil)
            }
        }
    }
    func addPlaylist(playlist: Playlist, completion: @escaping (_ error: Error?, _ ref: DatabaseReference) -> () ){
        playlistRef.childByAutoId().setValue(playlist.toJSON()) { (error, ref) in
            completion(error, ref)
        }
    }
    func removePlaylist(id: String, _ completion: @escaping (Error?, DatabaseReference) -> Void){
        removeAllSongs(of: id) { (error, ref) in
            guard error == nil else {
                completion(error, self.playlistRef)
                return
            }
            self.playlistRef.child(id).setValue(nil)
        }
    }
    func addSongToPlaylist(songID: String, playlistID: String, _ completion: @escaping (Error?, DatabaseReference) -> Void ) {
        let dateStr = convertDateToStr(Date())
        playlistSongRelRef.childByAutoId().setValue(["date_add": dateStr, "playlist_id": playlistID, "song_id": songID]) { (error, ref) in
            completion(error, ref)
        }
    }
    func removeSongFromPlaylist(songID: String, playlistID: String, _ completion: @escaping (Error?, DatabaseReference) -> Void ) {
    
        playlistSongRelRef.observeSingleEvent(of: .value) { (snapshot) in
            let data = snapshot.value as? [String: Any]
            data?.forEach({ (key, value) in
                guard let dataRecord = value as? [ String: Any ] else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Can't cast value"])
                    completion(error, Database.database().reference())
                    return
                }
                guard let _songId = dataRecord["song_id"] as? String, let _playlistId = dataRecord["playlist_id"] as? String else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Database don't have key"])
                    completion(error, Database.database().reference())
                    return
                }
                if songID == _songId && playlistID == _playlistId {
                    self.playlistSongRelRef.child(key).setValue(nil, withCompletionBlock: { (error, ref) in
                        completion(error, ref)
                        return
                    })
                }
            })
        }
    }
    func removeAllSongs(of playlistID: String, _ completion: @escaping (Error?, DatabaseReference) -> Void) {
        playlistSongRelRef.observeSingleEvent(of: .value) { (snapshot) in
            let data = snapshot.value as? [String: Any]
            let myGroup = DispatchGroup()
            data?.forEach({ (key, value) in
                guard let dataRecord = value as? [ String: Any ] else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Can't cast value"])
                    completion(error, Database.database().reference())
                    return
                }
                guard let _ = dataRecord["song_id"] as? String, let _playlistId = dataRecord["playlist_id"] as? String else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Database don't have key"])
                    completion(error, Database.database().reference())
                    return
                }
                if playlistID == _playlistId {
                    myGroup.enter()
                    self.playlistSongRelRef.child(key).setValue(nil, withCompletionBlock: { (error, ref) in
                        guard error == nil else { myGroup.setValue(error, forKey: "error"); myGroup.leave(); return; }
                        myGroup.leave()
                    })
                }
            })
            myGroup.notify(queue: .main, execute: {
//                let error = myGroup.value(forKey: "error") as? Error
                completion(nil, self.playlistRef)
            })
        }
    }
}
