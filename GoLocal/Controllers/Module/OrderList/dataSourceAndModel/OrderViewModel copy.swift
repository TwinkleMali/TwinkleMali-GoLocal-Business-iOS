//
//  OrderViewModel.swift
//  GoLocalDriver
//
//  Created by C100-142 on 15/01/21.
//

import Foundation
import UIKit

class OrderViewModel {
//    private var arrOrdersList : [OrderList] = []
    private var arrCurrentOrderList : [OrderList] = []
    private var arrPastOrdersList : [OrderList] = []
    private var arrCurrentOrders : [OrderDetails] = []
    private var arrPastOrders : [OrderDetails] = []
    private var objOrder : OrderDetails!
    private var arrayCurrentProduct : [[String:Any]] = []
    private var arrayPastProduct : [[String:Any]] = []
}
    
extension OrderViewModel {
    
//    func getOrderListCount() -> Int {
//        arrOrdersList.count
//    }
//
    func setOrderList(arrOrderList : [OrderList],orderType : Int){
        arrCurrentOrderList.append(contentsOf: arrOrderList)
    }
    
    func getOrderListCount(orderType : Int) -> Int{
        if orderType == OrderType.CurrentOrder.rawValue{
            return arrCurrentOrderList.count
        }else if orderType == OrderType.PastOrder.rawValue{
            return arrPastOrdersList.count
        }
        return 0
    }
       
    func getOrderRowCount(orderType : Int) -> Int {
        if orderType == OrderType.CurrentOrder.rawValue{
            return arrCurrentOrders.count
        }else if orderType == OrderType.PastOrder.rawValue{
            return arrPastOrders.count
        }
        return 0
    }
    
    func getOrder(at :Int,orderType : Int) -> OrderDetails {
        if orderType == OrderType.CurrentOrder.rawValue{
            return arrCurrentOrders[at]
        }else {
            return arrPastOrders[at]
        }
    }
    
    func setSelectedOrder(objOrder : OrderDetails) {
        self.objOrder = objOrder
    }
    
    
    func getShopDetails(at :Int,orderType : Int) -> ShopDetail {
        if orderType == OrderType.CurrentOrder.rawValue{
            return (arrCurrentOrders[at].shopDetail)!
        }else {
            return (arrPastOrders[at].shopDetail)!
        }
    }
    
    func getCustomerDetails(at :Int,orderType : Int) -> CustomerDetails {
        if orderType == OrderType.CurrentOrder.rawValue{
            return (arrCurrentOrders[at].customerDetails)!
        }else {
            return (arrPastOrders[at].customerDetails)!
        }
    }
    
    func getBillingDetails(at :Int,orderType : Int) -> BillingDetails {
        if orderType == OrderType.CurrentOrder.rawValue{
            return (arrCurrentOrders[at].billingDetails)!
        }else {
            return (arrPastOrders[at].billingDetails)!
        }
    }
    
//    func getProductCount(at :Int, orderType : Int ) -> Int {
//        if orderType == OrderType.CurrentOrder.rawValue{
//            return arrCurrentOrders[at].shopDetail?.products?.count ?? 0
//        }else {
//            return arrPastOrders[at].shopDetail?.products?.count ?? 0
//        }
//      
//    }
    
