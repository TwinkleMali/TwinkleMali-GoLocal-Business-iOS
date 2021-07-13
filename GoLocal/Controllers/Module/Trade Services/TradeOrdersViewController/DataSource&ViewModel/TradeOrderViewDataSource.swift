//
//  TradeOrderViewDataSource.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 05/05/21.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
class TradeOrderViewDataSource: NSObject{
    //MARK:- VARIABLES
    private let tableView : UITableView
    private let viewModel: TradeOrderViewModel
    private let viewController: UIViewController
    private var tradeOrdersViewController : TradeOrdersViewController? {
        get{
            viewController as? TradeOrdersViewController
        }
    }
    //MARK: - INIT
    init(tableView: UITableView,viewModel: TradeOrderViewModel , viewController: UIViewController) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.viewController = viewController
        tableView.register("OrderCommonDetailsTVCell")
    }
}

extension TradeOrderViewDataSource : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getOrderCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCommonDetailsTVCell", for: indexPath) as? OrderCommonDetailsTVCell {
            if tradeOrdersViewController!.selOrder == 1 {
                cell.SetUpCell(.ActiveOrder)
            } else {
                cell.SetUpCell(.PastOrder)
            }
            if let order = viewModel.getOrderDetails(atPos: row),let request = order.serRequest{
                let dateStr =  request.createdAt ?? ""
                let date = dateStr.toDate()?.UTCtoLocal(format: "dd/MM/yyyy") ?? ""
                let time = dateStr.toDate()?.UTCtoLocal(format: "hh:mm a") ?? ""
                cell.lblRequestedDateTime.text = "\(date) at \(time.uppercased())"
                cell.lblRequestedDateTime.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 17))
                if let customer = request.customerDetails {
                    let name = customer.name ?? ""
                    let lName = customer.lname ?? ""
                    cell.lblPastCustomerName.text = name + " " + lName
                    cell.lblPastCustomerName.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 17))
                    let phone = customer.phone ?? ""
                    let countryCode = customer.countryCode ?? 00
                    cell.lblCustomerPhone.text = "+\(countryCode) \(phone)"
                    cell.lblCustomerPhone.font = UIFont(name: fFONT_REGULAR, size: calculateFontForWidth(size: 13))
                    cell.lblCustomerAddress.text = request.userAddress ?? ""
                    cell.lblCustomerAddress.font = UIFont(name: fFONT_REGULAR, size: calculateFontForWidth(size: 14))
                }
                if let arrQueAns = request.questionAnswers{
                    let result = arrQueAns.filter({($0.isEmergency ?? 0) == 1})
                    if result.count > 1 , let queAns = result.first{
                        cell.lblBookingType.text = (queAns.optionValue ?? "") == "Yes" ? "Emergency" : "General"
                        cell.lblBookingType.font = UIFont(name: fFONT_REGULAR, size: calculateFontForWidth(size: 14))
                    }
                }
                if let arrServiceType = request.serviceCategories, let serviceType = arrServiceType.first{
                    cell.lblServiceType.text = serviceType.serviceName
                    cell.lblServiceType.font = UIFont(name: fFONT_REGULAR, size: calculateFontForWidth(size: 14))
                }
                cell.btnOrderDetails.tag = row
                cell.btnOrderDetails.addTarget(self, action: #selector(showOrderDetails(_:)), for: .touchUpInside)
                if tradeOrdersViewController!.selOrder == 1 {
                    if let businessQuotationDetail = order.businessQuotationDetail ,let billingDetails = businessQuotationDetail.tradeRequestBillingDetails{
                        cell.lblBidAmount.text = (billingDetails.bidAmount ?? 0).getAmountInString()
                        cell.btnNextPayment.isHidden = businessQuotationDetail.tradeRequestBillingDetails?.isPaymentDone ?? false
                        cell.btnNextPayment.tag = indexPath.row
                        cell.btnNextPayment.addTarget(self, action: #selector(paymentRequest(_:)), for: .touchUpInside)
                    }
                    
                    cell.lblBidAmountTitle.font = UIFont(name: fFONT_REGULAR, size: calculateFontForWidth(size: 14))
                    cell.lblArrivalTimeTitle.font = UIFont(name: fFONT_REGULAR, size: calculateFontForWidth(size: 14))
                    cell.lblBidAmount.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 15))
                    cell.lblArrivalDateTime.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 15))
                    cell.btnCancel.tag = row
                    cell.btnCancel.isHidden = order.businessQuotationDetail?.tradeRequestBillingDetails?.isPaymentDone ??  false
                    cell.btnCancel.addTarget(self, action: #selector(cancelService(_:)), for: .touchUpInside)
                    if let arrRequestSchedule = request.requestSchedule{
                        let requestSchedule = arrRequestSchedule[0]
                        let dateStr =  requestSchedule.startRequestDatetime
                        let date = dateStr?.toDate()?.UTCtoLocal(format: "dd/MM/yyyy") ?? ""
                        let time = dateStr?.toDate()?.UTCtoLocal(format: "hh:mm a") ?? ""
                        cell.lblArrivalDateTime.text = "\(date) at \(time.uppercased())"
                    }
                    
                } else {
                    if let businessQuotationDetail = order.businessQuotationDetail ,let billingDetails = businessQuotationDetail.tradeRequestBillingDetails{
                        cell.lblAmt.text = (billingDetails.totalAmount ?? 0).getAmountInString()
                    }
                    cell.lblAmtTitle.font = UIFont(name: fFONT_REGULAR, size: calculateFontForWidth(size: 14))
                    cell.lblAmt.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 15))
                    cell.lblAmt.textColor = .black
                    cell.lblCompletedDate.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 12))
                    cell.btnNextPayment.isHidden = true
                    
                    let dateStr =  request.statusModifiedAt ?? ""
                    let date = dateStr.toDate()?.UTCtoLocal(format: "dd/MM/yyyy") ?? ""
                    let time = dateStr.toDate()?.UTCtoLocal(format: "hh:mm a") ?? ""
                    let strReqStatus = request.requestStatus ?? ""
                    let reqStatus = TRADE_SERVICE_STATUS(rawValue: strReqStatus) ?? .REJECTED
                    if reqStatus == .COMPLETED {
                        cell.lblCompletedDate.textColor = .systemGreen
                        cell.viewStatusDot.backgroundColor = .systemGreen
                    } else {
                        cell.lblCompletedDate.textColor = .systemRed
                        cell.viewStatusDot.backgroundColor = .systemRed
                    }
                    cell.lblCompletedDate.text = "\(strReqStatus) on \(date) at \(time.uppercased())"
                }
            }
            let ip = indexPath
            if (tableView.indexPathsForVisibleRows!.contains(ip)) && tradeOrdersViewController?.isScrolling ?? false && ( ip.row == self.viewModel.getOrderCount() - 2) && viewModel.isLoadMoreEnabled(){
                self.tradeOrdersViewController?.getTradeOrders(isLoadMore: true)
                self.tradeOrdersViewController?.isScrolling = false
            }
            
            cell.layoutIfNeeded()
            return cell
        }
        return UITableViewCell()
    }
    @objc func showOrderDetails(_ sender : UIButton){
        let row = sender.tag
        let vc = TradeOrderDetailsViewController.loadFromNib()
        let id = viewModel.getOrderDetails(atPos: row)?.businessQuotationDetail?.id ?? 0
        vc.viewModel.setResponseId(value: id)
        self.viewController.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func paymentRequest(_ sender : UIButton)
    {
        let tag = sender.tag
        
        switch APP_DELEGATE?.socketIOHandler?.socket?.status{
        case .connected?:
            if let data = viewModel.getOrderDetails(atPos: tag), let businessQuotationDetail = data.businessQuotationDetail, let serviceRequest = data.serRequest {
                
                let param : Parameters = [
                    "customer_id": serviceRequest.customerDetails?.id ?? 0,
                    "shop_id":USER_DETAILS?.shopId ?? 0,
                    "business_owner_id":USER_DETAILS?.id ?? 0,
                    "request_id":serviceRequest.id ?? 0,
                    "response_id":businessQuotationDetail.id ?? 0
                ]
                
                APP_DELEGATE?.socketIOHandler?.makeServicePaymentRequest(dic: param)
            }
            
            break
        default:
            self.tradeOrdersViewController?.showBanner(bannerTitle: .failed, message: "Disconnected from server.", type: .warning)
            print("Socket Not Connected")
            break;
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tradeOrdersViewController?.isScrolling  = true
    }
    @objc func cancelService(_ sender : UIButton){
        let row = sender.tag
        let orderDetails = viewModel.getOrderDetails(atPos: row)
        
         let vc = LogoutViewController.loadFromNib()
         vc.modalPresentationStyle = .overFullScreen
        vc.isForCancelService = true
         vc.setView { (result) in
             if result == .success {
                let customer_id = orderDetails?.serRequest?.customerDetails?.id ?? 0
                let request_id = orderDetails?.businessQuotationDetail?.requestId ?? 0
                let business_id = orderDetails?.businessQuotationDetail?.id ?? 0
                let business_owner_id = USER_DETAILS?.id ?? 0
                let request_status = 2
                self.tradeOrdersViewController?.updateServicesStatus(customerId: customer_id,
                                                                     requestId: request_id,
                                                                     businessId: business_id,
                                                                     businessOwnerId: business_owner_id,
                                                                     requestStatus: request_status)
             }
         }
        self.viewController.present(vc, animated: true, completion: nil)
    }
}
