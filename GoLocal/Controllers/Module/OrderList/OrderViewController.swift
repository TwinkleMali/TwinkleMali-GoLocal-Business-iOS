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
    
    func callAPIToGetOrder(filterType :Int = 0,date : String = "",year : String = "",month :String = ""){//  filter_type: 1-Date 2-Month : 1-> filter_date in yyyy-MM-dd format | 2-> filter_year ,filter_month in yyyy and MM format
        let  param : [String : Any] = [
            "user_id" : 30,// USER_DETAILS?.id ?? 0,
            "shop_id" : 1, //USER_DETAILS?.shopId ?? 0,
            "order_option" : selOrder,
            "filter_type" : filterType,
            "filter_date" : date,
            "filter_year" : year,
            "filter_month" : month,
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
        if sender == btnCurrentOrders{
            selOrder = OrderType.CurrentOrder.rawValue
            sender.backgroundColor = GreenColor
            sender.isSelected = true
            btnPastOrders.backgroundColor = .white
            btnPastOrders.isSelected = false
            btnFilter.isHidden = true
        }else {
            selOrder = OrderType.PastOrder.rawValue
            sender.backgroundColor = GreenColor
            sender.isSelected = true
            btnCurrentOrders.backgroundColor = .white
            btnCurrentOrders.isSelected = false
            btnFilter.isHidden = false
        }
        viewModel.removeAllCurrentOrder(orderType: selOrder)
        callAPIToGetOrder()
    }
    
    @IBAction func btnFilterOrder(_ sender: UIButton) {
        let vc = BottomSheetVC(nibName: "BottomSheetVC", bundle: nil)
        vc.arrOptions = ["Date","Monthly"]
        vc.strTitle = "Filter"
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
        }
        
    }
    
    func selectedWeekDates(dates: [Date]) {
        let selectedDate = dates[0].toString(format: "yyyy-MM-dd")
        self.selectedDate = dates.first ?? Date()
        self.viewModel.removeAllCurrentOrder(orderType: 2)
        callAPIToGetOrder(filterType: 1, date: selectedDate, year: "", month: "")
    }
}
extension OrderViewController: MonthCalanderDelegate{
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
        let finalMonthString = year + "-" + monthString
        print("SELECTED YEAR _ MONTH : ",finalMonthString)
        self.viewModel.removeAllCurrentOrder(orderType: 2)
        callAPIToGetOrder(filterType: 2, date: "", year: year, month: monthString)
//        getEarningDataFromAPI(startDate: startDate, endDate: endDate,filterType: filterType,todayDate: todayDate,selectedMonth: finalMonthString)
//        btnDateRangeTitle.setTitle(yearString + ", " + year, for: .normal)
    }
    
    
}
