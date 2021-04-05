//
//  StripeConnectViewModel.swift
//  GoLocalDriver
//
//  Created by C100-174 on 12/03/21.
//

import Foundation

class StripeConnectViewModel {
    
}
extension StripeConnectViewModel {
    
    func getAuthRequest() -> URLRequest? {
        if let url = URL(string: PATH_OAUTH) {
            let req = URLRequest(url: url)
            return req
        } else {
            return nil
        }
    }
    
    
}
