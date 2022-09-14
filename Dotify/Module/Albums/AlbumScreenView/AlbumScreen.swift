//
//  AlbumScreen.swift
//  Dotify
//
//  Created by An Nguyen Thanh on 7/12/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import UIKit

class AlbumScreen: UIViewController {
    //
    // MARK: - Outlets
    //
    //top View
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backgroundTopView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var coverArtAlbumView: UIView!
    @IBOutlet weak var coverArtAlbumImage: UIImageView!
    @IBOutlet weak var nameOfAlbumLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    //middle View
    @IBOutlet weak var middleView: UIView!
    //
    // MARK: - Variables & Properties
    //
    var parentVC: MiniPlayerViewController?
    let yourAlbumsScreenTableView = AlbumTableView()
    var currentAlbumId: String = "0"
    var currentAlbum: Album?
    lazy var songInCurrentAlbum: [Song] = []
    lazy var songList: [Song] = []
    lazy var isPlayingState: Bool = false
    lazy var isFavAlbum: Bool = false
    //
    // MARK: - View Controller
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        yourAlbumsScreenTableView.albumScreenVC = self
        parentVC?.delegate = self
        
        DispatchQueue.main.async {
            self.view.backgroundColor = UIColor(hex: Constants.CLOUDS_COLOR)
            self.setYourAlbumsMiddleView()
            self.setYourAlbumsTopView()
        }
        //get info album
        AlbumInteractor.ins.fetchAlbum(id: self.currentAlbumId, completion: { (album, error) in
            self.currentAlbum = album
            self.setYourAlbumsTopViewData()
            
        })
        //compare favButton
        RelationshipInteractor.ins.fetchRelUserAlbum { (relUserAlbum, error) in
            let curUserId = UserDefaults.standard.string(forKey: "user_id")
            for eachRelUserAlbum in relUserAlbum! {
                if eachRelUserAlbum.albumId == self.currentAlbumId && curUserId == eachRelUserAlbum.userId {
                    self.isFavAlbum = true
                    self.updateFavoriteButton()
                }
            }
        }
        
        SongInteractor.ins.fetchSongList(completion: { (songList, error) in
            self.songList = songList!
            for eachSong in songList! {
                if self.currentAlbumId == eachSong.albumId {
                    self.songInCurrentAlbum.append(eachSong)
                }
            }
            self.yourAlbumsScreenTableView.songInCurrentAlbum = self.songInCurrentAlbum
            self.yourAlbumsScreenTableView.reloadData()
        })
        
