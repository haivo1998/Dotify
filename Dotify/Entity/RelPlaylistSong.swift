//
//  RelPlaylistSong.swift
//  Dotify
//
//  Created by An Nguyen Thanh on 7/19/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import Foundation
import ObjectMapper

class RelPlaylistSong: Mappable {
    //MARK: Attribute
    var playlistId: String?
    var song: Song?
    var songId: String?
    var dateAdded: Date? {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
            guard let dateAddedString = dateAddedString else { return nil }
            return dateFormatter.date(from: dateAddedString)
        }
    }
    var dateAddedString: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        playlistId       <- map["playlist_id"]
        songId           <- map["song_id"]
        dateAddedString  <- map["date_add"]
    }
}
