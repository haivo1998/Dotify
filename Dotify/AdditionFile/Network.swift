//
//  Network.swift
//  Dotify
//
//  Created by Lucas Pham on 7/12/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import Foundation
import Alamofire

struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}
