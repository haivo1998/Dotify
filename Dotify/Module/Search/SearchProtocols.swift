//
//  SearchProtocols.swift
//  Dotify
//
//  Created Lucas Pham on 7/24/19.
//  Copyright © 2019 Vinova. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

//MARK: Wireframe -
protocol SearchWireframeProtocol: class {

}
//MARK: Presenter -
protocol SearchPresenterProtocol: class {
    func searchTitle(_ title: String, _ completionSong: @escaping ([Song], Error?) -> Void, _ completionArtist: @escaping ([Artist], Error?) -> Void, _ completionAlbum: @escaping ([Album], Error?) -> Void, _ completionPlaylist: @escaping ([Playlist], Error?) -> Void)
}

//MARK: Interactor -
protocol SearchInteractorProtocol: class {

    var presenter: SearchPresenterProtocol?  { get set }
    func loadAllSong(_ completion: @escaping ([Song]? , Error?) -> Void )
    func loadAllArtist(_ completion: @escaping ([Artist]? , Error?) -> Void )
    func loadAllPlaylist(_ completion: @escaping ([Playlist]? , Error?) -> Void )
    func loadAllAlbum(_ completion: @escaping ([Album]? , Error?) -> Void ) 
}

//MARK: View -
protocol SearchViewProtocol: class {

  var presenter: SearchPresenterProtocol?  { get set }
}
