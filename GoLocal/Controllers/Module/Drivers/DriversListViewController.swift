//
//  DriversListViewController.swift
//  GoLocal
//
//  Created by C110 on 18/1/21.
//

import UIKit

class DriversListViewController: BaseViewController{

    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var vwNav: UIView!
    @IBOutlet weak var btnCancelSearch: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var vwSearch: UIView!
    {
        didSet{
            vwSearch.layer.cornerRadius = 7
            vwSearch.layer.borderColor = UIColor.lightGray.cgColor
            vwSearch.layer.borderWidth = 1
            
        }
    }
    @IBOutlet weak var searchHeight: NSLayoutConstraint!
    var isSearch : Bool = false
    
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.text = "Select Driver"
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK:- VARIABLES
    var dataSource: DriverListViewDataSource?
    var viewModel = DriverSeleListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = DriverListViewDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        self.tableView.delegate = dataSource
        self.tableView.dataSource = dataSource
        self.tableView.tableFooterView = UIView()
        searchHeight.constant = 0
        getAllBusinessDriverList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    @IBAction func TextChange(_ sender: UITextField) {
        viewModel.setSearchedText(text: sender.text ?? "")
        self.tableView.reloadData()
    }
    @IBAction func cancelSearch(_ sender: Any) {
        if isSearch {
            searchHeight.constant = 0
            isSearch = false
            textField.text = ""
            textField.endEditing(true)
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
            viewModel.updateSearch(isSearch)
            viewModel.setSearchedText(text: "")
            tableView.reloadData()
        }
    }
    
    @IBAction func actionSearch(_ sender: Any) {
        if isSearch {
            searchHeight.constant = 0
            isSearch = false
        }else {
            searchHeight.constant = 45
            isSearch = true
        }
        viewModel.updateSearch(isSearch)
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }   
   
}

