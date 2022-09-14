//
//  ExtensionUIImage.swift
//  Dotify
//
//  Created by Lucas Pham on 7/12/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func scaleToSize(newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return newImage
    }
}
extension UIImageView {
    //for xib file
    func setRounded() {
        self.layer.masksToBounds = false
        //        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
    
    func setRoundedWithBorder(borderCGColor : CGColor) {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = borderCGColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
}
