//
//  ArtistInteractor.swift
//  Dotify
//
//  Created by An Nguyen Thanh on 7/17/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import UIKit
import Alamofire
import os.log

class ArtistInteractor {
    static let ins = ArtistInteractor()
    
    func fetchArtist(id: String, completion: @escaping (Artist, Error?) -> Void) {
        var currentArtist: Artist?
        
        AF.request(ArtistDataURL.instance.getArtistJson(id: id)).responseJSON { (response) in
            guard response.error == nil else { return }
            guard let data = response.value as? [ String: Any ] else {
                os_log("Error while casting json fetchArtist with id", log: OSLog.default, type: .error)
                return
            }
            
            currentArtist = Artist.init(JSON: data)
            currentArtist?.id = id
            completion(currentArtist!, nil)
        }
    }
    
    func fetchArtistList(completion: @escaping (_ artistList: [Artist]?, _ error: Error?) -> Void ) {
        var artistList: [Artist] = []
        
        AF.request(ArtistDataURL.instance.getAllArtistJson()).responseJSON { (response) in
            guard response.error == nil else {
                completion(nil, response.error)
                return
            }
            
            guard let usersJson = response.value as? [String: Any] else {
                os_log("Error while casting json fetchArtistList", log: OSLog.default, type: .error)
                return
            }
            usersJson.forEach({ (id, value) in
                guard let value = value as? [String: Any] else {
                    os_log("Error while casting json fetchArtistList", log: OSLog.default, type: .error)
                    return
                }
                let eachArtist = Artist.init(JSON: value)
                eachArtist?.id = id
                artistList += [eachArtist!]
            })
            completion(artistList, nil)
        }
    }

}



