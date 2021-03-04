//
//  PaymentOptionViewController.swift
//  GoLocal
//
//  Created by C110 on 18/1/21.
//

import UIKit

class PaymentOptionViewController: BaseViewController{
  
    @IBOutlet weak var vwNav: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK:- VARIABLES
    var dataSource: PaymentOptionDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = PaymentOptionDataSource(tableView: tableView, viewController: self)
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

