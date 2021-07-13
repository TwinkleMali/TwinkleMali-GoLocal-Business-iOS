//
//  TradeServiceDetailsViewModel.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 06/05/21.
//

import Foundation
 
class TradeServiceDetailsViewModel {
    private var quotationRequest : SerRequests?
    private var serviceRequestDetails : ServiceRequestDetails?
    private var timerValue = 0
    private var bidOption = 0 // 0/1
}
extension TradeServiceDetailsViewModel {
    func setRequestDetails(value: SerRequests){
        self.quotationRequest = value
    }
    func getRequestDetails() -> SerRequests?{
        self.quotationRequest
    }
    func setServiceRequestDetails(){
        self.serviceRequestDetails = ServiceRequestDetails()
    }
    func setServiceRequestDetails(value : ServiceRequestDetails?){
        self.serviceRequestDetails = value
    }
    func getServiceRequestDetails() -> ServiceRequestDetails?{
        self.serviceRequestDetails
    }
    func setBidOption(value : Int) {
        bidOption = value
    }
    func getBidOption() -> Int {
        bidOption
    }
    func setTimerValue(value:Int){
        self.timerValue = value
    }
    func getTimerValue() -> Int{
        self.timerValue
    }
}