    func getProductDetails(at :Int,productAt: Int,orderType : Int) -> Products? {
        if orderType == OrderType.CurrentOrder.rawValue{
            return arrCurrentOrders[at].shopDetail?.products?[productAt]
        }else {
            return arrPastOrders[at].shopDetail?.products?[productAt]
        }
    }
    
    
    func setOrders(arrOrder : [OrderDetails],orderType : Int){
        if orderType == OrderType.CurrentOrder.rawValue{
            for objOrder in  arrOrder{
                if !self.arrCurrentOrders.contains(where: { $0.id == objOrder.id }) {
                    print("OrderId : \(objOrder.id ?? 0)")
                    self.arrCurrentOrders.append(objOrder)
                    var productDic : [String : Any]
                    for objproduct in (objOrder.shopDetail?.products)! {
                        for objselItem in objproduct.selectedProducts! {
                            productDic = ["orderId":objOrder.id ?? 0,
                                          "productId" : objproduct.id!,
                                          "productName":objproduct.productName!,
                                          "quantity":objselItem.quantity!,
                                          "variationName":objselItem.variationName.asStringOrEmpty(),
                                          "addons":objselItem.addons ?? []]
                            arrayCurrentProduct.append(productDic)
                        }
                    }
                }
            }
        }else {
            for objOrder in arrOrder{
                if !self.arrPastOrders.contains(where: { $0.id == objOrder.id }) {
                    print("POrderId : \(objOrder.id ?? 0)")
                    self.arrPastOrders.append(objOrder)
                    var productDic : [String : Any]
                    for objproduct in (objOrder.shopDetail?.products)! {
                        for objselItem in objproduct.selectedProducts! {
                            productDic = ["orderId":objOrder.id ?? 0,
                                          "productId" : objproduct.id.asStringOrEmpty(),
                                          "productName":objproduct.productName.asStringOrEmpty(),
                                          "quantity":objselItem.quantity.asStringOrEmpty(),
                                          "variationName":objselItem.variationName.asStringOrEmpty(),
                                          "addons":objselItem.addons ?? []]
                            arrayPastProduct.append(productDic)
                        }
                    }
                }
            }
        }
    }
    
    func getOrders(orderType : Int) -> [OrderDetails]{
        if orderType == OrderType.CurrentOrder.rawValue{
           return arrCurrentOrders
        }else if orderType == OrderType.PastOrder.rawValue{
            return arrPastOrders
        }
        return [OrderDetails]()
    }
    
    func removeAllCurrentOrder(orderType : Int){
        if orderType == OrderType.CurrentOrder.rawValue{
            self.arrCurrentOrders.removeAll()
        }else if orderType == OrderType.PastOrder.rawValue{
            self.arrPastOrders.removeAll()
        }
    }    
    
    func removeOrder(objOrder : OrderDetails,orderType : Int){
        if orderType == OrderType.CurrentOrder.rawValue{
            if let index = self.arrCurrentOrders.firstIndex(where: {$0.id == objOrder.id}) {
                self.arrCurrentOrders.remove(at: index)
            }
        }else if orderType == OrderType.PastOrder.rawValue{
            if let index = self.arrPastOrders.firstIndex(where: {$0.id == objOrder.id}) {
                self.arrPastOrders.remove(at: index)
            }
        }
    }
    

    func getProductArray(orderId :Int, orderType : Int) -> [[String:Any]] {
        if orderType == OrderType.CurrentOrder.rawValue{
            let newArray =  arrayCurrentProduct.filter{$0["orderId"] as! Int == orderId}
            return newArray
        }else if orderType == OrderType.PastOrder.rawValue{
            
            let newArray =  arrayPastProduct.filter{$0["orderId"] as! Int == orderId}
            return newArray
        }
        return []
    }
    
//        var arrProduct : [Products] = []
//        var tempArray : [Products] = []
//        if orderType == OrderType.CurrentOrder.rawValue{
//            tempArray = (arrCurrentOrders[at].shopDetail?.products)!
//        }else if orderType == OrderType.PastOrder.rawValue{
//            tempArray = (arrPastOrders[at].shopDetail?.products)!
//        }
//
//        if tempArray.count > 0{
//            for objProduct in tempArray {
//                let selProducts : [SelectedProducts] = objProduct.selectedProducts!
//                if selProducts.count > 0{
//                    for _ in selProducts{
//                        arrProduct.append(objProduct)
//                    }
//                }else {
//                    arrProduct.append(objProduct)
//                }
//            }
//        }
//        return arrProduct.count
}


