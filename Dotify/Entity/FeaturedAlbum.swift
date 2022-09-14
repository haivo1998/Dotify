//
//  FeaturedAlbum.swift
//  Dotify
//
//  Created by user on 7/17/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import Foundation
import UIKit
class featuredAlbums{
    var id: String?
    var title: String?
    var artist: String?
    var songCount: String?
    var imageUrl: String? = "0"
    init(id: String?, title: String?, artist: String?, songCount: String?, imageUrl: String?) {
        self.id = id
        self.title = title
        self.artist = artist
        self.songCount = songCount
        self.imageUrl = imageUrl
    }
}
