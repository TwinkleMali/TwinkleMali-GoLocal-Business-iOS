//
//  CountryCodePickerViewController.swift
//  GoLocal
//
//  Created by C100-104on 19/12/20.
//

import UIKit

class CountryCodePickerViewController: UIViewController {

  
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var textSearch: UITextField!
    @IBOutlet weak var btnCancelSearch: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    
    //MARK:- VARIABLES
    var dataSource: CountryCodePickerViewDataSource?
    var viewModel = CountryCodePickerViewModel()
    var isFromProfile = true
    fileprivate var completionHandler: (Country) -> () = {result  in }
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = CountryCodePickerViewDataSource(tableView: tableView, textField: textSearch, viewModel: viewModel, viewController: self)
        tableView.delegate = dataSource
        tableView.dataSource =  dataSource
        textSearch.delegate = dataSource
        textSearch.addTarget(self, action: #selector(self.actiontextDidChange(_:)), for: .editingChanged)
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if viewModel.getRowCount() > 0, let selectedCountry = viewModel.getSelectedCountry() {
            let index = viewModel.getIndexOfSelectedItem(name: selectedCountry.name ?? "")
            tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)
        }
    }
    @IBAction func actionBack(_ sender: Any) {
        if self.viewModel.getRowCount() > 0{
            completionHandler(viewModel.getSelectedCountry()!)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionDone(_ sender: Any) {
        if self.viewModel.getRowCount() > 0{
            completionHandler(viewModel.getSelectedCountry()!)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionCancelSearch(_ sender: Any) {
        self.textSearch.text = ""
        self.lblNoData.isHidden = true
        viewModel.turnSearch(false)
        self.tableView.reloadData()
    }
    @IBAction func actiontextDidChange
    (_ sender: UITextField) {
        print(sender.text)
        let text = sender.text
        viewModel.turnSearch(text?.count ?? 0 > 0)
        viewModel.searchData(fromValue: text ?? "")
        if viewModel.getRowCount() > 0 {
            self.lblNoData.isHidden = true
            tableView.isHidden = false
        }else {
            self.lblNoData.isHidden = false
            tableView.isHidden = true
        }
        tableView.reloadData()
    }
    
    func setUpView(selectedCountry : Country?, completion: @escaping (Country) -> ()){
        if let country = selectedCountry {
            self.viewModel.setSelectedCountry(value: country)
        }
        self.completionHandler = completion
    }
}
