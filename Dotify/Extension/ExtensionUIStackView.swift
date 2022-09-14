//  ExtensionUIStackView.swift
//  NoMain
//
//  Created by An Nguyen Thanh on 7/5/19.
//  Copyright © 2019 An Nguyen Thanh. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {
    func changeBackgroundColor (color: UIColor) {
        let backgroundLayer = CAShapeLayer()
        self.layer.insertSublayer(backgroundLayer, at: 0)
        backgroundLayer.path = UIBezierPath(rect: self.bounds).cgPath
        backgroundLayer.fillColor = color.cgColor
    }
}

extension UIStackView {
    func addBackgroundColor(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}




