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
    
    func getOrderListCount(orderType : Int) -> Int{
        if orderType == OrderType.CurrentOrder.rawValue{
            return arrCurrentOrderList.count
        }else if orderType == OrderType.PastOrder.rawValue{
            return arrPastOrdersList.count
        }
        return 0
    }
    
    func getOrderRowCount(at :Int, orderType : Int) -> Int {
        if orderType == OrderType.CurrentOrder.rawValue{
            return arrCurrentOrderList[at].orders?.count ?? 0
        }else if orderType == OrderType.PastOrder.rawValue{
            return arrPastOrdersList[at].orders?.count ?? 0
        }
        return 0
    }
   
    func setOrderList(arrOrderList : [OrderList],orderType : Int){
        if orderType == OrderType.CurrentOrder.rawValue{
            arrCurrentOrderList.append(contentsOf: arrOrderList)
            var productDic : [String : Any]
                for Orders  in arrOrderList as [OrderList]{
                    for objOrder in Orders.orders! as [OrderDetails]{
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
        }else{
            arrPastOrdersList.append(contentsOf: arrOrderList)
            var productDic : [String : Any]
                for Orders  in arrOrderList as [OrderList]{
                    for objOrder in Orders.orders! as [OrderDetails]{
                        for objproduct in (objOrder.shopDetail?.products)! {
                            for objselItem in objproduct.selectedProducts! {
                                productDic = ["orderId":objOrder.id ?? 0,
                                              "productId" : objproduct.id!,
                                              "productName":objproduct.productName!,
                                              "quantity":objselItem.quantity!,
                                              "variationName":objselItem.variationName.asStringOrEmpty(),
                                              "addons":objselItem.addons ?? []]
                                arrayPastProduct.append(productDic)
                            }
                        }
                    }
                }
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
    
    func getArrOrder(listAt :Int,orderType : Int) -> [OrderDetails]? {
        if orderType == OrderType.CurrentOrder.rawValue{
            return arrCurrentOrderList[listAt].orders
        }else {
            return arrPastOrdersList[listAt].orders
        }
    }
    func isOrderMerged(listAt :Int,orderType : Int) -> Bool{
        if orderType == OrderType.CurrentOrder.rawValue{
            return arrCurrentOrderList[listAt].orders?.count ?? 0 > 1
        }else if orderType == OrderType.PastOrder.rawValue{
            return arrPastOrdersList[listAt].orders?.count ?? 0 > 1
        }
        return false
    }
    func getOrderProductCount(orderId :Int,orderType : Int) -> Int{
        self.getProductArray(orderId: orderId, orderType: orderType).count
    }
    func getOrderList(listAt :Int,orderType : Int) -> [OrderDetails]{
        if orderType == OrderType.CurrentOrder.rawValue{
            return arrCurrentOrderList[listAt].orders!
        }else if orderType == OrderType.PastOrder.rawValue{
            return arrPastOrdersList[listAt].orders!
        }
        return [OrderDetails]()
    }
    
    func getOrder(listAt :Int, orderAt : Int,orderType : Int) -> OrderDetails {
        if orderType == OrderType.CurrentOrder.rawValue{
            return (arrCurrentOrderList[listAt].orders?[orderAt])!
        }else {
            return (arrPastOrdersList[listAt].orders?[orderAt])!
        }
    }
    
    func setSelectedOrder(objOrder : OrderDetails) {
        self.objOrder = objOrder
    }
    
    
    func getShopDetails(listAt :Int, orderAt : Int,orderType : Int) -> ShopDetail {
        if orderType == OrderType.CurrentOrder.rawValue{
            return (arrCurrentOrderList[listAt].orders?[orderAt].shopDetail)!
        }else {
            return (arrPastOrdersList[listAt].orders?[orderAt].shopDetail)!
        }
    }
    
    func getCustomerDetails(listAt :Int, orderAt : Int,orderType : Int) -> CustomerDetails {
        if orderType == OrderType.CurrentOrder.rawValue{
            return (arrCurrentOrderList[listAt].orders?[orderAt].customerDetails)!
        }else {
            return (arrPastOrdersList[listAt].orders?[orderAt].customerDetails)!
        }
    }
    
    func getBillingDetails(listAt :Int, orderAt : Int,orderType : Int) -> BillingDetails {
        if orderType == OrderType.CurrentOrder.rawValue{
            return (arrCurrentOrderList[listAt].orders?[orderAt].billingDetails)!
        }else {
            return (arrPastOrdersList[listAt].orders?[orderAt].billingDetails)!
        }
    }
    
    func getProductDetails(listAt :Int, orderAt : Int,productAt: Int,orderType : Int) -> Products? {
        if orderType == OrderType.CurrentOrder.rawValue{
            return arrCurrentOrderList[listAt].orders?[orderAt].shopDetail?.products?[productAt]
        }else {
            return arrPastOrdersList[listAt].orders?[orderAt].shopDetail?.products?[productAt]
        }
    }
    
    func removeAllCurrentOrder(orderType : Int){
        if orderType == OrderType.CurrentOrder.rawValue{
            self.arrCurrentOrderList.removeAll()
            self.arrayCurrentProduct.removeAll()
        }else if orderType == OrderType.PastOrder.rawValue{
            self.arrPastOrdersList.removeAll()
            self.arrayPastProduct.removeAll()
        }
    }    
    
   
    func removeOrder(listAt :Int, orderAt : Int,objOrder : OrderDetails,orderType : Int){
        if orderType == OrderType.CurrentOrder.rawValue{
            if let index = self.arrCurrentOrderList[listAt].orders!.firstIndex(where: {$0.id == objOrder.id}) {
                self.arrCurrentOrderList.remove(at: index)
            }
        }else if orderType == OrderType.PastOrder.rawValue{
            if let index = self.arrPastOrdersList[listAt].orders!.firstIndex(where: {$0.id == objOrder.id}) {
                self.arrPastOrdersList.remove(at: index)
            }
        }
    }
    
    //Left to Modify
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


