//
//  GenresMood.swift
//  Dotify
//
//  Created by user on 7/19/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import Foundation
class genresMoods {
    var id: String?
    var name: String?
    var labelUrl: String?
    var imageUrl: String?
    init(id: String?, name: String?, labelUrl: String?, imageUrl: String?) {
        self.id = id
        self.name = name
        self.labelUrl = labelUrl
        self.imageUrl = imageUrl
    }
}
