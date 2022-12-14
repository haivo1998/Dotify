//
//  PlaylistDetailRouter.swift
//  Dotify
//
//  Created Lucas Pham on 7/29/19.
//  Copyright © 2019 Vinova. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class PlaylistDetailRouter: PlaylistDetailWireframeProtocol {
    
    weak var viewController: PlaylistDetailViewController?
    
    static func createModule() -> PlaylistDetailViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = PlaylistDetailViewController(nibName: nil, bundle: nil)
        let interactor = PlaylistDetailInteractor()
        let router = PlaylistDetailRouter()
        let presenter = PlaylistDetailPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}
