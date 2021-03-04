//
//  OrderDetailsViewModel.swift
//  GoLocalDriver
//
//  Created by C110 on 15/01/21.
//

import Foundation
import UIKit

class OrderDetailsViewModel {
     var objOrderRequest : OrderRequests!
     var objOrder : OrderDetails!
}

extension OrderDetailsViewModel {
    func setOrderRequests(objOrderReqeust : OrderRequests){
        self.objOrderRequest = objOrderReqeust
    }
    
    func getOrderDetails() -> OrderRequests {
        return objOrderRequest
    }
    
    func setOrderDetail(objOrder : OrderDetails){
        self.objOrder = objOrder
    }
    
    func getOrderDetail() -> OrderDetails {
        return objOrder
    }
    
    func getProductDetails(productAt: Int) -> Products? {
        return objOrder.shopDetail?.products?[productAt]
    }
}
