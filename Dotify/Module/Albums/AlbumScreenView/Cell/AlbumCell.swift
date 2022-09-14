//
//  AlbumCell.swift
//  Dotify
//
//  Created by An Nguyen Thanh on 7/19/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {
    //
    // MARK: - Outlets
    //
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var numbericalOrderLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    //
    // MARK: - Variables & Properties
    //
    var delegate: AlbumCellDelegate?
    var eachSongInAlbum: Song? {
        didSet {
            topLabel.text = eachSongInAlbum?.name
            bottomLabel.text = "0 lượt nghe"
        }
    }
    //
    // MARK: - Cell
    //
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func moreInfoButton(_ sender: Any) {
        delegate?.showAlert(eachSongInAlbum: eachSongInAlbum!)
    }
}

protocol AlbumCellDelegate {
    func showAlert(eachSongInAlbum: Song)
}
