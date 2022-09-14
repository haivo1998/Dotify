//
//  PlayListCell.swift
//  Dotify
//
//  Created by Lucas Pham on 7/19/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import UIKit

class PlayListCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var markImageView: UIImageView!
    
    var isCheck = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .gray
        // Initialization code
    }
    
    func configure(title: String, isAdded: Bool) {
        self.titleLabel.text = title
        isCheck = isAdded
        markImageView.image = isAdded ? #imageLiteral(resourceName: "checked") : nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
