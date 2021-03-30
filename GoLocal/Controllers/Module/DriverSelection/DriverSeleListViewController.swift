//
//  DriverSeleListViewController.swift
//  GoLocal
//
//  Created by C110 on 18/1/21.
//
import Toast_Swift
import UIKit

class DriverSeleListViewController: BaseViewController{

    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnClickHere: UIButton!
    @IBOutlet weak var vwNav: UIView!
    @IBOutlet weak var vwSearch: UIView!
    {
        didSet{
            vwSearch.layer.cornerRadius = 7
        }
    }
    @IBOutlet weak var searchHeight: NSLayoutConstraint!
    var isSearch : Bool = false
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
        }
    }
    @IBOutlet weak var tableView: UITableView!
    var objOrderRequest : OrderRequests!
    var selectedDriverId : Int!
    var pickupTime : Int = 0
    var deliveryTimes : Int = 0
    var selectedMin : Int!
    let datePicker = UIDatePicker()
    let toolBar = UIToolbar()
    
    //MARK:- VARIABLES
    var dataSource: DriverSeleListViewDataSource?
    var viewModel = DriverSeleListViewModel()
    @IBOutlet var lblTime: MZTimerLabel!
    @IBOutlet weak var vwTimer: UIView!
    var orderRequestTime : TimeInterval = 0.0
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = DriverSeleListViewDataSource(tableView: tableView, viewModel: viewModel, viewController: self,isViewDriver: false)
        self.tableView.isHidden = true
        self.tableView.delegate = dataSource
        self.tableView.dataSource = dataSource
        self.tableView.tableFooterView = UIView()
        searchHeight.constant = 0
       
        self.getDriverList()
        allNotificationCenterObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Setup Timer
        lblTime.timeFormat = "mm:ss"
        lblTime.timerType = MZTimerLabelTypeTimer
        lblTime.delegate =  self
        lblTime.reset()
        orderRequestTime = getSecondsBetweenDates(date1: Date(), date2: serverToLocal(date: (objOrderRequest.orderDetails?.sentShopRequestAt!)!)!, orderTimerValue: Double(objOrderRequest.orderTimerValue!))
        lblTime.addTimeCounted(byTime: TimeInterval(orderRequestTime))
        lblTime.start()
    }
    
    //MARK: -   Notifiation Methods
    func allNotificationCenterObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(OrderRequestAccepted(notification:)), name: NSNotification.Name(rawValue: notificationCenterKeys.shopAcceptOrder.rawValue), object: nil)
    }
    
    @objc func OrderRequestAccepted(notification : Notification) {
//        lblTime.reset()
        let obj  = notification.userInfo as? [String : Any]
        if obj?["status"] as! Bool{
            self.view.makeToast(obj?["message"] as? String,duration: 2.0, position: .center)
        }else {
            self.view.makeToast(obj?["message"] as? String,duration: 2.0, position: .center)
        }
        APP_DELEGATE?.setupRootTabBarViewController(tabIndex: 1)
    }
    
    //MARK:- Button Click Methods
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnClickHere(_ sender: UIButton) {        
        let vc = DriverStatusViewController(nibName: "DriverStatusViewController", bundle: .main)
        vc.viewModel.setDrivers(objDrivers: self.viewModel.getAllDriver())
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionSearch(_ sender: Any) {
        if isSearch {
            searchHeight.constant = 0
            vwSearch.isHidden = true
            isSearch = false
        }else {
            searchHeight.constant = 80
            vwSearch.isHidden = false
            isSearch = true
        }
    }
    
    @IBAction func btnSelectDriver(_ sender: UIButton) {
        if selectedDriverId == nil{
            self.showBanner(bannerTitle: .none, message: "Please select driver.", type: .danger)
        }else if selectedDriverId == 0 && pickupTime == 0{
            self.showBanner(bannerTitle: .none, message: "Please select pickup time for driver.", type: .danger)
        }else if selectedDriverId > 0 && deliveryTimes == 0{
            self.showBanner(bannerTitle: .none, message: "Please select Delivery time for driver.", type: .danger)
        }else {
            let dic = ["user_id" : USER_DETAILS?.id ?? 0,
                       "customer_id" : objOrderRequest.customerId ?? 0 ,
                       "order_id" : objOrderRequest.orderId ?? 0,
                       "driver_id" : selectedDriverId ?? 0,
                       "pickup_time" : pickupTime,
                       "delivery_time" : deliveryTimes,
                       "need_to_merge" : 0,
                       "merge_request_id":0,
                       "merge_with_order_id":0] as [String : Any]
            print("accept dic : \(dic)")
            socketAcceptOrderRequest(dictionary: dic)
        }
    }
    
    //MARK: -   DatePicker Methods
    func showDatePicker(textfield : UITextField){
            //Formate Date
        datePicker.datePickerMode = .dateAndTime
        datePicker.tag = textfield.tag
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            }
            datePicker.minimumDate = Date()
            //ToolBar
            let toolbar = UIToolbar();
            toolbar.sizeToFit()
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDatePicker));
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            textfield.inputAccessoryView = toolbar
            textfield.inputView = datePicker
    }

    @objc func cancelDatePicker(){
           //cancel button dismiss datepicker dialog
            self.view.endEditing(true)
    }
    
    @objc func handleDatePicker() {
        selectedMin = datePicker.date.minutes(from: Date())
        if datePicker.tag == DriverType.GoLocalFirstDrivers.rawValue{
            pickupTime = datePicker.date.seconds(from: Date())
            deliveryTimes = 0
        }else {
            pickupTime = 0
            deliveryTimes = datePicker.date.seconds(from: Date())
        }
        tableView.reloadData()
    }
}

extension DriverSeleListViewController : MZTimerLabelDelegate {
    func timerLabel(_ timerLabel: MZTimerLabel!, finshedCountDownTimerWithTime countTime: TimeInterval){
        if APP_DELEGATE?.arrOrderRequestMain.contains(where: { $0.orderDetails?.id == objOrderRequest.orderDetails?.id }) == true {
        print("Order Request Time out on driver screen for \(objOrderRequest.orderId ?? 0)")
        let dic = ["user_id" : USER_DETAILS?.id ?? 0,
                   "customer_id" : objOrderRequest.orderDetails?.customerDetails?.id ?? 0,
                   "order_id" : objOrderRequest.orderDetails?.id ?? 0,
                   "shop_id" : USER_DETAILS?.shopId ?? 0,
                   "reject_reason" : "No delivery driver available.",
                   "is_auto_rejection" : true] as [String : Any]
        print("reject dic : \(dic)")
        socketRejectOrderRequest(dictionary: dic)
        }
    }

}
