//
//  ExtensionArray.swift
//  Dotify
//
//  Created by Lucas Pham on 7/24/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
