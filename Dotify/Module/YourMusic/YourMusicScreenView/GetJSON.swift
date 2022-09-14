//
//  FetchJSON.swift
//  Dotify
//
//  Created by An Nguyen Thanh on 7/15/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import UIKit
import Alamofire

func fetchSongList(completion: @escaping (_ songList: [Song]?, _ error: Error?) -> Void ) {
    
    var songList: [Song] = []
    AF.request(SongDataURL.instance.getAllSongJson()).responseJSON { (response) in
        guard response.error == nil else {
            completion(nil, response.error)
            return
        }
        
        guard let usersJson = response.value as? [String: Any] else { fatalError("Error while casting json") }
        usersJson.forEach({ (id, value) in
            guard let value = value as? [String: Any] else { fatalError("Error while casting json") }
            let eachSong = Song.init(JSON: value)
            eachSong?.id = id
            songList += [eachSong!]
        })
        completion(songList, nil)
    }
}

func fetchRelUserSong(completion: @escaping (_ relUserSong: [RelUserSong]?, _ error: Error?) -> () ) {
    
    var relUserSong: [RelUserSong] = []
    AF.request(RelUserSongDataURL.instance.getAllRelUserSongJson()).responseJSON { (response) in
        guard response.error == nil else {
            completion(nil, response.error)
            return
        }
        
        guard let usersJson = response.value as? [String: Any] else { fatalError("Error while casting json") }
        usersJson.forEach({ (id, value) in
            guard let value = value as? [String: Any] else { fatalError("Error while casting json") }
            let eachRelUserSong = RelUserSong.init(JSON: value)
            relUserSong += [eachRelUserSong!]
        })
        completion(relUserSong, nil)
    }
}

//func abcd(completion: @escaping (_ songList: [Song]?, _ error: Error?) -> Void ) {
//
//    AF.request(SongDataURL.instance.getAllSongJson()).responseJSON { (response) in
//        guard response.error == nil else {
//            completion(nil, response.error)
//            return
//        }
//        guard let data = response.value as? [[ String: Any ]] else { fatalError("Error while casting json") }
//        var songList: [Song] = []
//        data.forEach({ (value) in
//            guard let song = Song.init(JSON: value) else { fatalError("Error while casting json") }
//            songList += [song]
//        })
//        completion(songList, nil)
//    }
//}
