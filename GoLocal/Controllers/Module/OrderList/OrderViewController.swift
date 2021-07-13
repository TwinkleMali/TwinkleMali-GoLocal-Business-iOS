//
//  OrderViewController.swift
//  GoLocalDriver
//
//  Created by C100-142 on 11/01/21.
//

import UIKit

class OrderViewController: BaseViewController, BottomSheetDelegate, CalenderViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var lblNoMsg : UILabel!
    @IBOutlet weak var tableView : UITableView!{
        didSet{
            tableView.tag = 100
            self.tableView.backgroundColor = .white
        }
    }
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var switchView: UIView!
    @IBOutlet weak var switchStackView: UIStackView!
    @IBOutlet weak var btnCurrentOrders: UIButton!
    @IBOutlet weak var btnPastOrders: UIButton!
    @IBOutlet weak var viewPastSelectedFilterData: UIView!
    @IBOutlet weak var lblSelectedDataTitle: UILabel!
    @IBOutlet weak var lblSelectedDataValue: UILabel!
    @IBOutlet weak var filterSelectedDataViewHeight: NSLayoutConstraint! {
        didSet{
            filterSelectedDataViewHeight.constant = 0
        }
    }
    
    var selectedDate : Date = Date()
    var dataSource: OrderDataSource?
    var viewModel = OrderViewModel()
    private let refresher = UIRefreshControl()
    var isLoader : Bool = false
    //Load more
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var offset = 0
    var isLoadMore:Bool = false
    var monthSelected = -1, yearSelected = ""
    var selOrder = OrderType.CurrentOrder.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGUI()
        dataSource = OrderDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        self.tableView.delegate = dataSource
        self.tableView.dataSource = dataSource
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        self.tableView.tableFooterView = UIView()
        isLoader = true
        callAPIToGetOrder()
