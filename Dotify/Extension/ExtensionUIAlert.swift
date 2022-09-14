//
//  ExtensionUIAlert.swift
//  Dotify
//
//  Created by An Nguyen Thanh on 7/29/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    func setTitle(font: UIFont, color: UIColor) {
        guard let title = self.title else { return }
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        let attributedTitle = NSMutableAttributedString(string: title, attributes: attributes)
        setValue(attributedTitle, forKey: "attributedTitle")
    }
}