        self.isPlayingState = AudioPlaying.ins.isPlaying
    }//end viewDidLoad
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    //
    //Mark: Setup View
    //
    private func setYourAlbumsTopView() {
        topView.backgroundColor = UIColor(hex: Constants.CLOUDS_COLOR)
        backgroundTopView.layer.applyShadow(color: UIColor.darkGray, alpha: 1, x: 0, y: 10, blur: 15)
        coverArtAlbumImage.frame = coverArtAlbumView.bounds
        coverArtAlbumImage.setRounded()
    }
    
    private func setYourAlbumsTopViewData() {
        guard let nameAlbum = self.currentAlbum?.name else { return }
        nameOfAlbumLabel.text = nameAlbum
        guard let imageAlbumUrl = self.currentAlbum?.imageUrl else { return }
        backgroundImageView.sd_setImage(with: URL(string: imageAlbumUrl), completed: nil)
        coverArtAlbumImage.sd_setImage(with: URL(string: imageAlbumUrl), completed: nil)
    }
    
    private func setYourAlbumsMiddleView() {
        addYourAlbumsScreenTableView()
    }
    
    private func addYourAlbumsScreenTableView() {
        middleView.addSubview(yourAlbumsScreenTableView)
        yourAlbumsScreenTableView.translatesAutoresizingMaskIntoConstraints = false
        yourAlbumsScreenTableView.toggleFooterView()
        yourAlbumsScreenTableView.leadingAnchor.constraint(equalTo: middleView.leadingAnchor).isActive = true
        yourAlbumsScreenTableView.trailingAnchor.constraint(equalTo: middleView.trailingAnchor).isActive = true
        yourAlbumsScreenTableView.topAnchor.constraint(equalTo: middleView.topAnchor).isActive = true
        yourAlbumsScreenTableView.bottomAnchor.constraint(equalTo: middleView.bottomAnchor).isActive = true
    }
    //
    //MARK: Functions
    //
    func setPlayButton(isPlaying: Bool) {
        playButton.setImage( isPlaying ? #imageLiteral(resourceName: "pause_icon") : #imageLiteral(resourceName: "img_play"), for: .normal)

    }
    
    func updateFavoriteButton(){
        let isFav = self.isFavAlbum
        favButton.setImage(isFav ? #imageLiteral(resourceName: "tapped_heart_song_btn").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "heart_song_btn"), for: .normal)
    }
    //
    // MARK: - Actions
    //
    @IBAction func backFromAlbumScreenButton(_ sender: Any) {
    navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favButton(_ sender: Any) {
        favButton.isEnabled = false
        if self.isFavAlbum {
            RelationshipInteractor.ins.removeFavAlbum(albumID: currentAlbumId, { (error) in
                self.favButton.isEnabled = true
                guard error == nil else {
                    presentAlertVC(target: self, title: "Error", message: "Error while set favorite", nil)
                    return
                }
                self.isFavAlbum = false
                self.updateFavoriteButton()
            })
        } else {
            RelationshipInteractor.ins.addFavAlbum(albumID: currentAlbumId, { (error) in
                self.favButton.isEnabled = true
                guard error == nil else {
                    presentAlertVC(target: self, title: "Error", message: "Error while set favorite", nil)
                    return
                }
                self.isFavAlbum = true
                self.updateFavoriteButton()
            })
        }
    }
    
    @IBAction func shareButton(_ sender: Any) {
        shareButton.isEnabled = false
        let currentAlbumName = self.currentAlbum?.name ?? ""
        let itemString1: String = "Đây là album tôi muốn chia sẻ với bạn... \(currentAlbumName)"
        let urlImage = currentAlbum?.imageUrl ?? ""
        URLSession.shared.dataTask(with: URL(string: urlImage)!) { (data, response, error) in
            guard let data = data, error == nil else { return }
            let imageAlbum = UIImage(data: data) ?? UIImage()
            // link search google
            var albumNameString = ""
            for char in currentAlbumName {
                if char == " " {
                    albumNameString += "+"
                } else {
                    albumNameString.append(char)
                }
            }
            var HashtagAlbumName = ""
            for char in currentAlbumName {
                if char == " " {
                    HashtagAlbumName += ""
                } else {
                    HashtagAlbumName.append(char)
                }
            }
            let itemString2 = "https://www.google.com/search?q=\(albumNameString)\n#\(HashtagAlbumName)"
            
            let activityController = UIActivityViewController(activityItems: [itemString1, imageAlbum, itemString2], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
            self.shareButton.isEnabled = true
        }.resume()
    }// end button
    
    @IBAction func playAlbumButton(_ sender: Any) {
        //create list song ID
        var listID: [String] = []
        songInCurrentAlbum.forEach { (song) in
            listID += [song.id!]
        }
        if  isPlayingState {
            setPlayButton(isPlaying: !isPlayingState)
            parentVC?.pauseMusic()
        }
        else {
            setPlayButton(isPlaying: !isPlayingState)
            parentVC?.didTapMusic(listID: listID, index: 0 /*,isShowPlayer = false*/)
        }
    }
}// end class

extension AlbumScreen: MiniPlayerDelegate {
    func didTapPlayButton(isPlaying: Bool) {
        setPlayButton(isPlaying: isPlaying)
        self.isPlayingState = isPlaying
    }
}

extension AlbumScreen: AlbumCellDelegate {
    func showAlert(eachSongInAlbum: Song) {
        
        func likeSong(alert: UIAlertAction!) {
            RelationshipInteractor.ins.fetchRelUserSong( completion: { (relUserSong, error) in
                var isFavSong = false
                guard let eachSongId = eachSongInAlbum.id else { return }
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
            guard let songId = eachSongInAlbum.id else { return }
            let listPlaylistVC = ListPlayListRouter.createModule()
            //            ListPlayListRouter.createModule().addSong(songId: songId, isAddSong: true)
            self.navigationController?.pushViewController(listPlaylistVC, animated: true)
        }
        
        let alert = UIAlertController(title: eachSongInAlbum.name ?? "", message: "album: \(currentAlbum?.name ?? "")", preferredStyle: .actionSheet)
        alert.setTitle(font: .systemFont(ofSize: 20), color: .black)
        alert.addAction( UIAlertAction(title: "Like", style: .default, handler: likeSong) )
        alert.addAction( UIAlertAction(title: "Add to playlist...", style: .default, handler: addToPlaylist) )
        alert.addAction( UIAlertAction(title: "Cancel", style: .cancel, handler: nil) )
        present(alert, animated: true, completion: nil)
    }//end show Alert
}

