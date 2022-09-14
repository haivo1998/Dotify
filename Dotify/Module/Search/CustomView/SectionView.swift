//
//  SectionView.swift
//  Dotify
//
//  Created by Lucas Pham on 7/24/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import UIKit

class SectionView: BaseViewXib {

    @IBOutlet weak var titleLabel: UILabel!
    
    func setTitle(_ title: String?){
        titleLabel.text = title ?? ""
    }

}
