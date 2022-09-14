//
//  AlbumTableView.swift
//  Dotify
//
//  Created by An Nguyen Thanh on 7/12/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import UIKit

class AlbumTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    //
    // MARK: - Variables & Properties
    //
    lazy var songInCurrentAlbum: [Song] = []
    var albumScreenVC: AlbumScreen?
    let ALBUM_CELL = "AlbumCell"
    //
    // MARK: - Table View
    //
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: CGRect.zero, style: .grouped)
        
        self.delegate = self
        self.dataSource = self
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(hex: Constants.CLOUDS_COLOR)
        let cellNibFile = UINib(nibName: ALBUM_CELL, bundle: nil)
        self.register(cellNibFile, forCellReuseIdentifier: ALBUM_CELL)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songInCurrentAlbum.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ALBUM_CELL, for: indexPath) as? AlbumCell else { return UITableViewCell() }
        cell.delegate = albumScreenVC
        //Set numberical order
        cell.numbericalOrderLabel.text = "\(indexPath.row + 1)"
        //Set data
        cell.eachSongInAlbum = songInCurrentAlbum[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //create list song ID
        var listID: [String] = []
        songInCurrentAlbum.forEach { (song) in
            listID += [song.id!]
        }
        albumScreenVC?.parentVC?.didTapMusic(listID: listID, index: indexPath.row)
        albumScreenVC?.isPlayingState = true
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Track list"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
