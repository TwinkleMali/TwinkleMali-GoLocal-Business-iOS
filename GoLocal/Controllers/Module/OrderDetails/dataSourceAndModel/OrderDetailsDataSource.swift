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
        tableView.register("OrderDetailDriverTVCell")
    }
}

extension OrderDetailsDataSource: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.isOrderAvailabe() ? OrderDetailsField.total.rawValue : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !viewModel.isOrderAvailabe() {
            return 0
        }
        if section == OrderDetailsField.requestDetail.rawValue{
//            var count = 0
//            if let products = viewModel.getOrderDetail().shopDetail?.products {
//                for product in products {
//                    count += product.selectedProducts?.count ?? 0
//                }
//            }
//            return count //viewModel.getOrderDetail().shopDetail?.products?.count ?? 0
            return viewModel.getProductsCount()
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
    switch section {
    case OrderDetailsField.requestDetail.rawValue:
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PastOrdersTVCell") as? PastOrdersTVCell{
            cell.vwTimer.isHidden = false
            cell.lbltimerDec.isHidden = false
            cell.mainView.topRoundCorner()
            cell.leftPadding.constant = 5
            cell.rightPadding.constant = 5
            cell.mainView.clipsToBounds = true
            cell.mainView.shadowColor = .clear
            cell.mainView.shadowOpacity = 0.0
                
            addDashedBorder(withColor: .gray, view: cell.imgDottedLine)
            cell.layoutIfNeeded()
            
            let objCustomerDetail : CustomerDetails = (self.viewModel.getOrderDetail().customerDetails)!
            if let orderId = self.viewModel.getOrderDetail().orderUniqueId {
                cell.lblOrderId.text = "Order ID : #\(orderId)"
                cell.heightLabelOrderId.constant = 20
            }
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
        
    case OrderDetailsField.deliveryType.rawValue,
         OrderDetailsField.note.rawValue,
         OrderDetailsField.billDetails.rawValue:
        let saprater = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 1))
        saprater.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        return saprater
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
            return nil
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderButtonTVCell") as? OrderButtonTVCell{
//                cell.lblOrderDescription.isHidden = true
//                cell.vwDot.isHidden = true
//                cell.btnOrderStatus.isHidden = true
//                cell.stView.isHidden = true
//                cell.heightvw.constant = 0
//                cell.subView.isHidden = true
//                cell.lblOrderId.text = ""
//                cell.lblOrderTotal.text = "\(CURRENCY_SYMBOL)\(self.viewModel.getOrderDetail().orderTotalAmount ?? 0)"
//                cell.leftPadding.constant = 5
//                cell.rightPadding.constant = 5
//                cell.buttonBottomConstraints.priority = UILayoutPriority(rawValue: 1)
//                cell.mainView.clipsToBounds = true
//                cell.mainView.shadowColor = .clear
//                cell.mainView.shadowOpacity = 0.0
//                return cell
//            }
            
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
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        switch section {
            case OrderDetailsField.requestDetail.rawValue:
                return 120
            default:
                return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == OrderDetailsField.requestDetail.rawValue{
            return UITableView.automaticDimension
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == OrderDetailsField.requestDetail.rawValue{
            return 1
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        switch indexPath.section {
            case OrderDetailsField.requestDetail.rawValue:
                return UITableView.automaticDimension
            
        case OrderDetailsField.orderAmount.rawValue:
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
                    if viewModel.getOrderDetail().orderStatus == OrderStatus.Confirmed.rawValue ||
                        viewModel.getOrderDetail().orderStatus == OrderStatus.OrderLeft.rawValue ||
                        viewModel.getOrderDetail().orderStatus == OrderStatus.Delivered.rawValue {
                        return UITableView.automaticDimension
                    }else {
                        return 0
                    }
                }
            
            default:
                return UITableView.automaticDimension
        }
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case OrderDetailsField.requestDetail.rawValue:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "RequestDetailsOrderTVCell") as? RequestDetailsOrderTVCell{
                    cell.selectionStyle = .none
                    var varient = ""
                    var addons = ""
                    let product = self.viewModel.getProduct(atPos: indexPath.row) //getProductDetails(productAt: indexPath.row) {
                        if let selected = product.products?.selectedProducts?[product.index] {
                            varient  = selected.variationName ?? ""
                            addons = selected.addons?.map({$0.addonName ?? ""}).joined(separator: ",") ?? ""
                            cell.lblQty.text = "Qty : \(selected.quantity ?? 0)"
                        }
                    
                    cell.lblOrderName.text = product.products?.productName ?? ""
                        //self.viewModel.getProductDetails(productAt: indexPath.row)?.productName
                    
                    cell.lblOrderDescription.text = varient
                    if addons.count > 0 {
                        cell.lblOrderDescription.text = "\(varient) - \(addons)"
                    }
                        //self.viewModel.getProductDetails(productAt: indexPath.row)?.productDescription
                    
                    cell.leftPaddingConst.constant = 5
                    cell.rightPaddingConst.constant = 5
                    cell.mainView.clipsToBounds = true
                    cell.mainView.shadowColor = .clear
                    cell.mainView.shadowOpacity = 0.0
                    return cell
                }
        case OrderDetailsField.orderAmount.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsTVCell") as? OrderDetailsTVCell{
                cell.selectionStyle = .none
                cell.lblTitle.text = "Amount"
                cell.lblValue.text = (self.viewModel.getOrderDetail().billingDetails?.grandTotal ?? 0.0).getAmountInString()
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
                cell.lblItemTotal.text = (self.viewModel.getOrderDetail().billingDetails?.totalItemsPrice ?? 0.0).getAmountInString()
                
                cell.lblServiceCharge.text = (self.viewModel.getOrderDetail().billingDetails?.serviceCharge ?? 0).getAmountInString()
                
                if (self.viewModel.getOrderDetail().billingDetails?.deliveryCharge ?? 0) > 0{
                    cell.lblDeliveryFee.text = (self.viewModel.getOrderDetail().billingDetails?.deliveryCharge ?? 0).getAmountInString()
                }else {
                    cell.lblDeliveryFee.text = "FREE"
                }
                
                if (self.viewModel.getOrderDetail().billingDetails?.serviceCharge ?? 0) > 0{
                    cell.lblShoppingFeeTotal.text = (self.viewModel.getOrderDetail().billingDetails?.serviceCharge ?? 0).getAmountInString()
                }else {
                    cell.lblShoppingFeeTotal.text = "\(CURRENCY_SYMBOL)0.0"
                }
                
                if (self.viewModel.getOrderDetail().billingDetails?.offerDiscountPrice ?? 0) > 0{
                    cell.lblOrderDiscount.text = (self.viewModel.getOrderDetail().billingDetails?.offerDiscountPrice ?? 0).getAmountInString()
                }else {
                    cell.lblOrderDiscount.text = "\(CURRENCY_SYMBOL)0.0"
                }
                
                if (self.viewModel.getOrderDetail().billingDetails?.offerDiscountPrice ?? 0) > 0{
                    cell.lblCouponDiscount.text = (self.viewModel.getOrderDetail().billingDetails?.offerDiscountPrice ?? 0).getAmountInString()
                }else {
                    cell.lblCouponDiscount.text = "\(CURRENCY_SYMBOL)0.0"
                }
               
                cell.lblTotal.text = (self.viewModel.getOrderDetail().billingDetails?.grandTotal ?? 0.0).getAmountInString()
                return cell
            }
            
        case OrderDetailsField.deliveryPerson.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailDriverTVCell") as? BusinessDriverTVCell{
                cell.selectionStyle = .none
//                if let driver =  objOrder.driverDetails {
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
                    cell.lblDriverName.text = "\(strname)"
                    if (viewModel.getOrderDetail().driverDetails?.phone ?? "").isEmpty {
                        cell.lblDriverNumber.text = "No Number"
                    } else {
                        cell.lblDriverNumber.text = "+\(viewModel.getOrderDetail().driverDetails?.phonecode ?? 0) \(viewModel.getOrderDetail().driverDetails?.phone ?? "")"
                    }
                    cell.btnEdit.setImage(UIImage(named: ""), for: .normal)
                    cell.btnEdit.setTitle("View on Map", for: .normal)
                    cell.btnEdit.layer.cornerRadius = 7
                    cell.btnEdit.layer.borderWidth = 1
                    cell.btnEdit.layer.borderColor = GreenCGColor
                    cell.btnEdit.addTarget(self.orderDetailsViewController, action: #selector(self.orderDetailsViewController?.actionMarkOrderLeft(_:)),for: .touchUpInside)
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

