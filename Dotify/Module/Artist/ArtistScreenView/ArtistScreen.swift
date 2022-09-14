//
//  ArtistScreen.swift
//  Dotify
//
//  Created by An Nguyen Thanh on 7/12/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import UIKit
import SDWebImage
import os.log

class ArtistScreen: UIViewController {
    //
    // MARK: - Outlets
    //
    //top View
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backgroundTopView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var artistView: UIView!
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var nameOfArtistLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    //middle View
    @IBOutlet weak var middleView: UIView!
    //
    // MARK: - Variables & Properties
    //
    let yourArtistScreenTableView = ArtistTableView()
    var parentVC: MiniPlayerViewController?
    var currentArtist: Artist?
    var latestReleaseAlbum: Album? //this is max
    lazy var latestReleaseAlbums:[Album] = []
    lazy var popularSongs: [Song] = []
    lazy var currentArtistId = "0"
    lazy var isPlayingState: Bool = false
    lazy var isFavArtist: Bool = false
    //
    // MARK: - View Controller
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        yourArtistScreenTableView.artistVC = self
        parentVC?.delegate = self
        DispatchQueue.main.async {
            self.view.backgroundColor = UIColor(hex: Constants.CLOUDS_COLOR)
            self.setYourArtistMiddleView()
            self.setYourArtistTopView()
        }
        //get artist info with id
        ArtistInteractor.ins.fetchArtist(id: currentArtistId, completion: { (artist, error) in
            self.currentArtist = artist
            self.setYourArtistTopViewData()
        })
        //compare favButton
        RelationshipInteractor.ins.fetchRelUserArtist { (relUserArtist, error) in
            let curUserId = UserDefaults.standard.string(forKey: "user_id")
            for eachRelUserArtist in relUserArtist! {
                if eachRelUserArtist.artistId == self.currentArtistId && curUserId == eachRelUserArtist.userId {
                    self.isFavArtist = true
                    self.updateFavoriteButton()
                }
            }
        }

        //get all album list
        AlbumInteractor.ins.fetchAlbumList(completion: { (albumList, error) in
            //get all song list
            SongInteractor.ins.fetchSongList(completion: { (songList, error) in
                //find popularSongs
                for eachSong in songList! {
                    guard let eachSongIdArtist = eachSong.idArtist else {
                        os_log("Not have Artist Id", log: OSLog.default, type: .error)
                        return
                    }
                    if self.currentArtistId == eachSongIdArtist {
                        self.popularSongs.append(eachSong)
                    }
                } //end loop
                //find latestReleaseAlbum
                for eachAlbum in albumList! {
                    guard let eachAlbumArtistId = eachAlbum.artistId else {
                        os_log("Not have Album Id", log: OSLog.default, type: .error)
                        return
                    }
                    if self.currentArtistId == eachAlbumArtistId {
                        if self.latestReleaseAlbum == nil {
                            guard eachAlbum.releaseDate != nil else {
                                 os_log("Don't have any release day", log: OSLog.default, type: .error)
                                return
                            }
                            self.latestReleaseAlbum = eachAlbum
                        }
                        else if self.latestReleaseAlbum != nil {
                            guard let maxDate = self.latestReleaseAlbum?.releaseDate, let latestRelease = eachAlbum.releaseDate else {
                                os_log("Don't have release day", log: OSLog.default, type: .error)
                                return
                            }
                            if maxDate < latestRelease {
                                self.latestReleaseAlbum = eachAlbum
                            }
                        }
                        else {
                            os_log("Don't have latest release album", log: OSLog.default, type: .error)
                            return
                        }
                        //count Song
                        for eachSong in songList! {
                            if eachSong.albumId == self.latestReleaseAlbum?.id { self.latestReleaseAlbum?.songCount += 1 }
                        }
                    }
                }
                self.yourArtistScreenTableView.popularSongs = self.popularSongs
                self.yourArtistScreenTableView.latestReleaseAlbums = [self.latestReleaseAlbum!]
                self.yourArtistScreenTableView.reloadData()
            })// end fetch artist list
        })// end fetch album list
        self.isPlayingState = AudioPlaying.ins.isPlaying
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    //
    //MARK: Setup view
    //
    private func setYourArtistTopView() {
        topView.backgroundColor = UIColor(hex: Constants.CLOUDS_COLOR)
        backgroundTopView.layer.applyShadow(color: UIColor.darkGray, alpha: 1, x: 0, y: 10, blur: 15)
        artistImage.frame = artistView.bounds
        artistImage.setRounded()
    }
    
    private func setYourArtistMiddleView() {
        addYourArtistScreenTableView()
    }
    
    private func addYourArtistScreenTableView() {
    middleView.addSubview(yourArtistScreenTableView)
    yourArtistScreenTableView.translatesAutoresizingMaskIntoConstraints = false
    yourArtistScreenTableView.toggleFooterView()
    yourArtistScreenTableView.leadingAnchor.constraint(equalTo: middleView.leadingAnchor).isActive = true
    yourArtistScreenTableView.trailingAnchor.constraint(equalTo: middleView.trailingAnchor).isActive = true
    yourArtistScreenTableView.topAnchor.constraint(equalTo: middleView.topAnchor).isActive = true
    yourArtistScreenTableView.bottomAnchor.constraint(equalTo: middleView.bottomAnchor).isActive = true
    }
    //
    //MARK: Functions
    //
    private func setYourArtistTopViewData() {
        guard let nameArtist = self.currentArtist?.name else { return }
        nameOfArtistLabel.text = nameArtist
        guard let imageArtistUrl = self.currentArtist?.imageUrl else { return }
        backgroundImageView.sd_setImage(with: URL(string: imageArtistUrl), completed: nil)
        artistImage.sd_setImage(with: URL(string: imageArtistUrl), completed: nil)
    }
    
