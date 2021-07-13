//
//  TradeOrderDetailsViewModel.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 09/06/21.
//

import Foundation
class TradeOrderDetailsViewModel {
    private var traderOrderDetails : TraderOrders?
    private var responseId = 0
    private var isPaymentDone = false
}
extension TradeOrderDetailsViewModel {
    func setResponseId(value : Int) {
        responseId = value
    }
    func getResponseId() -> Int? {
        responseId
    }
    func isPastOrder() -> Bool {
        traderOrderDetails?.serRequest?.requestStatus ?? "" == TRADE_SERVICE_STATUS.CANCELLED.rawValue ||
        traderOrderDetails?.serRequest?.requestStatus ?? "" == TRADE_SERVICE_STATUS.COMPLETED.rawValue ||
        traderOrderDetails?.serRequest?.requestStatus ?? "" == TRADE_SERVICE_STATUS.REQUESTED.rawValue 
    }
    func setOrderDetails(value : TraderOrders) {
        traderOrderDetails = value
        isPaymentDone = value.businessQuotationDetail?.tradeRequestBillingDetails?.isPaymentDone ?? false
    }
    func getOrderDetails() -> TraderOrders? {
        traderOrderDetails
    }
    
    func updatePaymentDone(value : Bool) {
        isPaymentDone = value
    }
    func isCustomerPaymentDone() -> Bool? {
        isPaymentDone
    }
}
