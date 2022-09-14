//
//  ExtensionUIView.swift
//  Dotify
//
//  Created by An Nguyen Thanh on 7/22/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setSubTopView() {
        self.backgroundColor = .white
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 5.0
    }
    
    func shake(count : Float? = nil, duration : TimeInterval = 0.1, translation : Float? = nil, autoReverses : Bool = true) {
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        animation.repeatCount = count ?? 1
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = autoReverses
        animation.byValue = translation ?? -5
        layer.add(animation, forKey: "shake")
    }

    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2.0)
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate as? CAAnimationDelegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
    
    func pulsate(duration: TimeInterval? = nil, autoReverses: Bool = false , repeatCount: Float = 1 ) {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = duration ?? 0.2
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = autoReverses
        pulse.repeatCount = repeatCount
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: "pulse")
    }
    
    func flash(duration: TimeInterval? = nil, autoReverses: Bool = true, repeatCount: Float = 1) {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = duration ?? 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = autoReverses
        flash.repeatCount = repeatCount
        
        layer.add(flash, forKey: nil)
    }
    
    
    func shake2(count : Float? = nil,duration : TimeInterval? = nil) {
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = duration ?? 0.1
        shake.repeatCount = count ?? 1
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
}

@IBDesignable class ShadowView: UIView {
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGPoint {
        get {
            return CGPoint(x: layer.shadowOffset.width, y:layer.shadowOffset.height)
        }
        set {
            layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
        }
        
    }
    
    @IBInspectable var shadowBlur: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue / 2.0
        }
    }
    
    @IBInspectable var shadowSpread: CGFloat = 0 {
        didSet {
            if shadowSpread == 0 {
                layer.shadowPath = nil
            } else {
                let dx = -shadowSpread
                let rect = bounds.insetBy(dx: dx, dy: dx)
                layer.shadowPath = UIBezierPath(rect: rect).cgPath
            }
        }
    }
}
