//
//  RelUserSong.swift
//  Dotify
//
//  Created by An Nguyen Thanh on 7/16/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import Foundation
import ObjectMapper

class RelUserSong: Mappable {
    //MARK: Attribute
    var userId: String?
    var songId: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        userId    <- map["user_id"]
        songId    <- map["song_id"]
    }
}
