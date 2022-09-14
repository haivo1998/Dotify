//
//  LogInInteractor.swift
//  Dotify
//
//  Created Lucas Pham on 7/12/19.
//  Copyright © 2019 Vinova. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import Alamofire

class LogInInteractor: LogInInteractorProtocol {
    

    weak var presenter: LogInPresenterProtocol?
    func loadAllUser(completion: @escaping (_ users: [User]?, _ error: Error?) -> () ) {
        var users: [User] = []
        AF.request(UserDataURL.instance.getAllUserJson()).responseJSON { (response) in
            guard response.error == nil else {
                completion(nil, response.error)
                return
            }
            
            guard let usersJson = response.value as? [String: Any] else { fatalError("Error while casting json") }
            usersJson.forEach({ (id, value) in
                guard let value = value as? [String: Any] else { fatalError("Error while casting json") }
                let user = User.init(JSON: value)
                user?.id = id
                users += [user!]
            })
            completion(users, nil)
        }
    }
    func writeIdToLocal(user: User) -> Bool {
        let curId = UserDefaults.standard.string(forKey: "user_id") ?? ""
        let curUserObj = UserDefaults.standard.string(forKey: "user") ?? ""
        if !curId.isEmpty || !curUserObj.isEmpty { return false }
        
        UserDefaults.standard.set(user.id ?? "-1", forKey: "user_id")
        do {
            var str = try JSONEncoder().encode(user)
            UserDefaults.standard.set(str, forKey: "user")
        } catch {
            print(error.localizedDescription)
        }
        return true
    }
}
