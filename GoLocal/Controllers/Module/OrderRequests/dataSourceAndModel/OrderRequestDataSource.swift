//
//  OrderRequestDataSource.swift
//  GoLocalDriver
//
//  Created by C110 on 15/01/21.
//

import Foundation
import UIKit

class OrderRequestDataSource: NSObject {
    //MARK:- VARIABLES
    private let tableView : UITableView
    private let viewModel: OrderRequestViewModel
    private let viewController: UIViewController
    private var orderRequestViewController : OrderRequestViewController? {
        get{
            viewController as? OrderRequestViewController
        }
    }
    let TIMER_VALUE_3_MIN = 180

    //MARK: - INIT
    init(tableView: UITableView,viewModel: OrderRequestViewModel , viewController: UIViewController) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.viewController = viewController
        tableView.register("PastOrdersTVCell")
        tableView.register("RequestDetailsOrderTVCell")
        tableView.register("OrderButtonTVCell")
    }
}

extension OrderRequestDataSource: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.viewModel.getRowCount() > 0 {
            tableView.isHidden = false
            orderRequestViewController?.lblNoMsg.isHidden = true
        }else {
            tableView.isHidden = true
            orderRequestViewController?.lblNoMsg.isHidden = false
        }
        return viewModel.getRowCount()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PastOrdersTVCell") as? PastOrdersTVCell{
            cell.vwTimer.isHidden = false
            cell.lbltimerDec.isHidden = false
            cell.mainView.topRoundCorner()
//            cell.mainView.addLeftBorder(with:#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), andWidth: 1)
//            cell.mainView.addRightBorder(with:#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), andWidth: 1)
//            cell.mainView.addTopBorder(with: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), andWidth: 1)
            addDashedBorder(withColor: .gray, view: cell.imgDottedLine)
            cell.layoutIfNeeded()
            if viewModel.getRowCount() > 0{
                let objOrderDetail = self.viewModel.getOrderDetails(at: section)
                let objCustomerDetail : CustomerDetails = self.viewModel.getCustomerDetails(at: section)
                if objCustomerDetail.name != ""{
                    cell.lblUserName.text = "\(objCustomerDetail.name ?? "") \(objCustomerDetail.lname ?? "")"
                }else if objCustomerDetail.username != ""{
                    cell.lblUserName.text = "\(objCustomerDetail.username ?? "")"
                }else {
                    let name = objCustomerDetail.email?.components(separatedBy: "@")
                    cell.lblUserName.text = "\(name?[0] ?? "")"
                }
                cell.lblDeliveryAddress.text = objOrderDetail.deliveryAddress
                cell.ratingView.rating = Double(objCustomerDetail.rating ?? 0)
                cell.lblTime.timeFormat = "mm:ss"
                cell.lblTime.timerType = MZTimerLabelTypeTimer
                cell.lblTime.delegate =  self
                cell.lblTime.tag = section
                cell.orderRequestTime = getSecondsBetweenDates(date1: Date(), date2: serverToLocal(date: objOrderDetail.sentShopRequestAt!)!, orderTimerValue: Double(viewModel.getOrderRequest(at: section).orderTimerValue!))
                cell.lblTime.addTimeCounted(byTime: TimeInterval(cell.orderRequestTime))
                cell.lblTime.start()
//                cell.lblOrderId.text = "Order ID : #\(objOrderDetail.orderUniqueId ?? "")"
                print("timer value : \(cell.orderRequestTime)")
            }
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderButtonTVCell") as? OrderButtonTVCell{
            cell.lblOrderDescription.isHidden = true
            cell.vwDot.isHidden = true
            cell.btnOrderStatus.isHidden = true
            cell.stView.isHidden = false
            cell.heightvw.constant = 50
            cell.subView.isHidden = false
            cell.widhtDetailButton.constant = 90
            cell.btnOrderDetail.isHidden = false
            cell.mainView.bottonRoundCorner()
//            cell.mainView.addLeftBorder(with:#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), andWidth: 1)
//            cell.mainView.addRightBorder(with:#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), andWidth: 1)
//            cell.mainView.addBottomBorder(with:#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), andWidth: 1)
            if viewModel.getRowCount() > 0{
            cell.lblOrderTotal.text = "\(CURRENCY_SYMBOL)\(self.viewModel.getOrderDetails(at: section).orderTotalAmount ?? 0)"
            cell.lblRequestedTime.text = "Requested Time : \(self.viewModel.getOrderDetails(at: section).sentShopRequestAt ?? "")"
            cell.btnAccept.tag = section
            cell.btnReject.tag = section
            cell.btnOrderDetail.tag = section
            cell.lblOrderId.text = "Order ID : #\(self.viewModel.getOrderDetails(at: section).orderUniqueId ?? "")"
//            cell.lblUserComment.text = "User Comment : No Comments"
            cell.btnOrderDetail.addTarget(self.orderRequestViewController, action: #selector(self.orderRequestViewController?.actionOrderDetail(_:)),for: .touchUpInside)
            cell.btnReject.addTarget(self.orderRequestViewController, action: #selector(self.orderRequestViewController?.actionRejectRequest(_:)), for: .touchUpInside)
            cell.btnAccept.addTarget(self.orderRequestViewController, action: #selector(self.orderRequestViewController?.actionAcceptRequest(_:)), for: .touchUpInside)
            }
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getProductArray(orderId: self.viewModel.getOrderDetails(at: section).id ?? 0).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RequestDetailsOrderTVCell") as? RequestDetailsOrderTVCell{
            cell.selectionStyle = .none
            let objProduct : [String:Any] = self.viewModel.getProductArray(orderId: self.viewModel.getOrderDetails(at: indexPath.section).id ?? 0)[indexPath.row]
            cell.lblOrderName.text = "\(objProduct["productName"].asStringOrEmpty())"
            cell.lblQty.text = "Qty : \(objProduct["quantity"].asStringOrEmpty())"
            let addons = objProduct["addons"] as! [Addons]
            if addons.count > 0{
                var strAddOns : String = ""
                for objAddons in addons {
                    strAddOns.append(",\(objAddons.addonName ?? "")")
                }
                cell.lblOrderDescription.text = "\(objProduct["variationName"].asStringOrEmpty()) - \(strAddOns))"
            }else {
                cell.lblOrderDescription.text = "\(objProduct["variationName"].asStringOrEmpty())"
            }
            return cell
        }
        return UITableViewCell()
    }
}


extension OrderRequestDataSource : MZTimerLabelDelegate {
    func timerLabel(_ timerLabel: MZTimerLabel!, finshedCountDownTimerWithTime countTime: TimeInterval) {
        if APP_DELEGATE?.arrOrderRequestMain.contains(where: { $0.orderDetails?.id == viewModel.getOrderRequest(at: timerLabel.tag).orderDetails?.id }) == true {
            print("Order Request Time out on Request screen for \(viewModel.getOrderRequest(at: timerLabel.tag).orderId ?? 0)")
            let dic = ["user_id" : USER_DETAILS?.id ?? 0,
                       "customer_id" : viewModel.getOrderRequest(at: timerLabel.tag).orderDetails?.customerDetails?.id ?? 0,
                       "order_id" : viewModel.getOrderRequest(at: timerLabel.tag).orderDetails?.id ?? 0,
                       "shop_id" : USER_DETAILS?.shopId ?? 0,
                       "reject_reason" : "No delivery driver available.",
                       "is_auto_rejection" : true] as [String : Any]
            print("reject dic : \(dic)")
            socketRejectOrderRequest(dictionary: dic)        
        }
    }
     
}

