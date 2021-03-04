//
//  BusinessDetailsViewController.swift
//  GoLocal
//
//  Created by C110 on 1/2/21.
//

import UIKit

class BusinessDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navView: UIView!
    var dataSource: BusinessDetailsDataSource?
    var viewModel = BusinessDetailsViewModel()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = BusinessDetailsDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        self.tableView.delegate = dataSource
        self.tableView.dataSource = dataSource
        self.navView.addBottomShadow()
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
