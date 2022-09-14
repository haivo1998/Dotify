//
//  PopularCell.swift
//  Dotify
//
//  Created by An Nguyen Thanh on 7/14/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import UIKit

class PopularCell: UITableViewCell {
    //
    // MARK: - Outlets
    //
    let numbericalOrderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.font = UIFont (name: Constants.AVENIR_NEXT_FONT, size: 15)
        return label
    }()
    
    let nameOfSongLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Name's song "
        label.font = UIFont (name: Constants.AVENIR_NEXT_FONT, size: 13)
        return label
    }()
    
    let totalNumberOfListening: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.font = UIFont (name: Constants.AVENIR_NEXT_FONT, size: 10)
        return label
    }()
    
    let accessoryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        return button
    }()
    //
    // MARK: - Variables & Properties
    //
    var eachSongInArtist: Song? {
        didSet {
            nameOfSongLabel.text = eachSongInArtist?.name
            
        }
    }
    //
    // MARK: - Table View Cell
    //
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "PopularCell")
        setupTableViewCell()
    }
    
    private func setupTableViewCell() {
        contentView.backgroundColor = UIColor(hex: Constants.CLOUDS_COLOR)
        self.contentView.superview?.backgroundColor = .clear
        self.selectionStyle = .default
        
        contentView.addSubview(numbericalOrderLabel)
        numbericalOrderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 9).isActive = true
        numbericalOrderLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        numbericalOrderLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        contentView.addSubview(nameOfSongLabel)
        nameOfSongLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 48).isActive = true
        nameOfSongLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        nameOfSongLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        nameOfSongLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        contentView.addSubview(totalNumberOfListening)
        totalNumberOfListening.leadingAnchor.constraint(equalTo: numbericalOrderLabel.trailingAnchor, constant: 9).isActive = true
        totalNumberOfListening.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32).isActive = true
        totalNumberOfListening.widthAnchor.constraint(equalToConstant: 200).isActive = true
        totalNumberOfListening.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        contentView.addSubview(accessoryButton)
        accessoryButton.leadingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        accessoryButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14).isActive = true
        accessoryButton.widthAnchor.constraint(equalToConstant: 22.5).isActive = true
        accessoryButton.heightAnchor.constraint(equalToConstant: 22.5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




