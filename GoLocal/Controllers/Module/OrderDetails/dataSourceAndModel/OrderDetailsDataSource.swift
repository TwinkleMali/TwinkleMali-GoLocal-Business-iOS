//
//  OrderDetailsDataSource.swift
//  GoLocalDriver
//
//  Created by C110 on 15/01/21.
//

import Foundation
import UIKit

class OrderDetailsDataSource: NSObject {
    //MARK:- VARIABLES
    private let tableView : UITableView
    private let viewModel: OrderDetailsViewModel
    private let viewController: UIViewController
    private var orderDetailsViewController : OrderDetailsViewController? {
        get{
            viewController as? OrderDetailsViewController
        }
    }
    var isRequest : Bool = false
   
    
    //MARK: - INIT
    init(tableView: UITableView,viewModel: OrderDetailsViewModel , viewController: UIViewController, isRequest : Bool) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.viewController = viewController
        self.isRequest = isRequest
        tableView.register("PastOrdersTVCell")
        tableView.register("RequestDetailsOrderTVCell")
        tableView.register("OrderButtonTVCell")
        tableView.register("OrderDetailsTVCell")
        tableView.register("OrderBillDetailsTVCell")
    }
}

extension OrderDetailsDataSource: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return OrderDetailsField.total.rawValue
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        switch section {
        case OrderDetailsField.requestDetail.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PastOrdersTVCell") as? PastOrdersTVCell{
                cell.vwTimer.isHidden = false
                cell.lbltimerDec.isHidden = false
                cell.mainView.topRoundCorner()
                addDashedBorder(withColor: .gray, view: cell.imgDottedLine)
                cell.layoutIfNeeded()
              
                let objCustomerDetail : CustomerDetails = (self.viewModel.getOrderDetail().customerDetails)!
                if objCustomerDetail.name != ""{
                    cell.lblUserName.text = "\(objCustomerDetail.name ?? "") \(objCustomerDetail.lname ?? "")"
                }else if objCustomerDetail.username != ""{
                    cell.lblUserName.text = "\(objCustomerDetail.username ?? "")"
                }else {
                    let name = objCustomerDetail.email?.components(separatedBy: "@")
                    cell.lblUserName.text = "\(name?[0] ?? "")"
                }
                cell.lblUserName.text = "\(objCustomerDetail.name ?? "") \(objCustomerDetail.lname ?? "")"
                cell.lblDeliveryAddress.text = self.viewModel.getOrderDetail().deliveryAddress
                cell.ratingView.rating = Double(objCustomerDetail.rating ?? 0)
                cell.lblTime.timeFormat = "mm:ss"
                cell.lblTime.timerType = MZTimerLabelTypeTimer
                cell.lblTime.delegate =  self
                if isRequest{
                    cell.orderRequestTime = getSecondsBetweenDates(date1: Date(), date2: serverToLocal(date: (self.viewModel.getOrderDetails().orderDetails?.sentShopRequestAt!)!)!, orderTimerValue: Double(self.viewModel.getOrderDetails().orderTimerValue!))
                    cell.lblTime.addTimeCounted(byTime: TimeInterval(cell.orderRequestTime))
                }else {
                    if self.viewModel.getOrderDetail().orderStatus == OrderStatus.Confirmed.rawValue{
                        cell.lblTime.isHidden = true
                        cell.lbltimerDec.isHidden = true
                        cell.vwTimer.isHidden = true
                    }else{
                        cell.lblTime.isHidden = false
                        cell.lbltimerDec.isHidden = false
                        cell.vwTimer.isHidden = false
                        if  self.viewModel.getOrderDetail().shopOrderTimerValue != nil &&  self.viewModel.getOrderDetail().sentShopRequestAt != nil {
                            cell.orderRequestTime = getSecondsBetweenDates(date1: Date(), date2: serverToLocal(date: self.viewModel.getOrderDetail().sentShopRequestAt!)!, orderTimerValue: Double(self.viewModel.getOrderDetail().shopOrderTimerValue!))
                            cell.lblTime.addTimeCounted(byTime: TimeInterval(cell.orderRequestTime))
                        }
                    
                    }
                }
                cell.lblTime.start()
                return cell
            }
            break
            
        case OrderDetailsField.deliveryType.rawValue:
            return nil
            
        case OrderDetailsField.note.rawValue:
            return nil
            
        case OrderDetailsField.billDetails.rawValue:
            return nil
            
        case OrderDetailsField.deliveryPerson.rawValue:
            return nil
            
        default:
            return nil
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        switch section {
        case OrderDetailsField.requestDetail.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderButtonTVCell") as? OrderButtonTVCell{
                cell.lblOrderDescription.isHidden = true
                cell.vwDot.isHidden = true
                cell.btnOrderStatus.isHidden = true
                cell.stView.isHidden = true
                cell.heightvw.constant = 0
                cell.subView.isHidden = true
                cell.lblOrderTotal.text = "\(CURRENCY_SYMBOL)\(self.viewModel.getOrderDetail().orderTotalAmount ?? 0)"
                return cell
            }
            
        case OrderDetailsField.deliveryType.rawValue:
            return nil
            
        case OrderDetailsField.note.rawValue:
            return nil
            
        case OrderDetailsField.billDetails.rawValue:
            return nil
            
        case OrderDetailsField.deliveryPerson.rawValue:
            return nil
            
        default:
            return nil
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == OrderDetailsField.requestDetail.rawValue{
            return viewModel.getOrderDetail().shopDetail?.products?.count ?? 0
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == OrderDetailsField.requestDetail.rawValue{
            return UITableView.automaticDimension
        }else{
            return 0.01
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == OrderDetailsField.requestDetail.rawValue{
            return 100
        }else{
            return 0.01
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        switch indexPath.section {
            case OrderDetailsField.requestDetail.rawValue:
                return UITableView.automaticDimension
            
            case OrderDetailsField.deliveryType.rawValue:
                return UITableView.automaticDimension
            
            case OrderDetailsField.note.rawValue:
                if isRequest {
                    return 0
                }else {
                    return 0
                }
            
            case OrderDetailsField.billDetails.rawValue:
                return UITableView.automaticDimension
            
            case OrderDetailsField.deliveryPerson.rawValue:
                if isRequest {
                    return 0
                }else {
//                    if viewModel.getOrderDetail().
                    return 0
//                    return UITableView.automaticDimension
                }
            
            default:
                return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        switch section {
            case OrderDetailsField.requestDetail.rawValue:
                return 100
                
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case OrderDetailsField.requestDetail.rawValue:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "RequestDetailsOrderTVCell") as? RequestDetailsOrderTVCell{
                    cell.selectionStyle = .none
                    cell.lblOrderName.text = self.viewModel.getProductDetails(productAt: indexPath.row)?.productName
                    cell.lblOrderDescription.text = self.viewModel.getProductDetails(productAt: indexPath.row)?.productDescription
                    return cell
                }
            
        case OrderDetailsField.deliveryType.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsTVCell") as? OrderDetailsTVCell{
                cell.selectionStyle = .none
                cell.lblTitle.text = "Delivery Type"
                cell.lblValue.text = self.viewModel.getOrderDetail().deliveryType
                return cell
            }
            
        case OrderDetailsField.note.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsTVCell") as? OrderDetailsTVCell{
                cell.selectionStyle = .none
                cell.lblTitle.text = "Note"
                return cell
            }
            
        case OrderDetailsField.billDetails.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderBillDetailsTVCell") as? OrderDetailsTVCell{
                cell.selectionStyle = .none
                cell.lblItemTotal.text = "\(CURRENCY_SYMBOL)\(self.viewModel.getOrderDetail().billingDetails?.totalItemsPrice ?? 0.0)"
                
                cell.lblServiceCharge.text = "\(CURRENCY_SYMBOL)\(self.viewModel.getOrderDetail().billingDetails?.serviceCharge ?? 0)"
                
                if (self.viewModel.getOrderDetail().billingDetails?.deliveryCharge ?? 0) > 0{
                    cell.lblDeliveryFee.text = "\(CURRENCY_SYMBOL)\(self.viewModel.getOrderDetail().billingDetails?.deliveryCharge ?? 0)"
                }else {
                    cell.lblDeliveryFee.text = "FREE"
                }
                
                if (self.viewModel.getOrderDetail().billingDetails?.serviceCharge ?? 0) > 0{
                    cell.lblShoppingFeeTotal.text = "\(CURRENCY_SYMBOL)\(self.viewModel.getOrderDetail().billingDetails?.serviceCharge ?? 0)"
                }else {
                    cell.lblShoppingFeeTotal.text = "\(CURRENCY_SYMBOL)0.0"
                }
                
                if (self.viewModel.getOrderDetail().billingDetails?.offerDiscountPrice ?? 0) > 0{
                    cell.lblOrderDiscount.text = "\(CURRENCY_SYMBOL)\(self.viewModel.getOrderDetail().billingDetails?.offerDiscountPrice ?? 0)"
                }else {
                    cell.lblOrderDiscount.text = "\(CURRENCY_SYMBOL)0.0"
                }
                
                if (self.viewModel.getOrderDetail().billingDetails?.offerDiscountPrice ?? 0) > 0{
                    cell.lblCouponDiscount.text = "\(CURRENCY_SYMBOL)\(self.viewModel.getOrderDetail().billingDetails?.offerDiscountPrice ?? 0)"
                }else {
                    cell.lblCouponDiscount.text = "\(CURRENCY_SYMBOL)0.0"
                }
               
                cell.lblTotal.text = "\(CURRENCY_SYMBOL)\(self.viewModel.getOrderDetail().billingDetails?.grandTotal ?? 0.0)"
                return cell
            }
            
        case OrderDetailsField.deliveryPerson.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsTVCell") as? OrderDetailsTVCell{
                cell.selectionStyle = .none
                if let driver =  viewModel.getOrderDetail().driverDetails {
                    cell.lblTitle.text = "Delivery Person"
                    var strname : String = ""
                    if driver.name != nil && driver.name!.length > 0 {
                        strname = driver.name.asStringOrEmpty()
                        if driver.lname != nil && driver.lname!.length > 0{
                            strname = "\(strname) \(driver.lname ?? "")"
                        }
                    }else if driver.username != nil && driver.username!.length > 0{
                        strname = "\(driver.username ?? "")"
                    }else {
                        let name = driver.email?.components(separatedBy: "@")
                        strname = "\(name?[0] ?? "")"
                    }
                    
//                    cell.lblUserName.text = "\(strname)"
                    cell.lblValue.text = "\(strname)"
                }                
                return cell
            }
        
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
}


extension OrderDetailsDataSource : MZTimerLabelDelegate {
    func timerLabel(_ timerLabel: MZTimerLabel!, finshedCountDownTimerWithTime countTime: TimeInterval){
        print("arrOrderRequestMain Count : \(APP_DELEGATE?.arrOrderRequestMain.count ?? 0)")
        if APP_DELEGATE?.arrOrderRequestMain.contains(where: { $0.orderDetails?.id == viewModel.getOrderDetail().id}) == true {
        print("Order Request Time out on detail screen for \(viewModel.getOrderDetails().orderId ?? 0)")
        
        let dic = ["user_id" : USER_DETAILS?.id ?? 0,
                   "customer_id" : viewModel.getOrderDetail().customerDetails?.id ?? 0,
                   "order_id" : viewModel.getOrderDetail().id ?? 0,
                   "shop_id" : USER_DETAILS?.shopId ?? 0,
                   "reject_reason" : "No delivery driver available.",
                   "is_auto_rejection" : true] as [String : Any]
        print("reject dic : \(dic)")
        socketRejectOrderRequest(dictionary: dic)
        }
    }

}

