//
//  OrderDataSource.swift
//  GoLocalDriver
//
//  Created by C100-142 on 15/01/21.
//

import Foundation
import UIKit

class OrderDataSource: NSObject {
    //MARK:- VARIABLES
    private let tableView : UITableView
    private let viewModel: OrderViewModel
    private let viewController: UIViewController
    private var orderViewController : OrderViewController? {
        get{
            viewController as? OrderViewController
        }
    }
    
    //MARK: - INIT
    init(tableView: UITableView,viewModel: OrderViewModel , viewController: UIViewController) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.viewController = viewController
        tableView.register("PastOrdersTVCell")
        tableView.register("RequestDetailsOrderTVCell")
        tableView.register("OrderButtonTVCell")
    }
}

extension OrderDataSource: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.getOrderRowCount(orderType: orderViewController?.selOrder ?? 0) > 0{
            tableView.isHidden = false           
            orderViewController?.lblNoMsg.isHidden = true
        }else {
            tableView.isHidden = true
            orderViewController?.lblNoMsg.isHidden = false
        }
        return viewModel.getOrderRowCount(orderType: orderViewController?.selOrder ?? 0)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PastOrdersTVCell") as? PastOrdersTVCell{
            if orderViewController?.selOrder == OrderType.CurrentOrder.rawValue{
                //current
                cell.ratingView.isHidden = true
//                cell.btnDetails.isHidden = true
                cell.vwTimer.isHidden = false
                cell.lbltimerDec.isHidden = false
                cell.lblDriverName.isHidden = false
                cell.lblTime.text = "00:00"
            }else if orderViewController?.selOrder == OrderType.PastOrder.rawValue{
                //past orders
                cell.vwTimer.isHidden = true
                cell.lbltimerDec.isHidden = true
                cell.lblDriverName.isHidden = true
            }
            addDashedBorder(withColor: .gray, view: cell.imgDottedLine)
            cell.layoutIfNeeded()
            cell.mainView.topRoundCorner()
