//
//  Album.swift
//  Dotify
//
//  Created by An Nguyen Thanh on 7/17/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import Foundation
import ObjectMapper

class Album: Mappable {
    //MARK: Attribute
    var id: String?
    var name: String?
    var imageUrl: String?
    var artistId: String?
    lazy var songCount: Int = 0
    var releaseDate: Date? {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
            guard let releaseDayString = releaseDayString else { return nil }
            return dateFormatter.date(from: releaseDayString)
        }
    }
    var releaseDayString: String?

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name        <- map["name"]
        imageUrl    <- map["imageUrl"]
        artistId    <- map["artist_id"]
        releaseDayString <- map["release_date"]
    }
}
