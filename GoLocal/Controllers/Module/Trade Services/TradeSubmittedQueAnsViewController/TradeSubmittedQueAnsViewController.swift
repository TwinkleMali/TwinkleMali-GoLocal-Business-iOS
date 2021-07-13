//
//  TradeSubmittedQueAnsViewController.swift
//  GoLocal
//
//  Created by C100-104 on 02/06/21.
//

import UIKit

class TradeSubmittedQueAnsViewController: BaseViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.text = "Submitted Request Details"
        }
    }
    @IBOutlet weak var tableView: UITableView!

    let viewModel = TradeSubmittedQueAnsViewModel()
    var dataSource : TradeSubmittedQueAnsViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = TradeSubmittedQueAnsViewDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        self.tableView.delegate = dataSource
        self.tableView.dataSource = dataSource
        
    }

    @IBAction func actionBack(_ sender: Any) {
        self.back(withAnimation: true)
    }
    
}
