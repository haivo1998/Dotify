//
//  HamburgerView.swift
//  Dotify
//
//  Created by Lucas Pham on 7/18/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import UIKit

class HamburgerView: BaseViewXib {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var browseLabel: UIView!
    @IBOutlet weak var yourMusicLabel: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var user: User? {
        didSet {
            nameLabel.text = self.user?.username ?? ""
            if let url = user?.imageUrl {
                
                profileImageView.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "username"))
            }
        }
    }
    
    var delegate: HamburgerViewDelegate?
    override func setUpViews() {
        let browseTapGes = UITapGestureRecognizer(target: self, action: #selector(didTapBrowse))
        browseLabel.addGestureRecognizer(browseTapGes)
        
        let yourMusicTapGes = UITapGestureRecognizer(target: self, action: #selector(didTapYourMusic))
        yourMusicLabel.addGestureRecognizer(yourMusicTapGes)
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }
    @IBAction func didTapLogOut(_ sender: Any) {
        delegate?.tapLogOut()
    }
    
    @objc func didTapYourMusic(){
        delegate?.tapYourMusic()
    }
    @objc func didTapBrowse(){
        delegate?.tapBrowse()
    }
}
protocol HamburgerViewDelegate {
    func tapYourMusic()
    func tapBrowse()
    func tapLogOut()
}