    func setPlayButton(isPlaying: Bool) {
        playButton.setImage( isPlaying ? #imageLiteral(resourceName: "pause_icon") : #imageLiteral(resourceName: "img_play"), for: .normal)
    }
    
    func updateFavoriteButton(){
        let isFav = self.isFavArtist
        favButton.setImage(isFav ? #imageLiteral(resourceName: "tapped_heart_song_btn").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "heart_song_btn"), for: .normal)
    }
    //
    // MARK: - Actions
    //
    @IBAction func backFromArtistScreenButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addFavArtistButton(_ sender: Any) {
        favButton.isEnabled = false
        if self.isFavArtist {
            RelationshipInteractor.ins.removeFavArtist(artistID: currentArtistId, { (error) in
                self.favButton.isEnabled = true
                guard error == nil else {
                    presentAlertVC(target: self, title: "Error", message: "Error while set favorite", nil)
                    return
                }
                self.isFavArtist = false
                self.updateFavoriteButton()
            })
        } else {
            RelationshipInteractor.ins.addFavArtist(artistID: currentArtistId, { (error) in
                self.favButton.isEnabled = true
                guard error == nil else {
                    presentAlertVC(target: self, title: "Error", message: "Error while set favorite", nil)
                    return
                }
                self.isFavArtist = true
                self.updateFavoriteButton()
            })
        }
    } //end func
    
    @IBAction func playPopularSongsButton(_ sender: Any) {
        //create list song ID
        var listID: [String] = []
        popularSongs.forEach { (song) in
            listID += [song.id!]
        }
        let isPlaying = AudioPlaying.ins.isPlaying
        if isPlaying {
            setPlayButton(isPlaying: isPlaying)
            parentVC?.pauseMusic()
        }
        else {
            parentVC?.didTapMusic(listID: listID, index: 0 /*,isShowPlayer = false*/)
            setPlayButton(isPlaying: isPlaying)
        }
    }
    
    @IBAction func shareArtistButton(_ sender: Any) {
        shareButton.isEnabled = false
        let curtArtistName = self.currentArtist?.name ?? ""
        let itemString1: String = "Đây là nghệ sĩ tôi muốn chia sẻ với bạn... \(String(describing: curtArtistName))"
        let urlImage = currentArtist?.imageUrl ?? ""

        URLSession.shared.dataTask(with: URL(string: urlImage)!) { (data, response, error) in
            guard let data = data, error == nil else { return }
            let imageArtist = UIImage(data: data) ?? UIImage()
            
            var artistNameString = ""
            for char in curtArtistName {
                if char == " " {
                    artistNameString += "+"
                } else {
                    artistNameString.append(char)
                }
            }
            var HashtagArtistName = ""
            for char in curtArtistName {
                if char == " " {
                    HashtagArtistName += ""
                } else {
                    HashtagArtistName.append(char)
                }
            }
            let itemString2 = "https://www.google.com/search?q=\(artistNameString).\n#\(HashtagArtistName)"
            
            let activityController = UIActivityViewController(activityItems: [itemString1, imageArtist, itemString2], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
            self.shareButton.isEnabled = true
        }.resume()
    } //end share button
}//end class

extension ArtistScreen: MiniPlayerDelegate {
    func didTapPlayButton(isPlaying: Bool) {
        setPlayButton(isPlaying: isPlaying)
        self.isPlayingState = isPlaying

    }
}

extension ArtistScreen: ArtistCellDelegate {
    func showAlert(eachSongInPopular: Song) {
        
        func likeSong(alert: UIAlertAction!) {
            RelationshipInteractor.ins.fetchRelUserSong( completion: { (relUserSong, error) in
                var isFavSong = false
                guard let eachSongId = eachSongInPopular.id else { return }
                let curUserID = UserDefaults.standard.string(forKey: "user_id") ?? ""
                
                for eachRelUserSong in relUserSong! {
                    if eachRelUserSong.userId == curUserID && eachRelUserSong.songId == eachSongId {
                        isFavSong = true
                    }
                }
                
                if isFavSong {
                    presentAlertVC(target: self, title: "Error", message: "This song is already in your favorites list", nil)
                } else {
                    SongInteractor.ins.addFavSong(songID: eachSongId, { (error) in
                        guard error == nil else {
                            presentAlertVC(target: self, title: "Error", message: "Error while set favorite", nil)
                            return
                        }
                         presentAlertVC(target: self, title: "Successful", message: "This song is added in your favorites list", nil)
                    })
                }
            }) //end fetchRelUserSong
        }//end func likeSong
        
        func addToPlaylist(alert: UIAlertAction!) {
            guard let songId = eachSongInPopular.id else { return }
            let listPlaylistVC = ListPlayListRouter.createModule()
//            ListPlayListRouter.createModule().addSong(songId: songId, isAddSong: true)
            self.navigationController?.pushViewController(listPlaylistVC, animated: true)
        }
        
        let alert = UIAlertController(title: eachSongInPopular.name ?? "", message: "album: \(currentArtist?.name ?? "")", preferredStyle: .actionSheet)
        alert.setTitle(font: .systemFont(ofSize: 20), color: .black)
        alert.addAction( UIAlertAction(title: "Like", style: .default, handler: likeSong) )
        alert.addAction( UIAlertAction(title: "Add to playlist...", style: .default, handler: addToPlaylist) )
        alert.addAction( UIAlertAction(title: "Cancel", style: .cancel, handler: nil) )
        present(alert, animated: true, completion: nil)
    }
    

}
