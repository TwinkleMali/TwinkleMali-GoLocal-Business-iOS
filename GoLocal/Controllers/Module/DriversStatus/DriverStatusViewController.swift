//
//  DriverStatusViewController.swift
//  GoLocal
//
//  Created by C110 on 03/02/21.
//

import UIKit

class DriverStatusViewController: BaseViewController{
    
    @IBOutlet weak var vwNav: UIView!
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
        }
    }
    var objOrderRequest : OrderRequests!
    @IBOutlet weak var tableView: UITableView!
    var selectedDriverId : Int!
    let datePicker = UIDatePicker()
    var pickupTime : Int = 0
    var deliveryTimes : Int = 0
    var selectedMin : Int!
    //MARK:- VARIABLES
    var dataSource: DriverStatusViewDataSource?
    var viewModel = DriverStatusViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = DriverStatusViewDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        self.tableView.delegate = dataSource
        self.tableView.dataSource = dataSource
        self.tableView.estimatedRowHeight = 50
        self.tableView.tableFooterView = UIView()        
    }
    
    override func viewWillAppear(_ animated: Bool) {        
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
       self.navigationController?.popViewController(animated: true)
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

