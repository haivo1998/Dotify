//
//  LogInPresenter.swift
//  Dotify
//
//  Created Lucas Pham on 7/12/19.
//  Copyright © 2019 Vinova. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class LogInPresenter: LogInPresenterProtocol {
    

    weak private var view: LogInViewProtocol?
    var interactor: LogInInteractorProtocol?
    private let router: LogInWireframeProtocol

    init(interface: LogInViewProtocol, interactor: LogInInteractorProtocol?, router: LogInWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    func logIn(curUser: User, completion: @escaping (Bool?, LogInError?) -> ()) {
        var curUser = curUser
        interactor?.loadAllUser(completion: { (listUser, error) in
            var logInError: LogInError?
            guard error == nil else {
                logInError = .LOAD_DATA_FAIL
                completion(nil, logInError!)
                return
            }
            if !self.checkLogIn(curUser: &curUser, listUser: listUser!) {
                completion(false, nil)
                return
            }
            let writeData = self.interactor?.writeIdToLocal(user: curUser)
            logInError = writeData! ? nil : .EXIST_USER
            completion(logInError == nil ? true : false, logInError)
            return
        })
    }
    
    func checkLogIn(curUser: inout User, listUser: [User]) -> Bool {
        for user in listUser {
            if curUser.username == user.username && curUser.password == user.password {
                curUser = user
                return true
            }
        }
        return false
    }
    
    func loadAllUserSuccess(data: User) {
        
    }
}
