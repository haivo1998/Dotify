//
//  CommentCell.swift
//  Dotify
//
//  Created by Pham Thanh Phat on 7/28/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import UIKit
import SDWebImage

class CommentCell: UITableViewCell {

    //MARK: Outlet
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentCoverView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpView(comment: Comment){
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        if let url = comment.user?.imageUrl {
//            profileImageView.sd_setImage(with: URL(string: url))
            profileImageView.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "username"))
        }
        usernameLabel.text = comment.user?.username
        commentLabel.text = comment.content
        commentCoverView.layer.cornerRadius = 5
        let date = convertStrToDate(comment.dateStr!)
        dateLabel.text = convertDateToStr(date!, dateFormat: "hh:mm MM/dd/yy")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        selectionStyle = .none
    }
    
}
