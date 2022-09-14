//
//  PlaylistInteractor.swift
//  Dotify
//
//  Created by An Nguyen Thanh on 7/25/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import UIKit
import Alamofire
import os.log

class PlaylistInteractor {
    static let ins = PlaylistInteractor()
    
    func fetchPlaylistList(completion: @escaping (_ playlistList: [Playlist]?, _ error: Error?) -> Void ) {
        
        var playlistList: [Playlist] = []
        AF.request(PlaylistDataURL.instance.getAllPlaylistJson()).responseJSON { (response) in
            guard response.error == nil else {
                completion(nil, response.error)
                return
            }
            
            guard let usersJson = response.value as? [String: Any] else {
                os_log("Error while casting json fetchPlaylistList", log: OSLog.default, type: .error)
                return
            }
            usersJson.forEach({ (id, value) in
                guard let value = value as? [String: Any] else {
                    os_log("Error while casting json fetchPlaylistList", log: OSLog.default, type: .error)
                    return
                }
                let eachPlaylist = Playlist.init(JSON: value)
                eachPlaylist?.id = id
                playlistList += [eachPlaylist!]
            })
            completion(playlistList, nil)
        }
    }
}
