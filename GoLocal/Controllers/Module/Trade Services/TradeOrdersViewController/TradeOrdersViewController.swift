//
//  TradeOrdersViewController.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 03/05/21.
//

import UIKit
import Alamofire
class TradeOrdersViewController: BaseViewController,BottomSheetDelegate, CalenderViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var lblOrder: UILabel!
    @IBOutlet weak var btnActiveOrder: UIButton!
    @IBOutlet weak var btnPastOrder: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblOrderNotFound: UILabel!
    @IBOutlet weak var viewSwitch: UIView!{
        didSet{
            viewSwitch.layer.cornerRadius = 5
            viewSwitch.layer.borderWidth = 0.8
            viewSwitch.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.8).cgColor
            viewSwitch.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var viewPastSelectedFilterData: UIView!
    @IBOutlet weak var lblSelectedDataTitle: UILabel!
    @IBOutlet weak var lblSelectedDataValue: UILabel!
    @IBOutlet weak var filterSelectedDataViewHeight: NSLayoutConstraint! {
        didSet{
            filterSelectedDataViewHeight.constant = 0
        }
    }
    
    var selectedDate : Date = Date()
    var dataSource: TradeOrderViewDataSource?
    var viewModel = TradeOrderViewModel()
    private let refresher = UIRefreshControl()
    var isScrolling = false
    var isLoader : Bool = false
    var monthSelected = -1, yearSelected = ""
    var selOrder = OrderType.CurrentOrder.rawValue

//    // For Pull to Referesh
//    @objc private func initialRequest(_ sender: Any) {
//            tableView.refreshControl = refresher
//            isLoader = false
//            self.offset = 0
////            callAPIToGetOrder()
//    }
//
//    func loadMoreRequest() {
//        isLoader = false
//        offset = offset + 1
////        callAPIToGetOrder()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = TradeOrderViewDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        // Do any additional setup after loading the view.
        nc.addObserver(self, selector: #selector(updateServicesStatusResponse(notification:)), name: Notification.Name(notificationCenterKeys.changeTradeServiceStatus.rawValue), object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getTradeOrders()
    }
    @IBAction func btnFilterOrder(_ sender: UIButton) {
        let vc = BottomSheetVC(nibName: "BottomSheetVC", bundle: nil)
        vc.arrOptions = ["Date","Monthly"]
        vc.strTitle = "Filter"
        vc.selectedOption = viewModel.getFilterOption().rawValue - 1
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func actionTabValueChange(_ sender: UIButton) {
        if sender == btnActiveOrder{
            selOrder = OrderType.CurrentOrder.rawValue
            sender.backgroundColor = GreenColor
            sender.isSelected = true
            btnPastOrder.backgroundColor = .white
            btnPastOrder.isSelected = false
            btnFilter.isHidden = true
            viewModel.setCurrentOption(value: 1)
            viewModel.setFilterOption(value: .none)
            viewModel.setSelectedDate(value: "")
            viewModel.setSelectedMonth(value: "")
            viewModel.setSelectedYear(value: "")
            viewModel.UpdateLoadMore(value: false)
            viewModel.resetPageCount()
            filterSelectedDataViewHeight.constant = 0
            self.view.layoutIfNeeded()
        }else {
            selOrder = OrderType.PastOrder.rawValue
            sender.backgroundColor = GreenColor
            sender.isSelected = true
            btnActiveOrder.backgroundColor = .white
            btnActiveOrder.isSelected = false
            btnFilter.isHidden = false
            if viewModel.getFilterOption() == .none {
                filterSelectedDataViewHeight.constant = 0
                self.view.layoutIfNeeded()
            }
            viewModel.setCurrentOption(value: 2)
        }
        self.tableView.reloadData()
//        viewModel.removeAllCurrentOrder(orderType: selOrder)
//        callAPIToGetOrder()
        self.getTradeOrders()
    }
    
    func didSelectOption(selValue: String) {
        if selValue == "Date"{
            //arrDates = getWeekDates(from: Date())
            let calendarView = CalanderViewController(nibName: "CalanderViewController", bundle: nil)
            calendarView.currDate = selectedDate
            calendarView.usedFor =  .single
            calendarView.delegate = self
            calendarView.modalPresentationStyle = .overFullScreen
            self.present(calendarView, animated: false, completion: nil)
            
        }else if selValue == "Monthly"{
            let monthView = MonthCalanderViewController(nibName: "MonthCalanderViewController", bundle: nil)
            monthView.delegateMonthCalander = self
            monthView.selectedMonth = monthSelected != 0 ? monthSelected - 1 : monthSelected
            monthView.selectedYear = yearSelected
            monthView.modalPresentationStyle = .overFullScreen
            
            self.present(monthView, animated: false, completion: nil)
        } else if selValue == "Clear"{
            viewModel.setFilterOption(value: .none)
            viewModel.setSelectedDate(value: "")
            viewModel.setSelectedMonth(value: "")
            viewModel.setSelectedYear(value: "")
            self.filterSelectedDataViewHeight.constant = 0
            self.viewPastSelectedFilterData.isHidden = true
            self.view.layoutIfNeeded()
            self.view.layoutIfNeeded()
            self.getTradeOrders()
        }
        
    }
    
    func selectedWeekDates(dates: [Date]) {
        let selectedDate = dates[0].toString(format: "yyyy-MM-dd")
        self.selectedDate = dates.first ?? Date()
        self.viewModel.setFilterOption(value: .date)
        self.lblSelectedDataTitle.text = "Date : "
        self.lblSelectedDataValue.text = selectedDate
        self.viewModel.setSelectedDate(value: selectedDate)
        viewModel.setSelectedMonth(value: "")
        viewModel.setSelectedYear(value: "")
        self.getTradeOrders()
        self.filterSelectedDataViewHeight.constant = 80
        self.viewPastSelectedFilterData.isHidden = false
        self.view.layoutIfNeeded()
        //self.viewModel.removeAllCurrentOrder(orderType: 2)
        
    //    callAPIToGetOrder(filterType: 1, date: selectedDate, year: "", month: "")
    }
    
    @objc func updateServicesStatusResponse(notification:Notification){
        
        if let userInfo = notification.userInfo{
            let dict = userInfo as NSDictionary
            if let status = dict["status"] as? Int ,let message = dict["message"] as? String{
                self.showBanner(bannerTitle: .none, message: message, type: .warning)
                if status == 1 {
                    self.getTradeOrders()
                    //completionHandler(.success)
                }
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
    
}
extension TradeOrdersViewController: MonthCalanderDelegate{
    func getSelectedMonth(vc: MonthCalanderViewController, selectedmonth: Int,year: String,yearString: String) {
//        arrYear = vc.arrYears
//        month = selectedmonth
        monthSelected = selectedmonth
        yearSelected = year
        var monthString = ""
        if selectedmonth == 10 || selectedmonth == 11 || selectedmonth == 12{
            monthString = String(selectedmonth).description
        }else{
            monthString = "0" + String(selectedmonth).description
        }
        let finalMonthString = getMonthfrom(selectedmonth) + "/" + year
        self.lblSelectedDataTitle.text = "Month/Year : "
        self.lblSelectedDataValue.text = finalMonthString
        print("SELECTED Month/Year : ",finalMonthString)
        self.viewModel.setFilterOption(value: .month)
        self.viewModel.setSelectedDate(value: "")
        viewModel.setSelectedMonth(value: monthString)
        viewModel.setSelectedYear(value: year)
        self.getTradeOrders()
        self.filterSelectedDataViewHeight.constant = 80
        self.viewPastSelectedFilterData.isHidden = false
        self.view.layoutIfNeeded()
//        self.viewModel.removeAllCurrentOrder(orderType: 2)
//        callAPIToGetOrder(filterType: 2, date: "", year: year, month: monthString)
//        getEarningDataFromAPI(startDate: startDate, endDate: endDate,filterType: filterType,todayDate: todayDate,selectedMonth: finalMonthString)
//        btnDateRangeTitle.setTitle(yearString + ", " + year, for: .normal)
    }
    
    
}
