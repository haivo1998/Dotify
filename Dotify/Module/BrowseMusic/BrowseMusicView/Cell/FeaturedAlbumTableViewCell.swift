//
//  FeaturedAlbumTableViewCell.swift
//  Dotify
//
//  Created by user on 7/17/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import UIKit
import SDWebImage

class FeaturedAlbumTableViewCell: UITableViewCell {
    
    @IBOutlet weak var featuredAlbumImage: UIImageView!
    
    @IBOutlet weak var featuredAlbumTitle: UILabel!
    @IBOutlet weak var featuredAlbumArtist: UILabel!
    @IBOutlet weak var featuredAlbumSongCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
