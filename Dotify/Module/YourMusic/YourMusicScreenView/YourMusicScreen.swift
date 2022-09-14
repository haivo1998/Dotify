//
//  YourMusicScreen.swift
//  Dotify
//
//  Created by An Nguyen Thanh on 7/10/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import UIKit
import Alamofire
//import ViewAnimator

class YourMusicScreen: UIViewController {
    //
    // MARK: - Outlets
    //
    //middle view
    @IBOutlet weak var middleView: UIView!
    //top view
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var artistsView: UIView!
    @IBOutlet weak var albumsView: UIView!
    @IBOutlet weak var songsView: UIView!
    @IBOutlet weak var playlistsView: UIView!
    @IBOutlet weak var icArtistsImage: UIImageView!
    @IBOutlet weak var artistsLabel: UILabel!
    @IBOutlet weak var icAlbumsImage: UIImageView!
    @IBOutlet weak var albumsLabel: UILabel!
    @IBOutlet weak var icSongsImage: UIImageView!
    @IBOutlet weak var songsLabel: UILabel!
    @IBOutlet weak var icPlaylistsImage: UIImageView!
    @IBOutlet weak var playlistsLabel: UILabel!
    //
    // MARK: - Variables & Properties
    //
    var parentVC: MiniPlayerViewController?
    let yourFavoriteMusicScreenTableView = FavoriteMusicScreenTableView()
    lazy var currentUserId: String = "0"
    lazy var currentFavSongs: [Song] = []
    lazy var currentFavAlbums: [Album] = []
    lazy var currentFavArtists: [Artist] = []
    lazy var currentFavPlaylists: [Playlist] = []
    lazy var pressedTopViewState: PressedViewEnum = .ARTISTS
    //
    // MARK: - View Controller
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUserId = UserDefaults.standard.string(forKey: "user_id")!
        //set UI
        DispatchQueue.main.async {
            self.view.backgroundColor = UIColor(hex: Constants.CLOUDS_COLOR)
            self.setYourMusicScreenTopView()
            self.setYourMusicScreenTableView()
        }
        //fetch data from JSON
        getFavDataOfUser()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // hide navigation
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        yourFavoriteMusicScreenTableView.yourMusicScreenVC = self
        navigationItem.title = "YOUR MUSIC"
        let rightLogo = UIBarButtonItem(image: UIImage (named: "search"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(searchButton))
        self.navigationItem.rightBarButtonItem = rightLogo
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        
        let leftLogo = UIBarButtonItem(image: UIImage (named: "ic_hamburger_menu"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(hamburgerMenuButton))
        self.navigationItem.leftBarButtonItem = leftLogo
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        //add gesture
        self.songsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(songsViewAction)))
        self.albumsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(albumsViewAction)))
        self.playlistsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(playlistsViewAction)))
        self.artistsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(artistViewAction)))
    }
    
    private func setYourMusicScreenTopView() {
        topView.backgroundColor = UIColor(hex: Constants.CLOUDS_COLOR)
        artistsView.setSubTopView()
        albumsView.setSubTopView()
        songsView.setSubTopView()
        playlistsView.setSubTopView()
    }
    
    private func setYourMusicScreenTableView() {
        middleView.addSubview(yourFavoriteMusicScreenTableView)
        yourFavoriteMusicScreenTableView.translatesAutoresizingMaskIntoConstraints = false
        yourFavoriteMusicScreenTableView.toggleHeaderView()
        yourFavoriteMusicScreenTableView.toggleFooterView()
        yourFavoriteMusicScreenTableView.leadingAnchor.constraint(equalTo: middleView.leadingAnchor).isActive = true
        yourFavoriteMusicScreenTableView.trailingAnchor.constraint(equalTo: middleView.trailingAnchor).isActive = true
        yourFavoriteMusicScreenTableView.topAnchor.constraint(equalTo: middleView.topAnchor).isActive = true
        yourFavoriteMusicScreenTableView.bottomAnchor.constraint(equalTo: middleView.bottomAnchor).isActive = true
    }
    //
    // MARK: - Privite functions
    //
    private func setAnimation(aView: UIView) {
        //        let animation = AnimationType.zoom(scale: 0.8)
        //        aView.animate(animations: [animation])
        //        let fromAnimation = AnimationType.from(direction: .right, offset: 30.0)
        //        middleView.animate(animations: [fromAnimation])
        aView.pulsate()
        middleView.shake()
    }
    
    private func getFavDataOfUser() {
        getFavoriteArtistOfUser()
        getFavoriteSongOfUser()
        getFavoriteAlbumsOfUser()
        getFavoritePlaylistOfUser()
    }
    
    private func getFavoriteSongOfUser() {
        SongInteractor.ins.fetchSongList( completion: { (songList, error) in
            ArtistInteractor.ins.fetchArtistList(completion: { (artistList, error) in
                RelationshipInteractor.ins.fetchRelUserSong( completion: { (relUserSong, error) in
                    for eachRelUserSong in relUserSong! {
                        guard let eachRelUserSongUserId = eachRelUserSong.userId else { return }
                        //compare current user id with usetId in Rel
                        if eachRelUserSongUserId == self.currentUserId {
                            for eachSong in songList! {
                                guard let eachSongId = eachSong.id else { return }
                                // attach name artist to song
                                if eachSongId == eachRelUserSong.songId {
                                    for eachArtist in artistList! {
                                        guard let eachArtistId = eachArtist.id else { return }
                                        if eachArtistId == eachSong.idArtist {
                                            eachSong.artistName = eachArtist.name
                                        }
                                    }
                                //add a song to array song
                                self.currentFavSongs.append(eachSong)
                                }
                            }
                        }
                    } //end loop
                })
            })
        })
    }//end func getFavoriteSongOfUser
    
    private func getFavoriteArtistOfUser() {
        ArtistInteractor.ins.fetchArtistList(completion: { (artistList, error) in
            RelationshipInteractor.ins.fetchRelUserArtist( completion: { (relUserArtist, error) in
                for eachRelUserArtist in relUserArtist! {
                    guard let eachRelUserArtistUserId = eachRelUserArtist.userId else { return }
                    //compare current user id with usetId in Rel
                    if eachRelUserArtistUserId == self.currentUserId {
                        for eachArtist in artistList! {
                            guard let eachArtistId = eachArtist.id else { return }
                            if eachArtistId == eachRelUserArtist.artistId {
                                self.currentFavArtists.append(eachArtist)
                            }
                        }
                    }
                } //end loop
                self.changeTopView()
                self.yourFavoriteMusicScreenTableView.currentFavArtists = self.currentFavArtists
                self.yourFavoriteMusicScreenTableView.reloadData()
            })
        })
    }//end func getFavoriteArtistOfUser
    
    private func getFavoriteAlbumsOfUser() {
        AlbumInteractor.ins.fetchAlbumList(completion: { (albumList, error) in
            RelationshipInteractor.ins.fetchRelUserAlbum( completion: { (relUserAlbum, error) in
                for eachRelUserAlbum in relUserAlbum! {
                    guard let eachRelUserAlbumUserId = eachRelUserAlbum.userId else { return }
                    //compare current user id with usetId in Rel
                    if eachRelUserAlbumUserId == self.currentUserId {
                        for eachAlbum in albumList! {
                            guard let eachAlbumId = eachAlbum.id else { return }
                            if eachAlbumId == eachRelUserAlbum.albumId {
                                self.currentFavAlbums.append(eachAlbum)
                            }
                        }
                    }
                } //end loop
            })
        })
    }//end func getFavoriteAlbumsOfUser
    
    private func getFavoritePlaylistOfUser() {
        PlaylistInteractor.ins.fetchPlaylistList(completion: { (playlistList, error) in
            RelationshipInteractor.ins.fetchRelUserPlaylist( completion: { (relUserPlaylist, error) in
                UserInteractor.ins.fetchAllUser( completion: { (allUser, error) in
                    for eachRelUserPlaylist in relUserPlaylist! {
                        guard let eachRelUserPlaylistUserId = eachRelUserPlaylist.userId else { return }
                        //compare current user id with usetId in Rel
                        if eachRelUserPlaylistUserId == self.currentUserId {
                            for eachPlaylist in playlistList! {
                                guard let eachPlaylistId = eachPlaylist.id else { return }
                                if eachPlaylistId == eachRelUserPlaylist.playlistId {
                                    //find owner of playlist
                                    for eachUser in allUser! {
                                        if eachPlaylist.userId == eachUser.id {
                                            eachPlaylist.ownerOfPlaylist = eachUser.username
                                            break
                                        }
                                    }
                                    self.currentFavPlaylists.append(eachPlaylist)
                                }
                            }
                        }
                    } //end loop
                })
            })
        })
    }//end func getFavoritePlaylistOfUser
    //
    // MARK: - Actions
    //
    @objc func hamburgerMenuButton() {
        parentVC?.toggleHamburgerView()
    }
    
    @objc func searchButton() {
        let searchVC = UINavigationController(rootViewController: SearchRouter.createModule(miniPlayer: parentVC))
        parentVC?.present(searchVC, animated: false, completion: nil)
    }
    //Gesture top view
    @objc func artistViewAction() {
        pressedTopViewState = .ARTISTS
        changeTopView()
        setAnimation(aView: artistsView)
        //set data
        self.yourFavoriteMusicScreenTableView.pressedTopViewState = .ARTISTS
        self.yourFavoriteMusicScreenTableView.currentFavArtists = self.currentFavArtists
        self.yourFavoriteMusicScreenTableView.reloadData()
    }
    
    @objc func albumsViewAction() {
        pressedTopViewState = .ALBUMS
        changeTopView()
        setAnimation(aView: albumsView)
        //set data
        self.yourFavoriteMusicScreenTableView.pressedTopViewState = .ALBUMS
        self.yourFavoriteMusicScreenTableView.currentFavAlbums = self.currentFavAlbums
        self.yourFavoriteMusicScreenTableView.reloadData()
    }
    
    @objc func songsViewAction() {
        pressedTopViewState = .SONGS
        changeTopView()
        setAnimation(aView: songsView)
        //set data
        self.yourFavoriteMusicScreenTableView.pressedTopViewState = .SONGS
        self.yourFavoriteMusicScreenTableView.currentFavSongs = self.currentFavSongs
        self.yourFavoriteMusicScreenTableView.reloadData()
    }
    
    @objc func playlistsViewAction() {
        pressedTopViewState = .PLAYLISTS
        changeTopView()
        setAnimation(aView: playlistsView)
        //set data
        self.yourFavoriteMusicScreenTableView.pressedTopViewState = .PLAYLISTS
        self.yourFavoriteMusicScreenTableView.currentFavPlaylists = self.currentFavPlaylists
        self.yourFavoriteMusicScreenTableView.reloadData()
    }
    
    private func changeTopView() {
        artistsLabel.textColor = pressedTopViewState == .ARTISTS ? UIColor(hex: Constants.ORANGE_COLOR) : .black
        icArtistsImage.image = pressedTopViewState == .ARTISTS ? UIImage(#imageLiteral(resourceName: "ic_artists_tapped.png")) : UIImage(#imageLiteral(resourceName: "ic_artists"))
        albumsLabel.textColor = pressedTopViewState == .ALBUMS ? UIColor(hex: Constants.ORANGE_COLOR) : .black
        icAlbumsImage.image = pressedTopViewState == .ALBUMS ? UIImage(#imageLiteral(resourceName: "ic_album_tapped.png")) : UIImage(#imageLiteral(resourceName: "ic_album"))
        songsLabel.textColor = pressedTopViewState == .SONGS ? UIColor(hex: Constants.ORANGE_COLOR) : .black
        icSongsImage.image = pressedTopViewState == .SONGS ? UIImage(#imageLiteral(resourceName: "ic_songs_tapped")) : UIImage(#imageLiteral(resourceName: "ic_songs"))
        playlistsLabel.textColor = pressedTopViewState == .PLAYLISTS ? UIColor(hex: Constants.ORANGE_COLOR) : .black
        icPlaylistsImage.image = pressedTopViewState == .PLAYLISTS ? UIImage(#imageLiteral(resourceName: "ic_playlists_tapped")) : UIImage(#imageLiteral(resourceName: "ic_playlists"))
    }
}

enum PressedViewEnum: Int {
    case ARTISTS, ALBUMS, SONGS, PLAYLISTS
}
