//
//  SearchResultCell.swift
//  Dotify
//
//  Created by Lucas Pham on 7/24/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpView(title: String?, imageUrl: String?){
        thumbImageView.layer.cornerRadius = 5
        titleLabel.text = title ?? "#NOTAVAILABLE"
        if imageUrl != nil {
            thumbImageView.sd_setImage(with: URL(string: imageUrl!))
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
