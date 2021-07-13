//
//  TradeServiceDetailsViewController.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 06/05/21.
//

import UIKit
import Alamofire
import SwiftyJSON
class TradeServiceDetailsViewController: BaseViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnConfirm: UIButton!
    
    
    var viewModel = TradeServiceDetailsViewModel()
    var dataSource : TradeServiceDetailsViewDataSource?
    var QuotationId = 0
    var customerId = 0
    var isInScreen = false
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setServiceRequestDetails()
        dataSource = TradeServiceDetailsViewDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        nc.addObserver(self, selector: #selector(tradeRequestCancelled(notification:)), name: Notification.Name(notificationCenterKeys.trade_request_cancelled.rawValue), object: nil)
        nc.addObserver(self, selector: #selector(tradeRequestRejected(notification:)), name: Notification.Name(notificationCenterKeys.submitServiceQuotation.rawValue), object: nil)
        self.getsingleQuoteationdetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isInScreen = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        isInScreen = false
    }
    @IBAction func actionBack(_ sender: Any) {
        self.back(withAnimation: true)
    }
    
    @IBAction func actionConfirmQuote(_ sender: Any) {
        if validate(){
            acceptQuoteRequest()
        }
    }
    func validate() -> Bool {
        if viewModel.getServiceRequestDetails()?.paymentOption.count ?? 0 == 0 {
            self.showBanner(bannerTitle: .validation, message: "Please confirm payment options", type: .warning)
            return false
        } else if viewModel.getBidOption() == 0 && viewModel.getServiceRequestDetails()?.bidAmount ?? 0 == 0 {
            self.showBanner(bannerTitle: .validation, message: "Please add valid amount for bid-amount", type: .warning)
            return false
        } else if viewModel.getServiceRequestDetails()?.calloutFee ?? 0 == 0 {
            self.showBanner(bannerTitle: .validation, message: "Please add valid amount for call out fee", type: .warning)
            return false
        } else if viewModel.getServiceRequestDetails()?.depositOption != .NONE && viewModel.getServiceRequestDetails()?.depositValue == 0 {
            self.showBanner(bannerTitle: .validation, message: "Please add valid value for deposit option", type: .warning)
            return false
        }
        return true
    }
    @objc func tradeRequestRejected(notification:Notification){
        if let userInfo = notification.userInfo{
            let dict = userInfo as NSDictionary
            if let status = dict["status"] as? Int ,let message = dict["message"] as? String{
                self.showBanner(bannerTitle: .none, message: message, type: status == 1 ? .success : .warning)
                if status == 1 {
                        self.back(withAnimation: true)
                        self.back(withAnimation: true)
                }
            }
        }
    }
    @objc func tradeRequestCancelled(notification:Notification){
        //getOrderDetails(of: orderDetails?.orderId ?? 0)
        if let userInfo = notification.userInfo{
            let dict = userInfo as NSDictionary
            if let status = dict["status"] as? Int ,let message = dict["message"] as? String{
                self.showBanner(bannerTitle: .none, message: message, type: .warning)
                if status != 1 {
                    return
                }
            }
            
            guard let data = dict["request_detail"] as? NSDictionary else {
                return
            }
            let requestDetails = SerRequests(object: JSON(data))
            if self.viewModel.getRequestDetails()?.id  ?? 0 == requestDetails.id ?? 0 {
                self.back(withAnimation: true)
            }
        }
    }
    
    func rejectQuoteRequest(){
        let param : Parameters = [
            "user_id": USER_DETAILS?.id ?? 0,
            "customer_id": viewModel.getRequestDetails()?.customerDetails?.id ?? 0,
            "shop_id": USER_DETAILS?.shopId ?? 0,
            "request_id": viewModel.getRequestDetails()?.id ?? 0,
            "deposite_option": 0,
            "deposite_value": 0,
            "business_option": 0,
            "payment_option": 0,
            "bid_amount": 0,
            "call_out_fee": 0,
            "business_option_value": 0,
            "arrival_time": 0,
            "quote_description": "",
            "is_accept": 0
        ]
        APP_DELEGATE?.socketIOHandler?.submitServiceQuotation(dic: param)
    }
    func acceptQuoteRequest(){
        let param : Parameters = [
            "user_id": USER_DETAILS?.id ?? 0,
            "customer_id": viewModel.getRequestDetails()?.customerDetails?.id ?? 0,
            "shop_id": USER_DETAILS?.shopId ?? 0,
            "request_id": viewModel.getRequestDetails()?.id ?? 0,
            "deposite_option": viewModel.getServiceRequestDetails()?.depositOption.rawValue ?? "None",
            "deposite_value": viewModel.getServiceRequestDetails()?.depositValue ?? 0,
            "business_option": viewModel.getServiceRequestDetails()?.businessOption ?? "",
            "payment_option": viewModel.getServiceRequestDetails()?.paymentOption ?? "",
            "bid_amount": viewModel.getServiceRequestDetails()?.bidAmount ?? 0,
            "call_out_fee": viewModel.getServiceRequestDetails()?.calloutFee ?? 0,
            "business_option_value": viewModel.getServiceRequestDetails()?.businessB_Options.rawValue ?? "",
            "arrival_time": viewModel.getServiceRequestDetails()?.arrivalTime ?? 0,
            "quote_description": viewModel.getServiceRequestDetails()?.quote ?? "",
            "is_accept": 1
        ]
        print("param :",param )
        APP_DELEGATE?.socketIOHandler?.submitServiceQuotation(dic: param)
    }
}
