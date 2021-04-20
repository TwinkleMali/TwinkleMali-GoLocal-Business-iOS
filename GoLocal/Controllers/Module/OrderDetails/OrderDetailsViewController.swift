//
//  OrderDetailsViewController.swift
//  GoLocal
//
//  Created by C110 on 18/1/21.
//

import UIKit

class OrderDetailsViewController: BaseViewController, BottomSheetDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var switchView: UIView!{
        didSet{
            switchView.backgroundColor = .lightGray
            drawBorder(view: switchView, color: .lightGray, width: 1.0, radius: 5.0)
        }
    }
    @IBOutlet weak var switchStackView: UIStackView!
    @IBOutlet weak var btnFirstOrder: UIButton!
    @IBOutlet weak var btnSecondOrder: UIButton!
    var dataSource: OrderDetailsDataSource?
    var viewModel = OrderDetailsViewModel()
    var isOrderRequest : Bool = false
    var objOrderRequest : OrderRequests!
    //var objOrder : OrderDetails!
    var arrOrders : [OrderDetails] = []
    var orderId : Int!
    var selOrder = OrderDetailTab.FirstOrder.rawValue
    var isMultipleOrder : Bool = false
    var deliverdOrderNo = 0
//    @IBOutlet var btnHeight : NSLayoutConstraint!
    @IBOutlet var stHeight : NSLayoutConstraint!
    @IBOutlet weak var btnMarkOrderLeft: UIButton!{
        didSet{
            btnMarkOrderLeft.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var btnAccept: UIButton!{
        didSet{
            btnAccept.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var btnReject: UIButton!
    {
        didSet{
            btnReject.layer.cornerRadius = 8
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblOrderStatus.isHidden = true
        self.tableView.isHidden = true
        dataSource = OrderDetailsDataSource(tableView: tableView, viewModel: viewModel, viewController: self, isRequest: isOrderRequest)
        self.tableView.delegate = dataSource
        self.tableView.dataSource = dataSource
        allNotificationCenterObservers()
        
        if objOrderRequest != nil {
            self.viewModel.setOrderRequests(objOrderReqeust: objOrderRequest)
            self.viewModel.setOrderArr(arrOrders: [objOrderRequest.orderDetails!])
            arrOrders.append(contentsOf: [objOrderRequest.orderDetails!])
            setupView()
        }
        
        if arrOrders.count > 0{
            self.viewModel.setOrderArr(arrOrders: arrOrders)
            //socketGetOrderDetail(strOrder: "\(objOrder.id ?? 0)")
            setupView()
        }
        
        if orderId != nil{
            socketGetOrderDetail(strOrder: "\(orderId ?? 0)")
        }
    }
    
    func setupView() {
//        if isMultipleOrder {
        let objOrder = viewModel.getOrderDetail()
        stHeight.constant = viewModel.isMerged() ? 60 : 0
        switchStackView.isHidden = false
        
        drawBorder(view: switchStackView, color: .lightGray, width: 1.0, radius: 5.0)
        
//        btnFirstOrder.backgroundColor = GreenColor
//        btnSecondOrder.backgroundColor = .white
//        btnFirstOrder.setTitle("First Order", for: .normal)
//        btnSecondOrder.setTitle("Second Order", for: .normal)
//        btnFirstOrder.titleLabel?.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 16.0))
//        btnSecondOrder.titleLabel?.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 16.0))
//        
//        btnFirstOrder.setTitleColor(.white, for: .selected)
//        btnFirstOrder.setTitleColor(.lightGray, for: .normal)
//        
//        btnSecondOrder.setTitleColor(.white, for: .selected)
//        btnSecondOrder.setTitleColor(.lightGray, for: .normal)


//        }else {
//            switchStackView.isHidden = true
//            stHeight.constant = 0
            if isOrderRequest{
                btnMarkOrderLeft.isHidden = true
                btnMarkOrderLeft.isUserInteractionEnabled = false
               
                stackView.isHidden = false
            }else {
               
                btnMarkOrderLeft.isUserInteractionEnabled = true
                btnMarkOrderLeft.isHidden = false
                stackView.isHidden = true
                if objOrder.deliveryType == DeliveryType.collection.rawValue && objOrder.orderStatus == OrderStatus.Confirmed.rawValue {
                    btnMarkOrderLeft.setTitle("Mark Order as Completed", for: .normal)
                }else if objOrder.deliveryType == DeliveryType.delivery.rawValue && objOrder.orderStatus == OrderStatus.Confirmed.rawValue {
                    btnMarkOrderLeft.setTitle("Mark Order has left", for: .normal)
                }else {
                    lblOrderStatus.isHidden = false
                    btnMarkOrderLeft.isHidden = true
                  
                    if objOrder.orderStatus == OrderStatus.OrderLeft.rawValue {
                        lblOrderStatus.text = "\(objOrder.orderStatus.asStringOrEmpty())"
                    }else if objOrder.orderStatus == OrderStatus.Cancelled.rawValue {
                        lblOrderStatus.text = "Order \(objOrder.orderStatus.asStringOrEmpty())"
                    }else if objOrder.orderStatus == OrderStatus.AcceptedByShop.rawValue{
                        lblOrderStatus.text = "Driver Not Assigned yet."
                    } else if objOrder.orderStatus == OrderStatus.Delivered.rawValue {
                        let date = objOrder.updatedAt ?? ""
                        lblOrderStatus.text = "\(OrderStatus.Delivered.rawValue) on \(date.toDateString(outputFormat: REQUESTED_TIME_FORMATE) ?? "")"
                    }
                    
                }
//            }
        }
        self.tableView.reloadData()
        self.tableView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
   
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionTabValueChange(_ sender: UIButton) {
        if sender == btnFirstOrder{
            selOrder = OrderDetailTab.FirstOrder.rawValue
            sender.backgroundColor = GreenColor
            sender.isSelected = true
            viewModel.updateTab(value: 0)
            btnSecondOrder.backgroundColor = .white
            btnSecondOrder.isSelected = false
        }else {
            selOrder = OrderDetailTab.SecondOrder.rawValue
            sender.backgroundColor = GreenColor
            sender.isSelected = true
            viewModel.updateTab(value: 1)
            btnFirstOrder.backgroundColor = .white
            btnFirstOrder.isSelected = false
        }
        setupView()
        tableView.reloadData()
    }
    
    
    func allNotificationCenterObservers() {        
        NotificationCenter.default.addObserver(self, selector: #selector(OrderStatusChanged(notification:)), name: NSNotification.Name(rawValue: notificationCenterKeys.changeTakeawayOrderStatus.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getSingleOrderDetails(notification:)), name: NSNotification.Name(rawValue: notificationCenterKeys.getSingleOrderDetails.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OrderRequestRejected(notification:)), name: NSNotification.Name(rawValue: notificationCenterKeys.shopRejectOrder.rawValue), object: nil)
    }
    
    @objc func OrderRequestRejected(notification : Notification) {
        self.view.makeToast("Order is rejected.",duration: 2.0, position: .center)
        APP_DELEGATE?.setupRootTabBarViewController(tabIndex: 1)
    }
    
    @objc func OrderStatusChanged(notification : Notification) {
        let obj  = notification.userInfo  as? [String : Any]
        if (obj?["status"] as! Bool){
            self.view.makeToast("Order is left.",duration: 2.0, position: .center)
            if deliverdOrderNo == 0 && self.viewModel.isMerged() {
                mergeOrder(orderNo: 1)
            } else {
                APP_DELEGATE?.setupRootTabBarViewController(tabIndex: 1)
            }
        } else {
            self.showBanner(bannerTitle: .none, message: obj?["message"] as! String, type: .danger)
        }
    }
    
    @objc func getSingleOrderDetails(notification : Notification) {
        let obj  = notification.userInfo  as? [String : Any]        
        if (obj?["status"] as! Bool){
            let objOrder = OrderDetails(object: obj![WSDATA]!)
            viewModel.setOrderArr(arrOrders: [objOrder])
            setupView()
            loadViewIfNeeded()
        }
    }
    
    // Order on map Click
    @objc func actionMarkOrderLeft(_ sender : UIButton) {
        let objOrder = viewModel.getOrderDetail(no: 0)
        if let driver =  objOrder.driverDetails {
            let vc = DriverLocationViewController.loadFromNib()
            vc.driverDetails = driver
            vc.orderId = objOrder.id ?? 0
            
            vc.driverLat = driver.latitude ?? "21.1205"
            vc.driverLong = driver.longitude ?? "72.7431"
            
            vc.deliveryLatitude = objOrder.deliveryLatitude ?? ""
            vc.deliveryLongitude = objOrder.deliveryLongitude ?? ""
            
            
            
            if viewModel.isMerged() {
                vc.isMergedOrder = true
                let objOrder2 = viewModel.getOrderDetail(no: 1)
                vc.deliveryLatitude2 = objOrder2.deliveryLatitude ?? ""
                vc.deliveryLongitude2 = objOrder2.deliveryLongitude ?? ""
            }
            vc.shopLat = objOrder.shopDetail?.latitude ?? ""
            vc.shopLong = objOrder.shopDetail?.longitude ?? ""
            
            let isOrderPicked = objOrder.orderStatus == OrderStatus.OrderLeft.rawValue
            vc.orderNotPickedUp = !isOrderPicked
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnOrderStatusChange(_ sender: UIButton) {
        mergeOrder()
    }
    func mergeOrder(orderNo : Int = 0 ){
        deliverdOrderNo = orderNo
        let objOrder = viewModel.getOrderDetail(no: orderNo)
        let dic = ["user_id" : USER_DETAILS?.id ?? 0,
                   "customer_id" : objOrder.customerDetails?.id ?? 0,
                   "order_id" : objOrder.id ?? 0,
                   "driver_id" : objOrder.driverId ?? 0,
                   "business_owner_id" : objOrder.shopDetail?.userId ?? 0,
                   "order_status" : TAKEAWAY_ORDER_STATUS.ORDER_LEFT.rawValue] as [String : Any]
        print("order status change dic : \(dic)")
        
        socketOrderStatusChanged(dictionary: dic)
    }
    // Accept Order Request Click
    @IBAction func btnAcceptClick(_ sender: UIButton) {
        if objOrderRequest.orderDetails?.deliveryType == DeliveryType.collection.rawValue {
            let vc = TimeSelectionVC(nibName: "TimeSelectionVC", bundle: .main)
            vc.objOrderRequest = objOrderRequest
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = DriverSeleListViewController(nibName: "DriverSeleListViewController", bundle: .main)
            vc.objOrderRequest = objOrderRequest
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
 
    // Reject Order Request Click
    @IBAction func btnRejectClick(_ sender: UIButton) {
        let vc = BottomSheetVC(nibName: "BottomSheetVC", bundle: nil)
        vc.strTitle = BS_REJECT_REASON
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
        
    //MARK:- Bottomsheet Delegate Method
    func didSelectOption(selValue: String) {        
        let dic = ["user_id" : USER_DETAILS?.id ?? 0,
                   "customer_id" : objOrderRequest.orderDetails?.customerDetails?.id ?? 0,
                   "order_id" : objOrderRequest.orderDetails?.id ?? 0,
                   "shop_id" : USER_DETAILS?.shopId ?? 0,
                   "reject_reason" : selValue,
                   "is_auto_rejection" : false] as [String : Any]
        print("reject dic : \(dic)")
        socketRejectOrderRequest(dictionary: dic)
    }
}
