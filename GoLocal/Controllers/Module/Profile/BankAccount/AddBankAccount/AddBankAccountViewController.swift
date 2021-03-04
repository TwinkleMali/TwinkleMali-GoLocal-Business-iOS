//
//  AddBankAccountViewController.swift
//  GoLocalDriver
//
//  Created by C100-142 on 21/01/21.
//

import UIKit

class AddBankAccountViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var mainView: CardView!
    
    var dataSource : AddBankAccountDataSource?
    var viewModel = AddBankAccountViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = AddBankAccountDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        self.tableView.delegate = dataSource
        self.tableView.dataSource = dataSource

    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func actionAddAccount(_ sender: UIButton) {
        print("Add")
    }
    @objc func actionAccountType(_ sender: UIButton) {
        let cell = tableView.cellForRow(at: IndexPath(row: AddAccountField.accountType.rawValue, section: 0)) as! AddAccountTextFieldTVCell
        if(sender == cell.btnSaving) {

            cell.imgRadioOption.image = #imageLiteral(resourceName: "icon_radio_select")
            cell.imgRadioOption1.image = #imageLiteral(resourceName: "icon_radio_unselect")
            
        } else {

            cell.imgRadioOption.image = #imageLiteral(resourceName: "icon_radio_unselect")
            cell.imgRadioOption1.image = #imageLiteral(resourceName: "icon_radio_select")
        }
        tableView.reloadData()
        
    }
    @objc func actionBankSelection(_ sender: UIButton) {
        let cell = tableView.cellForRow(at: IndexPath(row: AddAccountField.bankName.rawValue, section: 0)) as! AddAccountTextFieldTVCell
        cell.textField.text = "select"
        print("select")
        
    }
}
