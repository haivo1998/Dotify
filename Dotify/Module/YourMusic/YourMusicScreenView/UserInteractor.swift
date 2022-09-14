//
//  UserInteractor.swift
//  Dotify
//
//  Created by An Nguyen Thanh on 7/25/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import UIKit
import Alamofire
import os.log

class UserInteractor {
    static let ins = UserInteractor()
    
    func fetchAllUser(completion: @escaping (_ users: [User]?, _ error: Error?) -> () ) {
        var users: [User] = []
        AF.request(UserDataURL.instance.getAllUserJson()).responseJSON { (response) in
            guard response.error == nil else {
                completion(nil, response.error)
                return
            }
            
            guard let usersJson = response.value as? [String: Any] else  {
                os_log("Error while casting json loadAllUser", log: OSLog.default, type: .error)
                return
            }
            usersJson.forEach({ (id, value) in
                guard let value = value as? [String: Any] else  {
                    os_log("Error while casting json loadAllUser", log: OSLog.default, type: .error)
                    return
                }
                let user = User.init(JSON: value)
                user?.id = id
                users += [user!]
            })
            completion(users, nil)
        }
    }
}
