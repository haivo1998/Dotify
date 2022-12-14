//
//  SongCommentInteractor.swift
//  Dotify
//
//  Created Pham Thanh Phat on 7/28/19.
//  Copyright © 2019 Vinova. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import Alamofire

class SongCommentInteractor: SongCommentInteractorProtocol {

    weak var presenter: SongCommentPresenterProtocol?
    
    func loadComments(of songId: String, _ completion: @escaping ([Comment], Error?) -> Void){
        CommentFirebase.instance.loadComments(of: songId) { (comments, error) in
            completion(comments, error)
        }
    }
    func addComment(userId: String, songId: String, content: String, _ completion: @escaping (Error?)-> Void){
        CommentFirebase.instance.addComment(userId: userId, songId: songId, content: content) { (error, ref) in
            completion(error)
        }
    }
    func loadUser(with id: String, _ completion: @escaping (User?, Error?) -> Void) {
        AF.request(UserDataURL.instance.getUserJson(id: id)).responseJSON { (response) in
            guard response.error == nil else { completion(nil, response.error); return }
            guard let userDict = response.value as? [String: Any] else { completion(nil, nil); return }
            let user = User.init(JSON: userDict)
            user?.id = id
            completion(user, nil)
        }
    }
}
