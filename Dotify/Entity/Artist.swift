//
//  Artist.swift
//  Dotify
//
//  Created by Lucas Pham on 7/10/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import Foundation
import ObjectMapper

class Artist: Mappable {
    //MARK: Attribute
    var id: String?
    var name: String?
    var imageUrl: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name        <- map["name"]
        imageUrl    <- map["imageUrl"]
    }
    
    
}
