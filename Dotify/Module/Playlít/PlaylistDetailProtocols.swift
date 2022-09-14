//
//  PlaylistDetailProtocols.swift
//  Dotify
//
//  Created Lucas Pham on 7/29/19.
//  Copyright © 2019 Vinova. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

//MARK: Wireframe -
protocol PlaylistDetailWireframeProtocol: class {

}
//MARK: Presenter -
protocol PlaylistDetailPresenterProtocol: class {
    func loadAllSong(of playlistId: String, _ completion: @escaping ([RelPlaylistSong], Error?) -> Void)
    func loadPlaylist(id: String, _ completion: @escaping (Playlist, Error?) -> Void )
    func removeSongFromPlaylist(songId: String, playlistId: String, _ completion: @escaping (Error?) -> Void)
    func loadUser(with id: String, _ completion: @escaping (User?, Error?) -> Void)
    func checkIfFavorite(userId: String, playlistId: String ,_ completion: @escaping (Bool, Error?) -> Void )
    func markFav(userId: String, playlistId: String, _ completion: @escaping (Error?) -> Void)
    func removeFav(userId: String, playlistId: String, _ completion: @escaping (Error?) -> Void)
}

//MARK: Interactor -
protocol PlaylistDetailInteractorProtocol: class {

  var presenter: PlaylistDetailPresenterProtocol?  { get set }
    func loadRelPlaylistSong(of playlistId: String, _ completion: @escaping ([RelPlaylistSong], Error?) -> Void )
    func loadPlaylist(id: String, _ completion: @escaping (Playlist, Error?) -> Void )
}

//MARK: View -
protocol PlaylistDetailViewProtocol: class {

  var presenter: PlaylistDetailPresenterProtocol?  { get set }
}
