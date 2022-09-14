//
//  RelUserAlbum.swift
//  Dotify
//
//  Created by An Nguyen Thanh on 7/17/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import Foundation
import ObjectMapper

class RelUserAlbum: Mappable {
    //MARK: Attribute
    var userId: String?
    var albumId: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        userId    <- map["user_id"]
        albumId    <- map["album_id"]
    }
}
