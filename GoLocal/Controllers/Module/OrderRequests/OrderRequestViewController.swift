//
//  OrderRequestViewController.swift
//  GoLocal
//
//  Created by C110 on 18/1/21.
//

import UIKit

class OrderRequestViewController: BaseViewController, BottomSheetDelegate {
  
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var navView : UIView!
    @IBOutlet weak var lblNoMsg : UILabel!
    var dataSource: OrderRequestDataSource?
    var viewModel = OrderRequestViewModel()
    var selRequest : OrderRequests!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = OrderRequestDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        
        self.tableView.delegate = dataSource
        self.tableView.dataSource = dataSource
        self.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 5, right: 0)
        DispatchQueue.global().async {
            self.getUpdatedUserData()
        }
        getUpdatedUserData()
//        self.navView.addBottomShadow()
        if !USER_DEFAULTS.contains(key: defaultsKey.RejectReasons.rawValue){
        switch APP_DELEGATE?.socketIOHandler?.socket?.status{
            case .connected?:
                if (APP_DELEGATE!.socketIOHandler!.isJoinSocket){
                    APP_DELEGATE!.socketIOHandler?.GetRejectReason()
                }
                break
    
                default:
                    print("GetRejectReason : Socket Not Connected")
        }
        }
        allNotificationCenterObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getOrderRequestList()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        let section : Int = viewModel.getSelectedOrderIndex() 
//        let cellIndex : IndexPath = IndexPath(row: 0, section: section)
//        if let cell : PastOrdersTVCell = tableView.cellForRow(at: cellIndex) as? PastOrdersTVCell{
//            cell.lblTime.reset()
//        }
//    }
    
    //MARK: -   Notifiation Methods
    func allNotificationCenterObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(OrderRequestReceived(notification:)), name: NSNotification.Name(rawValue: notificationCenterKeys.shopOrderRequest.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OrderRequestRejected(notification:)), name: NSNotification.Name(rawValue: notificationCenterKeys.shopRejectOrder.rawValue), object: nil)
    }
    
    @objc func OrderRequestReceived(notification : Notification) {
        let obj  = notification.userInfo  as? [String : Any]
        let objOrderRequest = OrderRequests(object: obj!)
        var arrOrderRequest : [OrderRequests] = []
        arrOrderRequest.append(objOrderRequest)
        self.viewModel.setOrderRequests(arrOrderRequest: arrOrderRequest)
        self.tableView.reloadData()
    }
    
    @objc func OrderRequestRejected(notification : Notification) {
        self.view.makeToast("Order is rejected.",duration: 2.0, position: .center)
//        let section : Int = viewModel.getSelectedOrderIndex()
//        let cellIndex : IndexPath = IndexPath(row: 0, section: section)
//        if let cell : PastOrdersTVCell = tableView.cellForRow(at: cellIndex) as? PastOrdersTVCell{
//            cell.lblTime.reset()
//        }
        if selRequest != nil{
            self.viewModel.removeRequest(objRequest: selRequest)
        }
        tableView.reloadData()
    }
    
    //MARK:- Button Click Methods
    // QRCode Scan icon Click
    @IBAction func actionScanCode(_ sender: UIButton) {
        //let vc = PaymentOptionViewController(nibName: "PaymentOptionViewController", bundle: .main)
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
    
    // Order Request Detail and Accept Order Request Click
    @objc func actionOrderDetail(_ sender : UIButton) {
        viewModel.setSelectedOrderIndex(index: sender.tag)
        if viewModel.getRowCount() > 0{
            selRequest = viewModel.getOrderRequest(at: sender.tag)
        }
        let vc = OrderDetailsViewController(nibName: "OrderDetailsViewController", bundle: .main)
        vc.isOrderRequest = true
        vc.objOrderRequest = viewModel.getOrderRequest(at: sender.tag)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Accept Order Request Click
    @objc func actionAcceptRequest(_ sender : UIButton) {
           viewModel.setSelectedOrderIndex(index: sender.tag)
        if viewModel.getOrderRequest(at: sender.tag).orderDetails?.deliveryType == DeliveryType.collection.rawValue {
            let vc = TimeSelectionVC(nibName: "TimeSelectionVC", bundle: .main)
            vc.objOrderRequest = viewModel.getOrderRequest(at: sender.tag)
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = DriverSeleListViewController(nibName: "DriverSeleListViewController", bundle: .main)
            vc.objOrderRequest = viewModel.getOrderRequest(at: sender.tag)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
 
    // Reject Order Request Click
    @IBAction func actionRejectRequest(_ sender: UIButton) {
        viewModel.setSelectedOrderIndex(index: sender.tag)
        if viewModel.getRowCount() > 0{
            selRequest = viewModel.getOrderRequest(at: sender.tag)
        let vc = BottomSheetVC(nibName: "BottomSheetVC", bundle: nil)
        vc.strTitle = BS_REJECT_REASON
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        }
    }
    
    //MARK:- Bottomsheet Delegate Method
    func didSelectOption(selValue: String) {        
        let dic = ["user_id" : USER_DETAILS?.id ?? 0,
                   "customer_id" : selRequest.orderDetails?.customerDetails?.id ?? 0,
                   "order_id" : selRequest.orderDetails?.id ?? 0,
                   "shop_id" : USER_DETAILS?.shopId ?? 0,
                   "reject_reason" : selValue,
                   "is_auto_rejection" : false] as [String : Any]
        print("reject dic : \(dic)")
        socketRejectOrderRequest(dictionary: dic)
    }
}

