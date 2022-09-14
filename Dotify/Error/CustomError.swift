//
//  CustomError.swift
//  Dotify
//
//  Created by Lucas Pham on 7/15/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import Foundation

class SignUpError: Error {
    static let invalidEmail = "Invalid email format"
    static let invalidUsername = "Invalid username format"
    static let usernameHasTaken = "Username is taken"
    static let emailHasTaken = "Username is taken"
}
enum LogInError: String, Error {
    case EXIST_USER, WRONG_INPUT, LOAD_DATA_FAIL
}
