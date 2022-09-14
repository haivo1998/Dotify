//
//  FavoriteMusicScreenTableView.swift
//  Dotify
//
//  Created by An Nguyen Thanh on 7/10/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import UIKit

class FavoriteMusicScreenTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    //
    // MARK: - Constants
    //
    let identifier = "FavoriteMusicScreenCell"
    //
    // MARK: - Variables & Properties
    //
    var yourMusicScreenVC: YourMusicScreen?
    lazy var currentFavSongs: [Song] = []
    lazy var currentFavAlbums: [Album] = []
    lazy var currentFavArtists: [Artist] = []
    lazy var currentFavPlaylists: [Playlist] = []
    lazy var pressedTopViewState: PressedViewEnum = .ARTISTS
    lazy var currentFavAlbumId: String = "0"
    //
    // MARK: - Table View
    //
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: CGRect.zero, style: .grouped)
        
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor(hex: Constants.CLOUDS_COLOR)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.register(FavoriteMusicScreenTableViewCell.self, forCellReuseIdentifier: self.identifier)
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
        if pressedTopViewState == .ARTISTS {
            return currentFavArtists.count
        }
        else if pressedTopViewState == .ALBUMS {
            return currentFavAlbums.count
        }
        else if pressedTopViewState == .SONGS {
            return currentFavSongs.count
        }
        else if pressedTopViewState == .PLAYLISTS {
            return currentFavPlaylists.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath) as? FavoriteMusicScreenTableViewCell else { return UITableViewCell() }
        //set data
        if pressedTopViewState == .ARTISTS {
            cell.eachArtist = currentFavArtists[indexPath.item]
            cell.setPlay(isSelectedPlaying: false)
        }
        else if pressedTopViewState == .ALBUMS {
            cell.eachAlbum = currentFavAlbums[indexPath.item]
            cell.setPlay(isSelectedPlaying: false)
        }
        else if pressedTopViewState == .SONGS {
            cell.eachSong = currentFavSongs[indexPath.item]
            cell.setPlay(isSelectedPlaying: false)
        }
        else if pressedTopViewState == .PLAYLISTS {
            cell.eachPlaylist = currentFavPlaylists[indexPath.item]
            cell.setPlay(isSelectedPlaying: false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //set data
        if pressedTopViewState == .ARTISTS {
            let cell = tableView.cellForRow(at: indexPath) as? FavoriteMusicScreenTableViewCell
            cell?.setPlay(isSelectedPlaying: false)
            
            guard let currentFavArtistId = currentFavArtists[indexPath.row].id else { return }
            let artistVC = ArtistScreen()
            artistVC.currentArtistId = currentFavArtistId
            artistVC.parentVC = yourMusicScreenVC?.parentVC
            yourMusicScreenVC?.navigationController?.pushViewController(artistVC, animated: true)
        }
            
        else if pressedTopViewState == .ALBUMS {
            let cell = tableView.cellForRow(at: indexPath) as? FavoriteMusicScreenTableViewCell
            cell?.setPlay(isSelectedPlaying: false)
            
            guard let currentFavAlbumId = currentFavAlbums[indexPath.row].id else { return }
            let albumVC = AlbumScreen()
            albumVC.currentAlbumId = currentFavAlbumId
            albumVC.parentVC = yourMusicScreenVC?.parentVC
            yourMusicScreenVC?.navigationController?.pushViewController(albumVC, animated: true)
        }
            
        else if pressedTopViewState == .SONGS {
            let cell = tableView.cellForRow(at: indexPath) as? FavoriteMusicScreenTableViewCell
            cell?.setPlay(isSelectedPlaying: !currentFavSongs[indexPath.row].isSelectedPlaying)
            
            //create list song ID
            var listID: [String] = []
            currentFavSongs.forEach { (song) in
                listID += [song.id!]
            }
            yourMusicScreenVC?.parentVC?.didTapMusic(listID: listID, index: indexPath.row)
        }
            
        else if pressedTopViewState == .PLAYLISTS {
            let cell = tableView.cellForRow(at: indexPath) as? FavoriteMusicScreenTableViewCell
            cell?.setPlay(isSelectedPlaying: false)
            let playlistVC = PlaylistDetailRouter.createModule()
            playlistVC.playlistID = currentFavPlaylists[indexPath.row].id!
            playlistVC.parentVC = yourMusicScreenVC?.parentVC
            yourMusicScreenVC?.navigationController?.pushViewController(playlistVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if pressedTopViewState == .ARTISTS {
            let cell = tableView.cellForRow(at: indexPath) as? FavoriteMusicScreenTableViewCell
            cell?.setPlay(isSelectedPlaying: false)
        }
        else if pressedTopViewState == .ALBUMS {
            let cell = tableView.cellForRow(at: indexPath) as? FavoriteMusicScreenTableViewCell
            cell?.setPlay(isSelectedPlaying: false)
        }
        else if pressedTopViewState == .SONGS {
            let cell = tableView.cellForRow(at: indexPath) as? FavoriteMusicScreenTableViewCell
            cell?.setPlay(isSelectedPlaying: currentFavSongs[indexPath.row].isSelectedPlaying)
        }
        else if pressedTopViewState == .PLAYLISTS {
            let cell = tableView.cellForRow(at: indexPath) as? FavoriteMusicScreenTableViewCell
            cell?.setPlay(isSelectedPlaying: false)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
