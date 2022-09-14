//
//  User.swift
//  Dotify
//
//  Created by Pham Thanh Phat on 7/13/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import Foundation
import ObjectMapper
import FirebaseDatabase

class User: Mappable, Codable {
    var id: String?
    var username: String?
    var password: String? //Need to fix later
    var email : String?
    var imageUrl: String?
    var dateOfBirth: Date? {
        get {
            //Convert dobString to date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            return dateFormatter.date(from: self.dobString!)
        }
    }
    var isMale: Bool?
    
    private var dobString: String?
    
    init() {}
    required init?(map: Map) {
    }
    
    
    func mapping(map: Map) {
        username        <- map["username"]
        password        <- map["password"]
        email           <- map["email"]
        dobString       <- map["birthday"]
        isMale          <- map["male"]
        imageUrl        <- map["imageUrl"]
    }
}

class UserFirebase {
    static let instance = UserFirebase()
    var userRef: DatabaseReference {
        return Database.database().reference().child("users")
    }
    func addUser(user: User, completion: @escaping (_ error: Error?, _ ref: DatabaseReference) -> () ){
        userRef.childByAutoId().setValue(user.toJSON()) { (error, ref) in
            completion(error, ref)
        }
    }
    func findId(username: String, completion: @escaping (_ id: String) -> () ) {
        userRef.observe(.value) { (snapshot) in
            for childSnap in snapshot.children.allObjects {
                guard let childSnap = childSnap as? DataSnapshot else { return }
                let value = childSnap.value as? [String: Any]
                
                if value?["username"] as? String == username {
                    completion(childSnap.key)
                    break
                }
            }
        }
    }
}
