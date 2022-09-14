//
//  OpenViewController.swift
//  Dotify
//
//  Created by Lucas Pham on 7/12/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import UIKit
import FirebaseDatabase

class OpenViewController: UIViewController {
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineView.backgroundColor = UIColor(hex: Constants.DEFAULT_COLOR)?.withAlphaComponent(0.75)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    @IBAction func didTapLogIn(_ sender: Any) {
        self.navigationController?.pushViewController(LogInRouter.createModule(), animated: true)
    }
    @IBAction func didTapSignUp(_ sender: Any) {
        self.navigationController?.pushViewController(SignUpRouter.createModule(), animated: true)
    }
    
}
