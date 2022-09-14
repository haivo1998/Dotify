//
//  RelUserPlaylist.swift
//  Dotify
//
//  Created by An Nguyen Thanh on 7/19/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import Foundation
import ObjectMapper
import FirebaseDatabase

class RelUserPlaylist: Mappable {
    //MARK: Attribute
    var playlistId: String?
    var userId: String?
    var dateStr: String?
    init() {}
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        playlistId       <- map["playlist_id"]
        userId           <- map["user_id"]
        dateStr         <- map["date"]
    }
}
