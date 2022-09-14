//
//  LatestReleaseCell.swift
//  Dotify
//
//  Created by An Nguyen Thanh on 7/17/19.
//  Copyright © 2019 Vinova. All rights reserved.
//
import UIKit
import SDWebImage

class LatestReleaseCell: UITableViewCell {
    //
    // MARK: - Variables & Properties
    //
    let nameOfAlbumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Name's song "
        label.font = UIFont (name: Constants.AVENIR_NEXT_FONT, size: 13)
        return label
    }()
    
    let latestReleaseAlbumInfo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Album info"
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
    
    var eachItem: Album? {
        didSet {
            guard let eachItem = eachItem else { return }
            nameOfAlbumLabel.text = eachItem.name
            
            let dateString = eachItem.releaseDayString ?? ""
            let index = dateString.firstIndex(of: " ") ?? dateString.endIndex
            let beginning = dateString[..<index]
            let newDateString = String(beginning)
            let myMutableString = "\(eachItem.songCount) songs \u{2022} Release in \(newDateString)"
            latestReleaseAlbumInfo.text = myMutableString
            
            guard let imageUrlString = eachItem.imageUrl else { return }
            cellImage.sd_setImage(with: URL(string: imageUrlString), completed: nil)
        }
    }
    //
    // MARK: - Table View Cell
    //
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "LatestReleaseCell")
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
        cellImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        cellImage.contentMode = .scaleAspectFill
        cellImage.layer.masksToBounds = true

        cellImage.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        cellImage.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        
        contentView.addSubview(nameOfAlbumLabel)
        nameOfAlbumLabel.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: 12).isActive = true
        nameOfAlbumLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        nameOfAlbumLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        nameOfAlbumLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        contentView.addSubview(latestReleaseAlbumInfo)
        latestReleaseAlbumInfo.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: 12).isActive = true
        latestReleaseAlbumInfo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 34).isActive = true
        latestReleaseAlbumInfo.heightAnchor.constraint(equalToConstant: 14).isActive = true
        latestReleaseAlbumInfo.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
