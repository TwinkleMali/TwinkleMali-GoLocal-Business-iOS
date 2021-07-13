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
        tableView.register("OrderListTVCell")
        tableView.register("PastOrdersTVCell")
        tableView.register("RequestDetailsOrderTVCell")
        tableView.register("OrderButtonTVCell")
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        
    }
}

extension OrderDataSource: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        print("@TBL : ",tableView.tag)
        if tableView == self.tableView{
            print("@Main")
            //return 1
            if viewModel.isOrderAvailable(forType: orderViewController?.selOrder ?? 0) {
                return self.viewModel.getOrderListCount(orderType: orderViewController?.selOrder ?? 0)
            } else {
                return 0
            }
        }else {
            print("@Child")
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView == self.tableView{
            //return self.viewModel.getOrderListCount(orderType: orderViewController?.selOrder ?? 0)
        let selType = orderViewController?.selOrder ?? 0
        let isMerged = viewModel.isOrderMerged(listAt: section, orderType: selType)
        var firstOrderProductCount = 0
        var secondOrderProductCount = 0
        
        let objFirstOrderDetail = self.viewModel.getOrder(listAt: section, orderAt: 0, orderType: orderViewController?.selOrder ?? 0)
        var count = 0
        if let products = objFirstOrderDetail.shopDetail?.products{
            for product in products{
                count += product.selectedProducts?.count ?? 0
            }
        }
        firstOrderProductCount = count //objFirstOrderDetail.shopDetail?.products?.count ?? 0
        if firstOrderProductCount > 0 {
            firstOrderProductCount -= 1
        }
        
        if isMerged {
            let objSecondOrderDetail = self.viewModel.getOrder(listAt: section, orderAt: 1, orderType: orderViewController?.selOrder ?? 0)
            secondOrderProductCount = objSecondOrderDetail.shopDetail?.products?.count ?? 0
            if secondOrderProductCount > 0 {
                secondOrderProductCount -= 1
            }
            print("@#\(section) merged ORDER  : ",objSecondOrderDetail.orderUniqueId)
        } else {
            print("@#\(section) Simple ORDER  : ",objFirstOrderDetail.orderUniqueId)
        }
        print("@#\(section) ROW : ",isMerged ? (6 + firstOrderProductCount + secondOrderProductCount ) : (3 + firstOrderProductCount ))
        return isMerged ? (6 + firstOrderProductCount + secondOrderProductCount ) : (3 + firstOrderProductCount )
//        }
//        else {
//
//            let orderindex = tableView.tag
//            let subOrderindex = Int(tableView.accessibilityHint ?? "0") ?? 0
//            let currType = orderViewController?.selOrder ?? 0
//            let orderId = self.viewModel.getOrder(listAt: orderindex,
//                                                   orderAt: subOrderindex,
//                                                   orderType:currType).id ?? 0
//            return self.viewModel.getProductArray(orderId: orderId,
//                                                  orderType: orderViewController?.selOrder ?? 0).count
//        }

    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat{
        10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        10
    }
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView{
            return UITableView.automaticDimension
        }else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
       
            let section = indexPath.section
            let row = indexPath.row
            let currType = orderViewController?.selOrder ?? 0
            
            let isMerged = viewModel.isOrderMerged(listAt: section, orderType: currType)
            var firstOrderProductCount = 0
            var secondOrderProductCount = 0
            
            let selType = orderViewController?.selOrder ?? 0
            let objFirstOrderDetail = self.viewModel.getOrder(listAt: section, orderAt: 0, orderType: orderViewController?.selOrder ?? 0)
        var count = 0
        if let products = objFirstOrderDetail.shopDetail?.products{
            for product in products{
                count += product.selectedProducts?.count ?? 0
            }
        }
        firstOrderProductCount = count
        //firstOrderProductCount = objFirstOrderDetail.shopDetail?.products?.count ?? 0
            if isMerged {
                let objSecondOrderDetail = self.viewModel.getOrder(listAt: section, orderAt: 1, orderType: orderViewController?.selOrder ?? 0)
                secondOrderProductCount = objSecondOrderDetail.shopDetail?.products?.count ?? 0
            }
            var currCellType = 0
            var noOfOrder = 0
            if row == 0 {
                noOfOrder = 0
                currCellType = 0
            } else if row <= firstOrderProductCount{
                noOfOrder = 0
                currCellType = 1
            } else if (row == firstOrderProductCount + 1){
                noOfOrder = 0
                currCellType = 2
            } else if (isMerged && row == firstOrderProductCount + 2){
                noOfOrder = 1
                currCellType = 3
            } else if (isMerged && row <= (firstOrderProductCount + secondOrderProductCount + 2)){
                noOfOrder = 1
                currCellType = 4
            } else if (isMerged && row == (firstOrderProductCount + secondOrderProductCount + 3)){
                noOfOrder = 1
                currCellType = 5
            }
            
            
            
            switch currCellType {
            case 0,3:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "PastOrdersTVCell") as? PastOrdersTVCell{
                    cell.mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                    cell.mainView.clipsToBounds = false
                    cell.viewTopConstraints.constant = currCellType == 0 ? 10 : 0
                    cell.viewSecondOrder.isHidden = currCellType == 0
                    cell.heightSecondOrderView.constant = currCellType == 0 ? 0 : 30
                    if orderViewController?.selOrder == OrderType.CurrentOrder.rawValue{
                        //current
                        cell.ratingView.isHidden = true
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
                    //addDashedBorder(withColor: .gray, view: cell.imgDottedLine)
                    cell.imgDottedLine.createDottedLine(width: 0.5, color: UIColor.black.cgColor)
                    cell.layoutIfNeeded()
                    let objOrderDetail = self.viewModel.getOrder(listAt: section, orderAt: noOfOrder, orderType: orderViewController?.selOrder ?? 0)
                    let objCustomerDetail = self.viewModel.getCustomerDetails(listAt: section, orderAt: noOfOrder, orderType: orderViewController?.selOrder ?? 0)
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
                    cell.btnView.tag = row == 0 ? ((indexPath.section*100)+noOfOrder) : ((indexPath.section*100)+noOfOrder)
                    cell.btnView.addTarget(self.orderViewController, action: #selector(self.orderViewController?.actionOrderDetail(_:)),for: .touchUpInside)
                    
                    return cell
                }
                break
            case 1,4:

                if let cell = tableView.dequeueReusableCell(withIdentifier: "RequestDetailsOrderTVCell") as? RequestDetailsOrderTVCell{
                    cell.selectionStyle = .none
                    var productRow = 0
                    if currCellType == 1 {
                       productRow = row - 1
                    } else {
                        productRow = row - (firstOrderProductCount + 3)
                    }
                    let selType = orderViewController?.selOrder ?? 0
                    let objOrderDetail = self.viewModel.getOrder(listAt: section, orderAt: noOfOrder, orderType: orderViewController?.selOrder ?? 0)
                    
                    let arrobjProduct : [[String:Any]] = self.viewModel.getProductArray(orderId: objOrderDetail.id ?? 0,
                                                                                      orderType: selType)
                    if arrobjProduct.count > 0{
                        let objProduct : [String:Any] = arrobjProduct[productRow]
                        cell.leftPaddingConst.constant = 20
                        cell.rightPaddingConst.constant = 20
                        cell.lblOrderName.text = "\(objProduct["productName"].asStringOrEmpty())"
                        cell.lblQty.text = "Qty : \(objProduct["quantity"].asStringOrEmpty())"
                        let addons = objProduct["addons"] as! [Addons]
                        let addonName = addons.map({$0.addonName ?? ""}).joined(separator: ",")
                        
                        if addonName.count > 0{
                            cell.lblOrderDescription.text = "\(objProduct["variationName"].asStringOrEmpty()) - \(addonName)"
                        }else {
                            cell.lblOrderDescription.text = "\(objProduct["variationName"].asStringOrEmpty())"
                        }
                    }
                    cell.btnView.tag = (section*100)+noOfOrder
                    //cell.btnView.accessibilityValue = "\(tableView.tag)"
                    cell.btnView.addTarget(self.orderViewController, action: #selector(self.orderViewController?.actionOrderDetail(_:)),for: .touchUpInside)
                    return cell
                }
                break
            case 2,5:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderButtonTVCell") as? OrderButtonTVCell{
                    cell.stView.isHidden = true
                    cell.mainView.clipsToBounds = false
                    cell.subView.isHidden = false
                    cell.btnOrderDetail.isHidden = true
                    cell.heightvw.constant = 50
                    cell.widhtDetailButton.constant = 0
                    cell.btnOrderDetail.isHidden = true
                    
                    cell.btnOrderStatus.tag = (indexPath.section*100)+noOfOrder
                    cell.btnView.tag = (indexPath.section*100)+noOfOrder
                    
                    cell.buttonConstaints.constant = orderViewController?.selOrder ?? 1 == 1 ? 0 : 20
                    
                    cell.viewBottomConstraints.constant = currCellType == 2 ? (isMerged ? 0 : 10) : 10
                    print("@currCellType : ",currCellType)
                    print("@isMerged : ",isMerged)
                    cell.mainView.layer.maskedCorners = currCellType == 2 ? (isMerged ? [] : [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] ): [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                    let orderAmount = self.viewModel.getOrder(listAt: section, orderAt: noOfOrder, orderType:orderViewController?.selOrder ?? 0).orderTotalAmount ?? 0
                    cell.lblOrderTotal.text = orderAmount.getAmountInString()
                    
                    let date : String = self.viewModel.getOrder(listAt: section, orderAt: noOfOrder, orderType:orderViewController?.selOrder ?? 0).sentShopRequestAt ?? ""
                    let utcdate = date.toDate()?.UTCtoLocal(format: REQUESTED_TIME_FORMATE)
                    cell.lblRequestedTime.text = "Requested Time : \(utcdate ?? "-")"
                    cell.lblOrderId.text = "Order ID : #\(self.viewModel.getOrder(listAt: section, orderAt: noOfOrder, orderType:orderViewController?.selOrder ?? 0).orderUniqueId ?? "")"
                    let date1 : String = self.viewModel.getOrder(listAt: section, orderAt: noOfOrder, orderType:orderViewController?.selOrder ?? 0).updatedAt ?? ""
                    cell.btnView.addTarget(self.orderViewController, action: #selector(self.orderViewController?.actionOrderDetail(_:)),for: .touchUpInside)
                    
                    cell.btnOrderStatus.isHidden = true
                    cell.lblOrderDescription.isHidden = true
                    cell.vwDot.isHidden = true
                    if orderViewController?.selOrder == OrderType.PastOrder.rawValue{
                        cell.lblOrderDescription.isHidden = false
                        cell.vwDot.isHidden = false
                        let strStatus = self.viewModel.getOrder(listAt: section, orderAt: noOfOrder, orderType:orderViewController?.selOrder ?? 0).orderStatus.asStringOrEmpty()
                        if strStatus == OrderStatus.OrderLeft.rawValue {
                            cell.btnOrderStatus.isHidden = false
                            cell.btnOrderStatus.setTitle("Order has Left Restaurant", for: .normal)
                            cell.btnOrderStatus.addTarget(self.orderViewController, action: #selector(self.orderViewController?.actionMarkOrderLeft(_:)),for: .touchUpInside)
                        }
                        cell.lblOrderDescription.text = "\(strStatus) on \(date1.toDateString(outputFormat: REQUESTED_TIME_FORMATE) ?? "")"
                    }
                    
                    return cell
                }
                break
            default:
                break
            }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = OrderDetailsViewController(nibName: "OrderDetailsViewController", bundle: .main)
        vc.isOrderRequest = false
        let section = indexPath.section
        let orderType = orderViewController?.selOrder ?? 1
        vc.arrOrders = viewModel.getArrOrder(listAt: section,orderType:orderType) ?? []
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


