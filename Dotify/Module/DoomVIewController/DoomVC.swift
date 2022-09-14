//
//  DoomVC.swift
//  Dotify
//
//  Created by Lucas Pham on 7/18/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import UIKit

class DoomVC: UIViewController, UISearchBarDelegate {

    var delegate: DoomVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let leftButton = UIBarButtonItem(title: "Show", style: .plain, target: self, action: #selector(didTapShowButton))
        navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(didTapSearchButton))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func didTapShowButton() {
        delegate?.didTapShowButton()
    }
    @objc func didTapSearchButton(){
        self.present(UINavigationController(rootViewController: SearchVCViewController()), animated: false, completion: nil)
    }
}

protocol DoomVCDelegate {
    func didTapShowButton()
}
