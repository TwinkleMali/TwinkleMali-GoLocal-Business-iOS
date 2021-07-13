//
//  TradeOrderDetailsViewController.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 09/06/21.
//

import UIKit
import Alamofire
import KRProgressHUD
class TradeOrderDetailsViewController: BaseViewController {

    @IBOutlet weak var lblOrderNotFound: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnMarkAsComplete: UIButton!
    @IBOutlet weak var bottomView: UIVisualEffectView!
    
    var dataSource: TradeOrderDetailsViewDataSource?
    var viewModel = TradeOrderDetailsViewModel()
    var isPendingOrder = false
    var showCashConfirmation = false
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = TradeOrderDetailsViewDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        self.tableView.dataSource = dataSource
        self.tableView.delegate = dataSource
        getsingleTradeOrderDetails()
        nc.addObserver(self, selector: #selector(ExtraChargeRequestStatusChanged(notification:)), name: Notification.Name(notificationCenterKeys.extra_charge_request_status_change_ack.rawValue), object: nil)
        nc.addObserver(self, selector: #selector(updateServicesStatusResponse(notification:)), name: Notification.Name(notificationCenterKeys.changeTradeServiceStatus.rawValue), object: nil)
        nc.addObserver(self, selector: #selector(updateServicesStatusResponse(notification:)), name: Notification.Name(notificationCenterKeys.makeServicePaymentRequest.rawValue), object: nil)
        nc.addObserver(self, selector: #selector(tradePaymentReceivedAck(notification:)), name: Notification.Name(notificationCenterKeys.trade_payment_received_ack.rawValue), object: nil)
        nc.addObserver(self, selector: #selector(confirm_cash_payment(notification:)), name: Notification.Name(notificationCenterKeys.confirm_cash_payment.rawValue), object: nil)
        nc.addObserver(self, selector: #selector(confirmTradeServiceCashPayment(notification:)), name: Notification.Name(notificationCenterKeys.confirmTradeServiceCashPayment.rawValue), object: nil)
        bottomView.isHidden = isPendingOrder
    }
    override func viewDidAppear(_ animated: Bool) {
        if showCashConfirmation ,let isPaymentDone = viewModel.getOrderDetails()?.businessQuotationDetail?.tradeRequestBillingDetails?.isPaymentDone,!isPaymentDone {
            showCashConfirmation = false
            self.confirmCashPaymentView()
        }
    }
    @IBAction func actionBack(_ sender: Any) {
        self.back(withAnimation: true)
    }
    @IBAction func actionMarkAsComplete(_ sender: UIButton) {
        if let data = self.viewModel.getOrderDetails(), let customer = data.serRequest?.customerDetails,let request = data.businessQuotationDetail{
            self.updateServicesStatus(customerId: customer.id ?? 0, requestId: request.requestId ?? 0, businessId: USER_DETAILS?.shopId ?? 0, businessOwnerId: USER_DETAILS?.id ?? 0, requestStatus: 1)
        }
    }
    
    @objc func ExtraChargeRequestStatusChanged(notification:Notification){
        self.getsingleTradeOrderDetails()
        
//        if let userInfo = notification.userInfo{
            //let dict = userInfo as NSDictionary
          
//        }
    }
    @objc func tradePaymentReceivedAck(notification:Notification){
        
        if let userInfo = notification.userInfo{
            let dict = userInfo as NSDictionary
            if let status = dict["status"] as? Int, let requestId = dict["request_id"] as? Int, let responseId = dict["response_id"] as? Int {
                //self.showBanner(bannerTitle: .none, message: message, type: .warning)
                if status == 1 {
                    //completionHandler(.success)
                    if responseId == self.viewModel.getOrderDetails()?.businessQuotationDetail?.id ?? 0 &&
                        requestId == self.viewModel.getOrderDetails()?.businessQuotationDetail?.requestId ?? 0 {
                        getsingleTradeOrderDetails()
                    }
                }
            }
        }
    }
    
    @objc func confirm_cash_payment(notification:Notification){
        if let userInfo = notification.userInfo{
            let dict = userInfo as NSDictionary
            if let status = dict["status"] as? Int, let requestId = dict["request_id"] as? Int, let responseId = dict["response_id"] as? Int {
                //self.showBanner(bannerTitle: .none, message: message, type: .warning)
                if status == 1 {
                    //completionHandler(.success)
                    if responseId == self.viewModel.getOrderDetails()?.businessQuotationDetail?.id ?? 0 &&
                        requestId == self.viewModel.getOrderDetails()?.businessQuotationDetail?.requestId ?? 0 {
                        ////
                        self.confirmCashPaymentView()
                    }
                }
            }
        }
    }
    func confirmCashPaymentView(){
        let vc = LogoutViewController.loadFromNib()
        vc.modalPresentationStyle = .overFullScreen
       vc.isForConfirmPayment = true
        let name = self.viewModel.getOrderDetails()?.serRequest?.customerDetails?.name ?? ""
        let lname = self.viewModel.getOrderDetails()?.serRequest?.customerDetails?.lname ?? ""
        vc.customerName = name + " " + lname
        vc.setView { (result) in
            if result == .success {
                self.confirmTradeServiceCashPayment()
            }
        }
        self.present(vc, animated: true)
    }
    @objc func confirmTradeServiceCashPayment(notification:Notification){
        if let userInfo = notification.userInfo{
            let dict = userInfo as NSDictionary
            if let status = dict["status"] as? Int,let message = dict["message"] as? String{
                self.showBanner(bannerTitle: .none, message: message, type: .warning)
                if status == 1 {
                    self.getsingleTradeOrderDetails()
                }
            }
        }
    }
    @objc func updateServicesStatusResponse(notification:Notification){
        
        if let userInfo = notification.userInfo{
            let dict = userInfo as NSDictionary
            if let status = dict["status"] as? Int ,let message = dict["message"] as? String{
                self.showBanner(bannerTitle: .none, message: message, type: .warning)
                if status == 1 {
                    //completionHandler(.success)
                    self.getsingleTradeOrderDetails()
                }
            }
        }
    }
    @objc func makeServicePaymentRequest(notification:Notification){
        KRProgressHUD.dismiss()
        if let userInfo = notification.userInfo{
            let dict = userInfo as NSDictionary
            if let status = dict["status"] as? Int ,let message = dict["message"] as? String{
                self.showBanner(bannerTitle: .none, message: message, type: .warning)
            }
        }
    }
    
    func updateServicesStatus(customerId : Int,
                        requestId : Int,
                        businessId : Int,
                        businessOwnerId: Int,
                        requestStatus : Int){
        let param : Parameters = [
            "customer_id": customerId,
            "request_id": requestId,
            "business_id":businessId,
            "business_owner_id":businessOwnerId,
            "request_status":requestStatus
        ]
        print("param - changeTradeServiceStatus :",param )
        APP_DELEGATE?.socketIOHandler?.changeTradeServiceStatus(dic: param)
    }
    func confirmTradeServiceCashPayment(){
        let param : Parameters = [
            "user_id": viewModel.getOrderDetails()?.serRequest?.customerDetails?.id ?? 0,
            "request_id": viewModel.getOrderDetails()?.businessQuotationDetail?.requestId ?? 0,
            "response_id": viewModel.getOrderDetails()?.businessQuotationDetail?.id ?? 0,
            "shop_id":USER_DETAILS?.shopId ?? 0,
            "business_owner_id":USER_DETAILS?.id ?? 0
        ]
        print("param - confirmTradeServiceCashPayment :",param )
        APP_DELEGATE?.socketIOHandler?.confirmTradeServiceCashPayment(dic: param)
    }
}
