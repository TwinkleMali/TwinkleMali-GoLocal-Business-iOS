//
//  Struct.swift
//  GoLocal
//
//  Created by C100-104on 27/12/20.
//

import Foundation


struct VALIDATION_METHODS {
    func getMissingMessage(_ ofType : VALIDATION_MESSAGE) -> String {
        let appendingMessage = " is missing."
        return ofType.rawValue + appendingMessage
    }
    func getEnterMessage(_ ofType : VALIDATION_MESSAGE) -> String {
        let appendingMessage = "Please Enter "
        return appendingMessage + ofType.rawValue + "."
    }
    func getEnterValidDataMessage(_ ofType : VALIDATION_MESSAGE) -> String {
        let appendingMessage = "Please Enter valid "
        return appendingMessage + ofType.rawValue + "."
    }
}


//MARK:- LOGIN
struct LoginDetials : Codable {
    var email = ""
    var password = ""
}



