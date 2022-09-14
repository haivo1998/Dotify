//
//  AlbumInteractor.swift
//  Dotify
//
//  Created by An Nguyen Thanh on 7/17/19.
//  Copyright © 2019 Vinova. All rights reserved.
//
import UIKit
import Alamofire
import os.log

class AlbumInteractor {
    static let ins = AlbumInteractor()
    
    func fetchAlbum(id: String, completion: @escaping (Album, Error?) -> Void) {
        var currentAlbum: Album?
        
        AF.request(AlbumDataURL.instance.getAlbumJson(id: id)).responseJSON { (response) in
            guard response.error == nil else { return }
            guard let data = response.value as? [ String: Any ] else {
                os_log("Error while casting json fetchAlbum with id", log: OSLog.default, type: .error)
                return
            }
            currentAlbum = Album.init(JSON: data)
            currentAlbum?.id = id
            completion(currentAlbum!, nil)
        }
    }
    
    func fetchAlbumList(completion: @escaping (_ albumList: [Album]?, _ error: Error?) -> Void ) {
        var albumList: [Album] = []
        AF.request(AlbumDataURL.instance.getAllAlbumJson()).responseJSON { (response) in
            guard response.error == nil else {
                completion(nil, response.error)
                return
            }
            
            guard let usersJson = response.value as? [String: Any] else {
                os_log("Error while casting json fetchAlbumList", log: OSLog.default, type: .error)
                return
            }
            usersJson.forEach({ (id, value) in
                guard let value = value as? [String: Any] else {
                    os_log("Error while casting json fetchAlbumList", log: OSLog.default, type: .error)
                    return
                }
                let eachAlbum = Album.init(JSON: value)
                eachAlbum?.id = id
                albumList += [eachAlbum!]
            })
            completion(albumList, nil)
        }
    }
}


