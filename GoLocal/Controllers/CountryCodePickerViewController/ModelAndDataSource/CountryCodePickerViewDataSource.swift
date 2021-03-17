//
//  CountryCodePickerViewDataSource.swift
//  GoLocal
//
//  Created by C100-104 on 04/01/21.
//

import Foundation
import UIKit

class CountryCodePickerViewDataSource : NSObject{
    //MARK:- VARIABLES
    private let tableView : UITableView
    private let textField : UITextField
    private let viewModel: CountryCodePickerViewModel
    private let viewController: UIViewController
    private var countryCodePickerViewController : CountryCodePickerViewController? {
        get{
            viewController as? CountryCodePickerViewController
        }
    }
    init(tableView: UITableView,textField : UITextField, viewModel: CountryCodePickerViewModel , viewController: UIViewController) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.textField = textField
        self.viewController = viewController
        tableView.allowsMultipleSelection = false
        //self.tableView.register("SingleUserReviewTVCell")
    }
}
extension CountryCodePickerViewDataSource : UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel.getRowCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        let data = viewModel.getCountry(atPos: indexPath.row)
        cell.textLabel?.text = "(+\(data.phonecode ?? 0)) \(data.name ?? "")"
        if let selected = viewModel.getSelectedCountry() , viewModel.isSelected(value: selected.sortname ?? "", atPosition: indexPath.row) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.getCountry(atPos: indexPath.row)
        viewModel.setSelectedCountry(value: data)
//        currentCountry = isSearch ? arrSearch[indexPath.row] : arrCountries[indexPath.row]
        tableView.reloadData()
    }
}
extension CountryCodePickerViewDataSource : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
