//
//  SongInteractor.swift
//  Dotify
//
//  Created by An Nguyen Thanh on 7/25/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import UIKit
import Alamofire
import os.log
import Firebase

class SongInteractor {
    static let ins = SongInteractor()
    lazy var database = Database.database().reference()
    func fetchSongList(completion: @escaping (_ songList: [Song]?, _ error: Error?) -> Void ) {
        
        var songList: [Song] = []
        AF.request(SongDataURL.instance.getAllSongJson()).responseJSON { (response) in
            guard response.error == nil else {
                completion(nil, response.error)
                return
            }
            
            guard let usersJson = response.value as? [String: Any] else {
                os_log("Error while casting json fetchSongList", log: OSLog.default, type: .error)
                return
            }
            usersJson.forEach({ (id, value) in
                guard let value = value as? [String: Any] else {
                    os_log("Error while casting json fetchSongList", log: OSLog.default, type: .error)
                    return
                }
                let eachSong = Song.init(JSON: value)
                eachSong?.id = id
                songList += [eachSong!]
            })
            completion(songList, nil)
        }
    }
    
    func loadKeyFav(userID: String, songID: String, _ completion: @escaping (String?, Error?) -> Void ) {
        AF.request(RelUserSongDataURL.instance.getAllRelUserSongJson()).responseJSON { (response) in
            guard response.error == nil else {
                completion(nil, response.error)
                return
            }
            let data = response.value as? [String: Any]
            data?.forEach({ (key, value) in
                let relation = value as? [String: String]
                let _userID = relation!["user_id"]
                let _songID = relation!["song_id"]
                if userID == _userID && songID == _songID { completion( key, nil) }
            })
            completion(nil, nil)
        }
    }
    
    func removeFavSong(songID: String, _ completion: @escaping (Error?) -> Void) {
        let curUserID = UserDefaults.standard.string(forKey: "user_id") ?? ""
        loadKeyFav(userID: curUserID, songID: songID, { (key, error) in
            guard error == nil else {
                os_log("Error while load data", log: OSLog.default, type: .error)
                return
            }
            //delete key
            guard key != nil else { return }
            self.database.child("relUserSong").child(key!).setValue(nil, withCompletionBlock: { (error, ref) in
                completion(error)
            })
        })
    }
    
    func addFavSong(songID: String, _ completion: @escaping (Error?) -> Void) {
        let curUserID = UserDefaults.standard.string(forKey: "user_id") ?? ""
        loadKeyFav(userID: curUserID, songID: songID, { (key, error) in
            guard error == nil else {
                os_log("Error while load data", log: OSLog.default, type: .error)
                return
            }
            //delete key
            guard key == nil else { return }
            self.database.child("relUserSong").childByAutoId().setValue(["user_id": curUserID, "song_id": songID], withCompletionBlock: { (error, ref) in
                completion(error)
            })
        })
    }
}
