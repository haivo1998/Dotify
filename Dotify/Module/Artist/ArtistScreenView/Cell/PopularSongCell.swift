//
//  PopularSongCell.swift
//  Dotify
//
//  Created by An Nguyen Thanh on 7/19/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import UIKit

class PopularSongCell: UITableViewCell {
    //
    // MARK: - Outlets
    //
    @IBOutlet weak var nameOfSongLabel: UILabel!
    @IBOutlet weak var numbericalOrderLabel: UILabel!
    @IBOutlet weak var totalNumberOfListening: UILabel!
    //
    // MARK: - Variables & Properties
    //
    var delegate: ArtistCellDelegate?
    var eachSongInArtist: Song? {
        didSet {
            nameOfSongLabel.text = eachSongInArtist?.name
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
        delegate?.showAlert(eachSongInPopular: eachSongInArtist!)
    }
}

protocol ArtistCellDelegate {
    func showAlert(eachSongInPopular: Song)
}
