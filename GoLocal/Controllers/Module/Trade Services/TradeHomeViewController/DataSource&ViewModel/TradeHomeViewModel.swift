//
//  TradeHomeViewModel.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 05/05/21.
//

import Foundation
class TradeHomeViewModel {
    private var serviceRequests : ServiceRequests?
}
extension TradeHomeViewModel {
    func getServiceRequests() -> ServiceRequests?{
        serviceRequests
    }
    func clearRequeets() {
        self.serviceRequests = nil
    }
    func getRequestCount() -> Int{
        serviceRequests?.ser_requests?.count ?? 0
    }
    func setServicesDetails(value : ServiceRequests){
        serviceRequests = value
    }
    func removeService(atPos: Int) {
        serviceRequests?.ser_requests?.remove(at: atPos)
    }
}
