//
//  LoginViewModel.swift
//  GoLocal
//
//  Created by C100-104on 17/12/20.
//

import Foundation
class LoginViewModel {
    private var email: String?
    private var password: String?
    private var username: String?
    private var phonenum: String?
    private var firstname: String?
    private var lastname: String?
    //private var loginDetails  = LoginDetials()
}
extension LoginViewModel {
    func setEmail(value : String) {
        self.email = value
    }
    
    func getEmail() -> String? {
        email
    }
    
    func setPassword(value : String) {
        self.password = value
    }
    
    func getPassword() -> String? {
        password
    }
    
    func setUsername(value : String) {
        self.username = value
    }
    
    func getUsername() -> String? {
        username
    }
    
    func setFirstname(value : String) {
        self.firstname = value
    }
    
    func getFirstname() -> String? {
        firstname
    }
    
    func setLastname(value : String) {
        self.lastname = value
    }
    
    func getLastname() -> String? {
        lastname
    }
    
    func setPhonenum(value : String) {
        self.phonenum = value
    }
    
    func getPhonenum() -> String? {
        phonenum
    }
    
    func getLoginCredentials() -> LoginDetials {
        var loginDetails  = LoginDetials()
        loginDetails.email = self.email!
        loginDetails.password = self.password!
        return loginDetails
    }
}

