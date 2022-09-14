//
//  RelationshipInteractor.swift
//  Dotify
//
//  Created by An Nguyen Thanh on 7/15/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import UIKit
import Alamofire
import os.log
import FirebaseDatabase

class RelationshipInteractor {
    static let ins = RelationshipInteractor()
    lazy var database = Database.database().reference()
    
    func fetchRelUserSong(completion: @escaping (_ relUserSong: [RelUserSong]?, _ error: Error?) -> () ) {
        
        var relUserSong: [RelUserSong] = []
        AF.request(RelUserSongDataURL.instance.getAllRelUserSongJson()).responseJSON { (response) in
            guard response.error == nil else {
                completion(nil, response.error)
                return
            }
            
            guard let usersJson = response.value as? [String: Any] else {
                os_log("Error while casting json fetchRelUserSong", log: OSLog.default, type: .error)
                return
            }
            usersJson.forEach({ (id, value) in
                guard let value = value as? [String: Any] else {
                    os_log("Error while casting json fetchRelUserSong", log: OSLog.default, type: .error)
                    return
                }
                let eachRelUserSong = RelUserSong.init(JSON: value)
                relUserSong += [eachRelUserSong!]
            })
            completion(relUserSong, nil)
        }
    }
    
    func fetchRelUserAlbum(completion: @escaping (_ relUserAlbum: [RelUserAlbum]?, _ error: Error?) -> () ) {
        var relUserAlbum: [RelUserAlbum] = []
        AF.request(RelUserAlbumDataURL.instance.getAllRelUserAlbumJson()).responseJSON { (response) in
            guard response.error == nil else {
                completion(nil, response.error)
                return
            }
            
            guard let usersJson = response.value as? [String: Any] else {
                os_log("Error while casting json fetchRelUserAlbum", log: OSLog.default, type: .error)
                return
            }
            usersJson.forEach({ (id, value) in
                guard let value = value as? [String: Any] else {
                    os_log("Error while casting json fetchRelUserAlbum", log: OSLog.default, type: .error)
                    return
                }
                let eachRelUserAlbum = RelUserAlbum.init(JSON: value)
                relUserAlbum += [eachRelUserAlbum!]
            })
            completion(relUserAlbum, nil)
        }
    }
    
    func fetchRelUserArtist(completion: @escaping (_ relUserArtist: [RelUserArtist]?, _ error: Error?) -> () ) {
        var relUserArtist: [RelUserArtist] = []
        AF.request(RelUserArtistDataURL.instance.getAllRelUserArtistJson()).responseJSON { (response) in
            guard response.error == nil else {
                completion(nil, response.error)
                return
            }
            
            guard let usersJson = response.value as? [String: Any] else {
                os_log("Error while casting json fetchRelUserArtist", log: OSLog.default, type: .error)
                return
            }
            usersJson.forEach({ (id, value) in
                guard let value = value as? [String: Any] else {
                    os_log("Error while casting json fetchRelUserArtist", log: OSLog.default, type: .error)
                    return
                }
                let eachRelUserArtist = RelUserArtist.init(JSON: value)
                relUserArtist += [eachRelUserArtist!]
            })
            completion(relUserArtist, nil)
        }
    }
    
    func fetchRelUserPlaylist(completion: @escaping (_ relUserPlaylist: [RelUserPlaylist]?, _ error: Error?) -> () ) {
        var relUserPlaylist: [RelUserPlaylist] = []
        AF.request(RelUserPlaylistDataURL.instance.getAllRelUserPlaylistJson()).responseJSON { (response) in
            guard response.error == nil else {
                completion(nil, response.error)
                return
            }
            
            guard let usersJson = response.value as? [String: Any] else {
                os_log("Error while casting json fetchRelUserPlaylist", log: OSLog.default, type: .error)
                return
            }
            usersJson.forEach({ (id, value) in
                guard let value = value as? [String: Any] else {
                    os_log("Error while casting json fetchRelUserPlaylist", log: OSLog.default, type: .error)
                    return
                }
                let eachRelUserPlaylist = RelUserPlaylist.init(JSON: value)
                relUserPlaylist += [eachRelUserPlaylist!]
            })
            completion(relUserPlaylist, nil)
        }
    }
    //use for fav album button
    func loadKeyFav(userID: String, albumID: String, _ completion: @escaping (String?, Error?) -> Void ) {
        AF.request(RelUserAlbumDataURL.instance.getAllRelUserAlbumJson()).responseJSON { (response) in
            guard response.error == nil else {
                completion(nil, response.error)
                return
            }
            let data = response.value as? [String: Any]
            data?.forEach({ (key, value) in
                let relation = value as? [String: String]
                let _userID = relation!["user_id"]
                let _albumID = relation!["album_id"]
                if userID == _userID && albumID == _albumID { completion( key, nil) }
            })
            completion(nil, nil)
        }
    }
    
    func removeFavAlbum(albumID: String, _ completion: @escaping (Error?) -> Void) {
        let curUserID = UserDefaults.standard.string(forKey: "user_id") ?? ""
        loadKeyFav(userID: curUserID, albumID: albumID, { (key, error) in
            guard error == nil else { fatalError("Error while load data") }
            //delete key
            guard key != nil else { return }
            self.database.child("relUserAlbum").child(key!).setValue(nil, withCompletionBlock: { (error, ref) in
                completion(error)
            })
        })
    }
    
    func addFavAlbum(albumID: String, _ completion: @escaping (Error?) -> Void) {
        let curUserID = UserDefaults.standard.string(forKey: "user_id") ?? ""
        loadKeyFav(userID: curUserID, albumID: albumID, { (key, error) in
            guard error == nil else { fatalError("Error while load data") }
            //delete key
            guard key == nil else { return }
            self.database.child("relUserAlbum").childByAutoId().setValue(["user_id": curUserID, "album_id": albumID], withCompletionBlock: { (error, ref) in
                completion(error)
            })
        })
    }
    //use for fav artist button
    func loadKeyFav(userID: String, artistID: String, _ completion: @escaping (String?, Error?) -> Void ) {
        AF.request(RelUserArtistDataURL.instance.getAllRelUserArtistJson()).responseJSON { (response) in
            guard response.error == nil else {
                completion(nil, response.error)
                return
            }
            let data = response.value as? [String: Any]
            data?.forEach({ (key, value) in
                let relation = value as? [String: String]
                let _userID = relation!["user_id"]
                let _artistID = relation!["artist_id"]
                if userID == _userID && artistID == _artistID { completion( key, nil) }
            })
            completion(nil, nil)
        }
    }
    
    func removeFavArtist(artistID: String, _ completion: @escaping (Error?) -> Void) {
        let curUserID = UserDefaults.standard.string(forKey: "user_id") ?? ""
        loadKeyFav(userID: curUserID, artistID: artistID, { (key, error) in
            guard error == nil else { fatalError("Error while load data") }
            //delete key
            guard key != nil else { return }
            self.database.child("relUserArtist").child(key!).setValue(nil, withCompletionBlock: { (error, ref) in
                completion(error)
            })
        })
    }
    
    func addFavArtist(artistID: String, _ completion: @escaping (Error?) -> Void) {
        let curUserID = UserDefaults.standard.string(forKey: "user_id") ?? ""
        loadKeyFav(userID: curUserID, artistID: artistID, { (key, error) in
            guard error == nil else { fatalError("Error while load data") }
            //delete key
            guard key == nil else { return }
            self.database.child("relUserArtist").childByAutoId().setValue(["user_id": curUserID, "artist_id": artistID], withCompletionBlock: { (error, ref) in
                completion(error)
            })
        })
    }
}


