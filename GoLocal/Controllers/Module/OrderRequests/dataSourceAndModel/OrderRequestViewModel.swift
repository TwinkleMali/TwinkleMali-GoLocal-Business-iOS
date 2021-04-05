//
//  OrderRequestViewModel.swift
//  GoLocalDriver
//
//  Created by C110 on 15/01/21.
//

import Foundation
import UIKit

class OrderRequestViewModel {
    private var arrOrderRequest : [OrderRequests] = []
    private var selectedOrderIndex : Int = 0
    private var arrayProducts : [[String:Any]] = []
   
}
    
extension OrderRequestViewModel {
    
    func getSelectedOrderIndex() -> Int {
        return selectedOrderIndex
    }
    
    func setSelectedOrderIndex(index : Int) {
        selectedOrderIndex = index
    }
    
    func getRowCount() -> Int {
        return arrOrderRequest.count
    }
    
    func setOrderRequests(arrOrderRequest : [OrderRequests]){
        for objRequest in  arrOrderRequest{
            if self.arrOrderRequest.contains(where: { $0.orderDetails?.id == objRequest.orderDetails?.id })  == false{
                self.arrOrderRequest.append(objRequest)
                var productDic : [String : Any]
                for objproduct in (objRequest.orderDetails?.shopDetail?.products)! {
                    for objselItem in objproduct.selectedProducts! {
                        productDic = ["orderId":objRequest.orderDetails?.id ?? 0,
                                      "productId" : objproduct.id ?? 0,
                                      "productName":objproduct.productName ?? "",
                                      "quantity":objselItem.quantity ?? 0,
                                      "variationName":objselItem.variationName ?? "",
                                      "addons":objselItem.addons ?? []]
                        arrayProducts.append(productDic)
                    }
                }
            }
        }
    }
    func removeExistingRequests() {
        self.arrOrderRequest.removeAll()
        self.arrayProducts.removeAll()
    }
    func getOrderRequest(at : Int) -> OrderRequests{
        return arrOrderRequest[at]
    }
    
    func getOrderDetails(at :Int) -> OrderDetails {        
        return arrOrderRequest[at].orderDetails!
    }
    
    func getShopDetails(at :Int) -> ShopDetail {
        return (arrOrderRequest[at].orderDetails?.shopDetail)!
    }
    
    func getCustomerDetails(at :Int) -> CustomerDetails {
        return (arrOrderRequest[at].orderDetails?.customerDetails)!
    }
    
    func getBillingDetails(at :Int) -> BillingDetails {
        return (arrOrderRequest[at].orderDetails?.billingDetails)!
    }
    
    func getProductArray(orderId :Int) -> [[String:Any]] {
      let newArray =  arrayProducts.filter{$0["orderId"] as! Int == orderId}
      return newArray        
    }
    
    
//    func getProductDetails(productAt :Int) -> [String:Any] {
//        var arrProduct : [String:Any]  = [:]
//        let tempArray : [Products] = (arrOrderRequest[at].orderDetails?.shopDetail?.products)!
//        if tempArray.count > 0{
//            for objProduct in tempArray {
//                let selProducts : [SelectedProducts] = objProduct.selectedProducts!
//                if selProducts.count > 0{
//                    
//                    for _ in selProducts{
//                        arrProduct.append(objProduct)
//                    }
//                }else {
//                    arrProduct.append(objProduct)
//                }
//            }
//        }
//        return arrProduct[productAt].selectedProducts?[productAt]
//    }
    
    
    
//    func getCustomerDetails(at :Int) -> OrderCustomerDetails {
//        return arrOrders[at].customerDetails!
//    }
//    func getProductDetails(orderAt :Int,productAt: Int) -> OrderProducts? {
//        return arrOrders[orderAt].shopDetail?.products?[productAt]
//    }
//    func getProductsCount(at :Int) -> OrderCustomerDetails {
//        return arrOrders[at].customerDetails!
//    }
//    func getNotificationTime(at: Int) -> String {
//        return arrOrders[at].createdAt ?? ""
//    }
//    func getCategoryImage(at :Int) -> UIImage {
//        let name = ((availableCategories[at].seviceCategory ?? "").replacingOccurrences(of: " ", with: "")).replacingOccurrences(of: "/", with: "").lowercased()
//        return UIImage(named: name) ?? #imageLiteral(resourceName: "app_logo")
//    }
    
    func removeAllRequest(){
        self.arrOrderRequest.removeAll()
    }
    
    func removeRequest(objRequest : OrderRequests){
        if let index = self.arrOrderRequest.firstIndex(where: {$0.orderDetails?.id == objRequest.orderDetails?.id}) {
            self.arrOrderRequest.remove(at: index)
        }
    }
}


