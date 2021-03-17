//
//  ManageBankAccountViewController.swift
//  GoLocalBusiness
//
//  Created by C110 on 21/01/21.
//

import UIKit

class ManageBankAccountViewController: BaseViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var navView: UIView!
    
    var dataSource : ManageBankAccountDataSource?
    var viewModel = ManageBankAccountViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = ManageBankAccountDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        self.tableView.delegate = dataSource
        self.tableView.dataSource = dataSource
        navView.addBottomShadow()
       
    }
    override func viewWillAppear(_ animated: Bool) {
//        self.tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: -35, right: 0)
//        tableView.contentInsetAdjustmentBehavior = .never
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func actionNavigateToAddAccount(_ sender: UIButton) {
        let vc = AddBankAccountViewController(nibName: "AddBankAccountViewController", bundle: .main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
