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

//MARK:- Service RequestDetails
struct ServiceRequestDetails {
    var payInAdvanceAmount = 0
    var payDiposite = 0
    var paymentOption = ""
    var businessOption = "Business A"
    var businessB_Options = BusinessB_Option_Types.NONE
    var depositOption : depositType = .NONE
    var depositValue : Double = 0
    var bidAmount : Double = 0
    var calloutFee : Double = 0
    var arrivalTime = 30
    var quote = ""
}


struct OrderProduct{
    var products : Products?
    var index = 0
}
