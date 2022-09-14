//
//  Song.swift
//  Dotify
//
//  Created by Lucas Pham on 7/10/19.
//  Copyright © 2019 Vinova. All rights reserved.
//
import ObjectMapper
import Foundation

class Song: Mappable {
    //MARK: Attribute
    var id: String?
    var name: String?
    var fileName: String?
    var imageUrl: String?
    var idArtist: String?
    var artistName: String?
    var albumId: String?
    var artist: Artist?
    var link: String?
    var isSelectedPlaying: Bool = false

    
    init(){}
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name        <- map["name"]
        fileName    <- map["filename"]
        imageUrl    <- map["imageUrl"]
        idArtist    <- map["artist_id"]
        albumId     <- map["album_id"]
    }
}
