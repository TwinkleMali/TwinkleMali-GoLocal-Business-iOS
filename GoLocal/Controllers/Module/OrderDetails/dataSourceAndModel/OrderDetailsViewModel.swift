//
//  OrderDetailsViewModel.swift
//  GoLocalDriver
//
//  Created by C110 on 15/01/21.
//

import Foundation
import UIKit

class OrderDetailsViewModel {
    private var arrOrders : [OrderDetails] = []
    private var objOrderRequest : OrderRequests!
    //private var objOrder : OrderDetails!
    private var selectedTab = 0
    private var products : [OrderProduct] = []
}

extension OrderDetailsViewModel {
    func setOrderRequests(objOrderReqeust : OrderRequests){
        self.objOrderRequest = objOrderReqeust
    }
    
    func getOrderDetails() -> OrderRequests {
        return objOrderRequest
    }
    
//    func setOrderDetail(objOrder : OrderDetails){
//        self.objOrder = objOrder
//    }
    func isOrderAvailabe() -> Bool {
        arrOrders.count > 0
    }
    func getOrderDetail() -> OrderDetails {
        
        return arrOrders[selectedTab]
    }
    func getOrderDetail(no : Int = 0) -> OrderDetails {
        return arrOrders[no]
    }
    func getProductDetails(productAt: Int) -> Products? {
        return arrOrders[selectedTab].shopDetail?.products?[productAt]
    }
    
    //JL
    func setOrderArr(arrOrders : [OrderDetails]){
        self.arrOrders.removeAll()
        self.arrOrders.append(contentsOf: arrOrders)
    }
    func getProductsCount() -> Int{
        products.count
    }
    func getProduct(atPos : Int) -> OrderProduct{
        products[atPos]
    }
    func manageProducts()  {
        products.removeAll()
        if let products = getOrderDetail().shopDetail?.products {
            for product in products {
                if let selectedProducts = product.selectedProducts {
                    var subProductCnt = 0
                    for _ in selectedProducts {
                        var productObj = OrderProduct()
                        productObj.products = product
                        productObj.index = subProductCnt
                        self.products.append(productObj)
                        subProductCnt += 1
                    }
                }
            }
        }
    }
    
    //Update tab - (first / second)
    func updateTab(value :  Int) {
        selectedTab = value
    }
    func isMerged() -> Bool{
        arrOrders.count > 1
    }
    
}
