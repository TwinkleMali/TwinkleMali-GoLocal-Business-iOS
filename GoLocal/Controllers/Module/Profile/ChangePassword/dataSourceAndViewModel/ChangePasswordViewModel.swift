//
//  ChangePasswordViewModel.swift
//  GoLocal
//
//  Created by C110 on 17/12/20.
//

import Foundation
class ChangePasswordViewModel {
    private var currentPwd: String?
    private var newPwd: String?
    private var confirmPwd: String?
}
extension ChangePasswordViewModel {
    func setCurrentPwd(value : String) {
        self.currentPwd = value
    }
    
    func setNewPwd(value : String) {
        self.newPwd = value
    }
    
    func setConfirmPwd(value : String) {
        self.confirmPwd = value
    }
    
    func getCurrentPwd() -> String? {
        currentPwd
    }
    
    func getNewPwd() -> String? {
        newPwd
    }
    
    func getConfirmPwd() -> String? {
        confirmPwd
    }
    
}

