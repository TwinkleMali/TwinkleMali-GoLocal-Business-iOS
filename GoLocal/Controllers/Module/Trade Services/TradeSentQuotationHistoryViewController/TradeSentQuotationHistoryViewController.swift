//
//  TradeSentQuotationHistoryViewController.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 22/06/21.
//

import UIKit

class TradeSentQuotationHistoryViewController: BaseViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    
    
    var viewModel = TradeOrderViewModel()
    var dataSource : TradeSentQuotationHistoryViewDataSource?
    var isScrolling = false
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = TradeSentQuotationHistoryViewDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        getPendingQuotions()
    }

    @IBAction func actionBack(_ sender: Any) {
        self.back(withAnimation: true)
    }
    

}
