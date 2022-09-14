//
//  YourMusicScreen.swift
//  Dotify
//
//  Created by An Nguyen Thanh on 7/10/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import UIKit

class YourMusicScreen: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    let yourMusicScreenTableView = YourMusicScreenTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setup()
    }

    func setup() {
        middleView.addSubview(yourMusicScreenTableView)
        yourMusicScreenTableView.leadingAnchor.constraint(equalTo: self.middleView.leadingAnchor).isActive = true
        yourMusicScreenTableView.trailingAnchor.constraint(equalTo: self.middleView.trailingAnchor).isActive = true
        yourMusicScreenTableView.topAnchor.constraint(equalTo: self.middleView.topAnchor).isActive = true
        yourMusicScreenTableView.bottomAnchor.constraint(equalTo: self.middleView.bottomAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationItem.title = "YOUR MUSIC"

        let rightLogo = UIBarButtonItem(image: UIImage (named: "loupe"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(methodName))
        self.navigationItem.rightBarButtonItem = rightLogo

        let leftLogo = UIBarButtonItem(image: UIImage (named: "line-menu"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(methodName))
        self.navigationItem.leftBarButtonItem = leftLogo

    }

    @objc private func methodName() {

    }

}
