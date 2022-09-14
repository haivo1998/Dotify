//
//  BaseViewXib.swift
//  MakeView
//
//  Created by Pham Lucas on 6/28/19.
//  Copyright © 2019 Pham Lucas. All rights reserved.
//

import Foundation
import UIKit

class BaseViewXib: UIView {
    
    var view : UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        let nibName = String(describing: type(of: self))
        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        view?.frame = bounds
        addSubview(view ?? UIView())
        view?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setUpViews()
    }
    
    func setUpViews() {
        
    }
}
