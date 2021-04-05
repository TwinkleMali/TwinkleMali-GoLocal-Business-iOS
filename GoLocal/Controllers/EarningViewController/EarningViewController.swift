//
//  EarningViewController.swift
//  GoLocal
//
//  Created by C100-104 on 19/03/21.
//

import UIKit

class EarningViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewSelectedDate: UIView!{
        didSet{
            viewSelectedDate.layer.cornerRadius = 8
            viewSelectedDate.layer.borderWidth = 0.5
            viewSelectedDate.layer.borderColor = UIColor.gray.cgColor
        }
    }
    @IBOutlet weak var lblSelectedDate: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK:-Variables
    var dataSource: EarningViewDataSource?
    var viewModel =  EarningViewModel()
    var selectedDate = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = EarningViewDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
    }


    @IBAction func btnOpenCalendar(_ sender: Any) {
        let calendarView = CalanderViewController(nibName: "CalanderViewController", bundle: nil)
        calendarView.currDate = selectedDate
        calendarView.usedFor =  .single
        //calendarView.isForMonthly = true
        calendarView.delegate = self
        calendarView.modalPresentationStyle = .overFullScreen
        self.present(calendarView, animated: false, completion: nil)
    }
    
}
extension EarningViewController : CalenderViewDelegate {
    func selectedWeekDates(dates: [Date]) {
        let selectedDate = dates[0].toString(format: "dd MMMM yyyy")
        self.selectedDate = dates.first ?? Date()
        print("SelectedDate",selectedDate)
        self.lblSelectedDate.text = selectedDate
        
        //self.viewModel.removeAllCurrentOrder(orderType: 2)
        //callAPIToGetOrder(filterType: 1, date: selectedDate, year: "", month: "")
    }
}
