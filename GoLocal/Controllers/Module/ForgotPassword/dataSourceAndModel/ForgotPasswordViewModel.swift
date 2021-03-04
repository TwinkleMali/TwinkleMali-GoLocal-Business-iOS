//
//  ForgotPasswordViewModel.swift
//  GoLocal
//
//  Created by C100-104on 17/12/20.
//

import Foundation
class ForgotPasswordViewModel {
    private var email : String?
    
}
extension ForgotPasswordViewModel {
    func setEmail(email : String) {
        self.email = email
    }
    func getEmail() -> String? {
        self.email
    }
}
