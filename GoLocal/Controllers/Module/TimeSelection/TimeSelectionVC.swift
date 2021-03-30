//
//  TimeSelectionVC.swift
//  GoLocal
//
//  Created by C110 on 16/02/21.
//

import Foundation

class TimeSelectionVC: BaseViewController {
    
    @IBOutlet weak var txtPickupTime: UITextField!
    var objOrderRequest : OrderRequests!
    var pickupTimeSec : Int = 0
    var pickupTimeMin : Int = 0
    @IBOutlet var lblTime: MZTimerLabel!
    let datePicker = UIDatePicker()
    @IBOutlet weak var vwTimer: UIView!
    var orderRequestTime : TimeInterval = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()   
        txtPickupTime.text = "\(pickupTimeMin) Minutes"
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
        let obj  = notification.userInfo as? [String : Any]
        if obj?["status"] as! Bool{
            self.view.makeToast(obj?["message"] as? String,duration: 2.0, position: .center)
        }else {
            self.view.makeToast(obj?["message"] as? String,duration: 2.0, position: .center)
        }
        APP_DELEGATE?.setupRootTabBarViewController(tabIndex: 1)
    }
    
    //MARK:- Button Click Methods
    @IBAction func btnSelectDriver(_ sender: UIButton) {
        if pickupTimeSec == 0{
            self.showBanner(bannerTitle: .none, message: "Please select pickup time.", type: .danger)
        }else {
            let dic = ["user_id" : USER_DETAILS?.id ?? 0,
                       "customer_id" : objOrderRequest.customerId ?? 0 ,
                       "order_id" : objOrderRequest.orderId ?? 0,
                       "driver_id" : 0,
                       "pickup_time" : pickupTimeSec,
                       "delivery_time" : 0,
                       "need_to_merge" : 0,
                       "merge_request_id":0,
                       "merge_with_order_id":0] as [String : Any]
            print("accept dic : \(dic)")
            socketAcceptOrderRequest(dictionary: dic)
        }
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: -   DatePicker Methods
    func showDatePicker(textfield : UITextField){
            //Formate Date
            datePicker.datePickerMode = .dateAndTime
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
            pickupTimeSec = datePicker.date.seconds(from: Date())
            pickupTimeMin = datePicker.date.minutes(from: Date())
            txtPickupTime.text = "\(pickupTimeMin) Minutes"
            loadViewIfNeeded()
            self.view.endEditing(true)
        }
    
    
}

extension TimeSelectionVC : MZTimerLabelDelegate {
    func timerLabel(_ timerLabel: MZTimerLabel!, finshedCountDownTimerWithTime countTime: TimeInterval){
        if APP_DELEGATE?.arrOrderRequestMain.contains(where: { $0.orderDetails?.id == objOrderRequest.orderDetails?.id }) == true {
        print("Order Request Time out on TimeSelection screen for \(objOrderRequest.orderId ?? 0)")
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

//MARK:- TextField Delegate
extension TimeSelectionVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showDatePicker(textfield: textField)
    }
}