//            cell.mainView.addLeftBorder(with:#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), andWidth: 1)
//            cell.mainView.addRightBorder(with:#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), andWidth: 1)
//            cell.mainView.addTopBorder(with: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), andWidth: 1)
            let objOrderDetail = self.viewModel.getOrder(at: section, orderType: orderViewController?.selOrder ?? 0)
            let objCustomerDetail : CustomerDetails = self.viewModel.getCustomerDetails(at: section,orderType: orderViewController?.selOrder ?? 0)
            
                if objCustomerDetail.name != nil && objCustomerDetail.name != ""{
                    cell.lblUserName.text = "\(objCustomerDetail.name ?? "") \(objCustomerDetail.lname ?? "")"
                }else if objCustomerDetail.username != nil && objCustomerDetail.username != ""{
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
                cell.orderRequestTime = getSecondsBetweenDates(date1: Date(), date2: serverToLocal(date: objOrderDetail.sentShopRequestAt!)!, orderTimerValue: Double(objOrderDetail.shopOrderTimerValue ?? 0))
                cell.lblTime.addTimeCounted(byTime: TimeInterval(cell.orderRequestTime))
                cell.lblTime.start()
                print("timer value : \(cell.orderRequestTime)")
                cell.btnView.addTarget(self.orderViewController, action: #selector(self.orderViewController?.actionOrderDetail(_:)),for: .touchUpInside)
                
                return cell
        }
        return UITableView()
            
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderButtonTVCell") as? OrderButtonTVCell{
            cell.stView.isHidden = true
            cell.subView.isHidden = false
            cell.btnOrderDetail.isHidden = true
            cell.heightvw.constant = 50
            cell.widhtDetailButton.constant = 0
            cell.btnOrderDetail.isHidden = true
            cell.btnOrderStatus.tag = section
            cell.btnView.tag = section
            cell.mainView.bottonRoundCorner()
            cell.lblOrderTotal.text = "\(CURRENCY_SYMBOL)\(self.viewModel.getOrder(at: section, orderType: orderViewController?.selOrder ?? 0).orderTotalAmount ?? 0)"
            let date : String = self.viewModel.getOrder(at: section, orderType: orderViewController?.selOrder ?? 0).sentShopRequestAt ?? ""
            cell.lblRequestedTime.text = "Requested Time : \(date.toDateString(outputFormat: REQUESTED_TIME_FORMATE) ?? "-")"
            cell.lblOrderId.text = "Order ID : #\(self.viewModel.getOrder(at: section, orderType: orderViewController?.selOrder ?? 0).orderUniqueId ?? "")"
            let date1 : String = self.viewModel.getOrder(at: section, orderType: orderViewController?.selOrder ?? 0).sentShopRequestAt ?? ""
            cell.btnView.addTarget(self.orderViewController, action: #selector(self.orderViewController?.actionOrderDetail(_:)),for: .touchUpInside)
           
            cell.btnOrderStatus.isHidden = true
            cell.lblOrderDescription.isHidden = true
            cell.vwDot.isHidden = true
            if orderViewController?.selOrder == OrderType.PastOrder.rawValue{              
                cell.lblOrderDescription.isHidden = false
                cell.vwDot.isHidden = false
                let strStatus = self.viewModel.getOrder(at: section, orderType: orderViewController?.selOrder ?? 0).orderStatus.asStringOrEmpty()
                if strStatus == OrderStatus.OrderLeft.rawValue {
                    cell.btnOrderStatus.isHidden = false
                    cell.btnOrderStatus.setTitle("Order has Left Restaurant", for: .normal)
                    cell.btnOrderStatus.addTarget(self.orderViewController, action: #selector(self.orderViewController?.actionMarkOrderLeft(_:)),for: .touchUpInside)
                }
                cell.lblOrderDescription.text = "\(strStatus) on \(date1.toDateString(outputFormat: REQUESTED_TIME_FORMATE) ?? "")"
            }
           
            return cell
        }
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if orderViewController?.selOrder == OrderType.CurrentOrder.rawValue{
            return 180
        }else if orderViewController?.selOrder == OrderType.PastOrder.rawValue{
            return 200
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if orderViewController?.selOrder == OrderType.CurrentOrder.rawValue{
            return 90
        }else if orderViewController?.selOrder == OrderType.PastOrder.rawValue{
            return 90
        }
        return 0
    }    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getProductArray(orderId: (self.viewModel.getOrder(at: section,orderType: orderViewController!.selOrder).id ?? 0), orderType: orderViewController?.selOrder ?? 0).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RequestDetailsOrderTVCell") as? RequestDetailsOrderTVCell{
            cell.selectionStyle = .none
            let objProduct : [String:Any] = self.viewModel.getProductArray(orderId: (self.viewModel.getOrder(at: indexPath.section,orderType: orderViewController!.selOrder).id ?? 0), orderType: orderViewController?.selOrder ?? 0)[indexPath.row]
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
           
            cell.btnView.addTarget(self.orderViewController, action: #selector(self.orderViewController?.actionOrderDetail(_:)),for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = OrderDetailsViewController(nibName: "OrderDetailsViewController", bundle: .main)
        vc.isOrderRequest = false
        self.orderViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView : UIScrollView) {
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            // Change 10.0 to adjust the distance from bottom
            if maximumOffset - currentOffset <= 10.0{
                if !self.orderViewController!.isLoadMore{
                    self.orderViewController?.indicatorView.isHidden = false
                    self.orderViewController?.activityIndicator.startAnimating()
                    self.orderViewController?.loadMoreRequest()
                    self.orderViewController?.isLoadMore = true
                }
            }
    }
}

extension OrderDataSource : MZTimerLabelDelegate {
    func timerLabel(_ timerLabel: MZTimerLabel!, finshedCountDownTimerWithTime countTime: TimeInterval) {
    }
     
}


