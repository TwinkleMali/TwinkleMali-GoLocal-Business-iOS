//
//  DriverDetailsViewController.swift
//  GoLocal
//
//  Created by C110 on 03/02/21.
//

import UIKit

class DriverDetailsViewController: BaseViewController{

    @IBOutlet weak var vwNav: UIView!
    @IBOutlet weak var tableView: UITableView!
    var objDriver : Drivers!
    
    //MARK:- VARIABLES
    var dataSource: DriverDetailsDataSource?
    var viewModel = DriverSeleListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        self.dataSource = DriverDetailsDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        self.tableView.delegate = dataSource
        self.tableView.dataSource = dataSource
        self.tableView.tableFooterView = UIView()              
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
       self.navigationController?.popViewController(animated: true)
    }
    
   
}

