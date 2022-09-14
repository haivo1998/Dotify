//
//  Music
//  FavoriteMusicScreenTableViewCell.swift
//  Dotify
//
//  Created by An Nguyen Thanh on 7/10/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import UIKit
import SDWebImage

class FavoriteMusicScreenTableViewCell: UITableViewCell {
    //
    // MARK: - Variables & Properties
    //
    let topLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Name's song "
        label.font = UIFont (name: Constants.AVENIR_NEXT_FONT, size: 13)
        return label
    }()
    
    let bottomLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Name's artist"
        label.font = UIFont (name: Constants.AVENIR_NEXT_FONT, size: 10)
        return label
    }()
    
    let imageSize: CGFloat = 42
    lazy var cellImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .white
        return image
    }()
    
    var eachSong: Song? {
        didSet {
            guard let eachSong = eachSong else { return }
            
            topLabel.text = eachSong.name
            bottomLabel.text = "\(String(eachSong.artistName ?? ""))"
            
            guard let imageUrlString = eachSong.imageUrl else { return }
            cellImage.sd_setImage(with: URL(string: imageUrlString), completed: nil)
        }
    }
    
    var eachArtist: Artist? {
        didSet {
            guard let eachArtist = eachArtist else { return }
            topLabel.text = eachArtist.name
            bottomLabel.text = "0 lượt thích"
            
            guard let imageUrlString = eachArtist.imageUrl else { return }
            cellImage.sd_setImage(with: URL(string: imageUrlString), completed: nil)
        }
    }
    
    var eachAlbum: Album? {
        didSet {
            guard let eachAlbum = eachAlbum else { return }
            topLabel.text = eachAlbum.name
            bottomLabel.text = "0 lượt thích"
            
            guard let imageUrlString = eachAlbum.imageUrl else { return }
            cellImage.sd_setImage(with: URL(string: imageUrlString), completed: nil)
        }
    }
    
    var eachPlaylist : Playlist? {
        didSet {
            guard let eachPlaylist = eachPlaylist else { return }
            topLabel.text = eachPlaylist.name
            //process bottom label
            let OwnerOfPlaylist = eachPlaylist.ownerOfPlaylist ?? "Unknown"
            let dateString = eachPlaylist.dateCreatedString ?? ""
            let index = dateString.firstIndex(of: " ") ?? dateString.endIndex
            let beginning = dateString[..<index]
            let newDateString = String(beginning)
// ==
//            var dateString = eachPlaylist.dateCreatedString ?? ""
//            let range = dateString.index(dateString.endIndex, offsetBy: -9)..<dateString.endIndex
//            dateString.removeSubrange(range)
//
            let str = "Created by \(OwnerOfPlaylist) \u{2022} \(newDateString) "
            let myMutableString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font : UIFont(name: Constants.AVENIR_NEXT_FONT, size: 10.0)!])
            myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 11), range: NSRange(location:11, length:OwnerOfPlaylist.count))
            //set color
//            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location:11, length:eachPlaylistOwnerOfPlaylist.count))
            bottomLabel.attributedText = myMutableString
            //--
            guard let imageUrlString = eachPlaylist.imageUrl else { return }
            cellImage.sd_setImage(with: URL(string: imageUrlString), completed: nil)
        }
    }
    //
    // MARK: - Table View Cell
    //
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "FavoriteMusicScreenCell")
        setupTableViewCell()
    }
    
    private func setupTableViewCell() {
        contentView.backgroundColor = UIColor(hex: Constants.CLOUDS_COLOR)
        contentView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.accessoryType = .disclosureIndicator
        self.contentView.superview?.backgroundColor = .clear
        self.selectionStyle = .none

        contentView.addSubview(cellImage)
        cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        cellImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        cellImage.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        cellImage.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        cellImage.contentMode = .scaleAspectFill
        cellImage.layer.masksToBounds = true

        contentView.addSubview(topLabel)
        topLabel.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: 12).isActive = true
        topLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        topLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        topLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        contentView.addSubview(bottomLabel)
        bottomLabel.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: 12).isActive = true
        bottomLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35).isActive = true
        bottomLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        bottomLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPlay(isSelectedPlaying: Bool){
        self.topLabel.textColor = UIColor(hex: isSelectedPlaying ? Constants.ORANGE_COLOR : Constants.DEFAULT_DARK_COLOR)
        self.bottomLabel.textColor = UIColor(hex: isSelectedPlaying ? Constants.ORANGE_COLOR : Constants.DEFAULT_DARK_COLOR)
    }
}
