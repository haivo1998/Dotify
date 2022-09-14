//
//  Comment.swift
//  Dotify
//
//  Created by Pham Thanh Phat on 7/28/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import Foundation
import ObjectMapper
import FirebaseDatabase

class Comment: Mappable {
    var id: String?
    var dateStr: String?
    var content: String?
    var user: User?
    var song: Song?
    var songId: String?
    var userId: String?
    
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        userId      <- map["user_id"]
        songId      <- map["song_id"]
        dateStr     <- map["date"]
        content     <- map["content"]
    }
}

class CommentFirebase {
    static let instance = CommentFirebase()
    var commentRef: DatabaseReference {
        return Database.database().reference().child("songComment")
    }
    func loadComments(of songId: String, _ completion: @escaping ([Comment], Error?) -> Void ){
        commentRef.observe(.value) { (snapshot) in
            guard let commentsDict = snapshot.value as? [String : [String: Any]] else { return }
            var comments: [Comment] = []
            commentsDict.forEach({ (id, value) in
                let comment = Comment.init(JSON: value)
                if comment?.songId == songId {
                    comment?.id = id
                    comments += [comment!]
                }
            })
            completion(comments, nil)
        }
    }
    func addComment(userId: String, songId: String, content: String, _ completion: @escaping (Error?, DatabaseReference) -> Void ){
        let curDateStr = convertDateToStr(Date())
        let dataDict = ["content": content, "song_id": songId, "user_id": userId, "date": curDateStr]
        commentRef.childByAutoId().setValue(dataDict) { (error, ref) in
            completion(error, ref)
        }
    }
}