//        refresher.addTarget(self, action: #selector(initialRequest(_:)), for: .valueChanged)
//        tableView.refreshControl = refresher
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: -25, right: 0)
//        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    // For Pull to Referesh
    @objc private func initialRequest(_ sender: Any) {
            tableView.refreshControl = refresher
            isLoader = false
            self.offset = 0
            callAPIToGetOrder()
    }
    
    func loadMoreRequest() {
        isLoader = false
        offset = offset + 1
        callAPIToGetOrder()
    }
    
    func callAPIToGetOrder(){//  filter_type: 1-Date 2-Month : 1-> filter_date in yyyy-MM-dd format | 2-> filter_year ,filter_month in yyyy and MM format
        let  param : [String : Any] = [
            "user_id" :  USER_DETAILS?.id ?? 0,
            "shop_id" : USER_DETAILS?.shopId ?? 0,
            "order_option" : selOrder,
            "filter_type" : viewModel.getFilterOption().rawValue,
            "filter_date" : viewModel.getSelectedDate(),
            "filter_year" : viewModel.getSelectedYear(),
            "filter_month" : viewModel.getSelectedMonth(),
            "page_num" : offset
        ]
        getListOfOrders(param: param)
    }
    
    func setupGUI() {
        self.btnFilter.isHidden = true
        updateViewConstraints()
        self.view.layoutIfNeeded()
        switchView.backgroundColor = .lightGray
        drawBorder(view: switchView, color: .lightGray, width: 1.0, radius: 5.0)
        drawBorder(view: switchStackView, color: .lightGray, width: 1.0, radius: 5.0)
        btnCurrentOrders.backgroundColor = GreenColor
        btnPastOrders.backgroundColor = .white
        btnCurrentOrders.setTitle("Current Orders", for: .normal)
        btnPastOrders.setTitle("Past Orders", for: .normal)
        btnCurrentOrders.titleLabel?.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 16.0))
        btnPastOrders.titleLabel?.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 16.0))
        
        btnCurrentOrders.setTitleColor(.white, for: .selected)
        btnCurrentOrders.setTitleColor(.lightGray, for: .normal)
        
        btnPastOrders.setTitleColor(.white, for: .selected)
        btnPastOrders.setTitleColor(.lightGray, for: .normal)
    }
    
    
    
    
    @IBAction func actionTabValueChange(_ sender: UIButton) {
        tableView.isScrollEnabled = false
        if sender == btnCurrentOrders{
//            tableView.scrollToTop()
            selOrder = OrderType.CurrentOrder.rawValue
            sender.backgroundColor = GreenColor
            sender.isSelected = true
            btnPastOrders.backgroundColor = .white
            btnPastOrders.isSelected = false
            btnFilter.isHidden = true
            
//            viewModel.setCurrentOption(value: 1)
            viewModel.setFilterOption(value: .none)
            viewModel.setSelectedDate(value: "")
            viewModel.setSelectedMonth(value: "")
            viewModel.setSelectedYear(value: "")
            filterSelectedDataViewHeight.constant = 0
            
//            viewModel.UpdateLoadMore(value: false)
//            viewModel.resetPageCount()
        }else {
//            tableView.scrollToTop()
            selOrder = OrderType.PastOrder.rawValue
            sender.backgroundColor = GreenColor
            sender.isSelected = true
            btnCurrentOrders.backgroundColor = .white
            btnCurrentOrders.isSelected = false
            btnFilter.isHidden = false
            if viewModel.getFilterOption() == .none {
                filterSelectedDataViewHeight.constant = 0
                self.view.layoutIfNeeded()
            }
        }
        isLoadMore = false
        offset = 0
        viewModel.removeAllCurrentOrder(orderType: selOrder)
        callAPIToGetOrder()
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
    
//    @objc func actionOrderDetail(_ sender : UIButton) {
//        let vc = OrderDetailsViewController(nibName: "OrderDetailsViewController", bundle: .main)
//        vc.isOrderRequest = false
//        vc.
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
    // Order Request Detail Click
    @objc func actionOrderDetail(_ sender : UIButton) {
        let vc = OrderDetailsViewController(nibName: "OrderDetailsViewController", bundle: .main)
        vc.isOrderRequest = false
        let tag = sender.tag
        let section = tag/100
         let row = tag % 100
        //let index : Int = sender.accessibilityValue.aIntOrEmpty()
        vc.arrOrders = viewModel.getArrOrder(listAt: section,orderType: selOrder) ?? []
        //vc.viewModel.setOrderDetail(objOrder: viewModel.getOrder(listAt: 0, orderAt: sender.tag, orderType: selOrder))
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Order on map Click
    @objc func actionMarkOrderLeft(_ sender : UIButton) {
        if let driver =  viewModel.getOrder(listAt: 0, orderAt: sender.tag, orderType: selOrder).driverDetails {
            let tag = sender.tag
            let section = tag/100
             let row = tag % 100
            let vc = DriverLocationViewController.loadFromNib()
            vc.driverDetails = driver
            vc.orderId = viewModel.getOrder(listAt: 0, orderAt: sender.tag, orderType: selOrder).id ?? 0
            vc.driverLat = driver.latitude ?? "21.1205"
            vc.driverLong = driver.longitude ?? "72.7431"
            vc.deliveryLatitude = viewModel.getOrder(listAt: section, orderAt: row, orderType: selOrder).deliveryLatitude ?? ""
            vc.deliveryLongitude = viewModel.getOrder(listAt: section, orderAt: row, orderType: selOrder).deliveryLongitude ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
//        let vc = OrderDetailsViewController(nibName: "OrderDetailsViewController", bundle: .main)
//        vc.objOrder = viewModel.getOrder(at: sender.tag, orderType: selOrder)
//        self.navigationController?.pushViewController(vc, animated: true)
    
    
    func didSelectOption(selValue: String) {
        if selValue == "Date"{
            //arrDates = getWeekDates(from: Date())
            let calendarView = CalanderViewController(nibName: "CalanderViewController", bundle: nil)
            calendarView.currDate = selectedDate
            calendarView.usedFor =  .single
            //calendarView.isForMonthly = true
            calendarView.delegate = self
            calendarView.modalPresentationStyle = .overFullScreen
            self.present(calendarView, animated: false, completion: nil)
        }else if selValue == "Monthly"{
            let monthView = MonthCalanderViewController(nibName: "MonthCalanderViewController", bundle: nil)
            monthView.delegateMonthCalander = self
            monthView.selectedMonth = monthSelected != 0 ? monthSelected - 1 : monthSelected
            monthView.selectedYear = yearSelected
//            monthView.arrYears = arrYear
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
            self.callAPIToGetOrder()
        }
        
    }
    
    func selectedWeekDates(dates: [Date]) {
        let selectedDate = dates[0].toString(format: "yyyy-MM-dd")
        self.viewModel.setFilterOption(value: .date)
        self.lblSelectedDataTitle.text = "Date : "
        self.lblSelectedDataValue.text = selectedDate
        self.viewModel.setSelectedDate(value: selectedDate)
        viewModel.setSelectedMonth(value: "")
        viewModel.setSelectedYear(value: "")
        self.filterSelectedDataViewHeight.constant = 80
        self.viewPastSelectedFilterData.isHidden = false
        self.view.layoutIfNeeded()
        self.viewModel.removeAllCurrentOrder(orderType: 2)
        callAPIToGetOrder()
    }
}
extension OrderViewController: MonthCalanderDelegate{
    func getSelectedMonth(vc: MonthCalanderViewController, selectedmonth: Int,year: String,yearString: String) {
        let finalMonthString = getMonthfrom(selectedmonth) + "/" + year
        self.lblSelectedDataTitle.text = "Month/Year : "
        self.lblSelectedDataValue.text = finalMonthString
        var monthString = ""
        if selectedmonth == 10 || selectedmonth == 11 || selectedmonth == 12{
            monthString = String(selectedmonth).description
        }else{
            monthString = "0" + String(selectedmonth).description
        }
        print("SELECTED Month/Year : ",finalMonthString)
        self.viewModel.setFilterOption(value: .month)
        self.viewModel.setSelectedDate(value: "")
        viewModel.setSelectedMonth(value: monthString)
        viewModel.setSelectedYear(value: year)
        self.filterSelectedDataViewHeight.constant = 80
        self.viewPastSelectedFilterData.isHidden = false
        self.view.layoutIfNeeded()
        self.viewModel.removeAllCurrentOrder(orderType: 2)
        callAPIToGetOrder()
//        getEarningDataFromAPI(startDate: startDate, endDate: endDate,filterType: filterType,todayDate: todayDate,selectedMonth: finalMonthString)
//        btnDateRangeTitle.setTitle(yearString + ", " + year, for: .normal)
    }
    
    
}
