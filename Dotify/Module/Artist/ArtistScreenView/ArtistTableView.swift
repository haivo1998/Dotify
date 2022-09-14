//
//  ArtistTableView.swift
//  Dotify
//
//  Created by An Nguyen Thanh on 7/14/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import UIKit

class ArtistTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    //
    // MARK: - Variables & Properties
    //
    var artistVC: ArtistScreen?
    let sections = ["LATEST RELEASE", "POPUPAR"]
    let POPULAR_SONG_CELL = "PopularSongCell"
    lazy var latestReleaseAlbums:[Album] = []
    lazy var popularSongs: [Song] = []
    //
    // MARK: - Table View
    //
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: CGRect.zero, style: .grouped)
        
        self.delegate = self
        self.dataSource = self
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(hex: Constants.CLOUDS_COLOR)
        
        self.register(LatestReleaseCell.self, forCellReuseIdentifier: "LatestReleaseCell")
        let cellNibFile = UINib(nibName: POPULAR_SONG_CELL, bundle: nil)
        self.register(cellNibFile, forCellReuseIdentifier: POPULAR_SONG_CELL)
    }
    
    func toggleHeaderView() {
        self.tableHeaderView?.removeFromSuperview()
        self.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        self.layoutIfNeeded()
    }
    
    func toggleFooterView() {
        self.tableFooterView?.removeFromSuperview()
        self.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 40.0))
        self.layoutIfNeeded()
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 { return popularSongs.count }
        return latestReleaseAlbums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LatestReleaseCell", for: indexPath) as? LatestReleaseCell else {
                return UITableViewCell()
            }
            //Load data
            cell.eachItem = self.latestReleaseAlbums[indexPath.item]
            return cell
        }
        else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: POPULAR_SONG_CELL, for: indexPath) as? PopularSongCell else {
                return UITableViewCell()
            }
            cell.delegate = artistVC
            //Set numberical order
                    cell.numbericalOrderLabel.text = "\(indexPath.row + 1)"
            //Load data
                    cell.eachSongInArtist = self.popularSongs[indexPath.item]
            //add button tap
            //        cell.accessoryButton.addTarget(self, action: #selector(self.oneTapped(_:)), for: .touchUpInside)
            
            return cell
        }
        else { return UITableViewCell() }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let currentAlbumId = self.latestReleaseAlbums[indexPath.item].id else { return }
            let albumVC = AlbumScreen()
            albumVC.currentAlbumId = currentAlbumId
            albumVC.parentVC = artistVC?.parentVC
        artistVC?.navigationController?.pushViewController(albumVC, animated: true)
        }
        else if indexPath.section == 1 {
            //create list song ID
            var listID: [String] = []
            popularSongs.forEach { (song) in
                listID += [song.id!]
            }
            artistVC?.parentVC?.didTapMusic(listID: listID, index: indexPath.row)
            artistVC?.setPlayButton(isPlaying: false)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

