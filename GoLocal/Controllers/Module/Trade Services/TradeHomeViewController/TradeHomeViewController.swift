//
//  TradeHomeViewController.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 03/05/21.
//

import UIKit
import SwiftyJSON
import Alamofire
class TradeHomeViewController: BaseViewController {

    @IBOutlet weak var btnQR: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblDataNotFound: UILabel!
    @IBOutlet weak var btnHistory: UIButton!
    var dataSource: TradeHomeViewDataSource?
    var viewModel =  TradeHomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = TradeHomeViewDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        DispatchQueue.global().async {
            self.getUpdatedUserData()
        }
        nc.addObserver(self, selector: #selector(receiveTradeRequest(notification:)), name: Notification.Name(notificationCenterKeys.trade_business_service_request.rawValue), object: nil)
        nc.addObserver(self, selector: #selector(tradeRequestCancelled(notification:)), name: Notification.Name(notificationCenterKeys.trade_request_cancelled.rawValue), object: nil)
        nc.addObserver(self, selector: #selector(tradeRequestRejected(notification:)), name: Notification.Name(notificationCenterKeys.submitServiceQuotation.rawValue), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getAvailableQuote()
    }
    
    @IBAction func actionHistory(_ sender: Any) {
        let vc = TradeSentQuotationHistoryViewController.loadFromNib()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionQR(_ sender: Any) {
        if !requestCameraPermission() {
            alertPromptToAllowCameraAccessViaSetting()
        } else {
            let vc = ScannerViewController(nibName: "ScannerViewController", bundle: .main)
            vc.modalPresentationStyle = .overFullScreen
            vc.setView { (scannedValue) in
                if scannedValue.count > 0 {
                    let vc1 = PaymentOptionViewController(nibName: "PaymentOptionViewController", bundle: .main)
                    vc1.scannedQRCode = scannedValue
                    self.navigationController?.pushViewController(vc1, animated: true)
                }
            }
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    func rejectQuoteRequest(customerId : Int,requestId : Int){
        let param : Parameters = [
            "user_id": USER_DETAILS?.id ?? 0,
            "customer_id": customerId,
            "shop_id": USER_DETAILS?.shopId ?? 0,
            "request_id": requestId,
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
    @objc func receiveTradeRequest(notification:Notification){
        //getOrderDetails(of: orderDetails?.orderId ?? 0)
        if let userInfo = notification.userInfo{
            let dict = userInfo as NSDictionary
            if let status = dict["status"] as? Int ,let message = dict["message"] as? String{
                
                if status != 1 {
                    self.showBanner(bannerTitle: .none, message: message, type: .warning)
                    return
                }
            }
            
            guard let customerId = dict["customer_id"] as? Int else {
                return
            }
            guard let data = dict["request_detail"] as? NSDictionary else {
                return
            }
            let requestDetails = SerRequests(object: JSON(data))
            if let _ = viewModel.getServiceRequests() {
                var requests = viewModel.getServiceRequests()!
                var serReq = requests.ser_requests
                let availableReq = serReq?.filter({
                    ($0.id ?? 0) == requestDetails.id
                })
                if availableReq?.count ?? 0 == 0 {
                    serReq?.insert(requestDetails, at: 0)
                    requests.ser_requests = serReq
                    lblDataNotFound.isHidden = true
                    self.viewModel.setServicesDetails(value: requests)
                }
            } else {
                var requests = ServiceRequests(object: JSON(dict))
                requests.ser_requests = [requestDetails]
                lblDataNotFound.isHidden = true
                self.viewModel.setServicesDetails(value: requests)
            }
            self.tableView.reloadData()
        }
    }
    @objc func tradeRequestRejected(notification:Notification){
        if let userInfo = notification.userInfo{
            let dict = userInfo as NSDictionary
            if let status = dict["status"] as? Int ,let message = dict["message"] as? String{
                self.showBanner(bannerTitle: .none, message: message, type: status == 1 ? .success : .warning)
                if status == 1 {
                    self.getAvailableQuote()
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
            
            guard let customerId = dict["customer_id"] as? Int else {
                return
            }
            guard let data = dict["request_detail"] as? NSDictionary else {
                return
            }
            let requestDetails = SerRequests(object: JSON(data))
            if let _ = viewModel.getServiceRequests() {
                var requests = viewModel.getServiceRequests()!
                var serReq = requests.ser_requests
                let availableReq = serReq?.filter({
                    ($0.id ?? 0) == requestDetails.id
                })
                if availableReq?.count ?? 0 > 0 ,let req = availableReq?.first{
                    if let result = serReq?.firstIndex(where: {$0.id ?? 0 == requestDetails.id ?? 0}) {
                        serReq?.remove(at: result)
                    }
                    requests.ser_requests = serReq
                    self.viewModel.setServicesDetails(value: requests)
                    self.tableView.reloadData()
                    lblDataNotFound.isHidden = (serReq?.count ?? 0) > 0
                }
            }
        }
    }

}
