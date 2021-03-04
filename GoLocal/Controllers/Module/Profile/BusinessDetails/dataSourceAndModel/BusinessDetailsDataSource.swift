//
//  BusinessDetailsDataSource.swift
//  GoLocalDriver
//
//  Created by C110 on 1/02/21.
//

import Foundation
import UIKit

class BusinessDetailsDataSource: NSObject {
    //MARK:- VARIABLES
    private let tableView : UITableView
//    private let collectionView : UICollectionView
    private let viewModel: BusinessDetailsViewModel
    private let viewController: UIViewController
    private var businessDetailsViewController : BusinessDetailsViewController? {
        get{
            viewController as? BusinessDetailsViewController
        }
    }
    //MARK: - INIT
    init(tableView: UITableView,viewModel: BusinessDetailsViewModel , viewController: UIViewController) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.viewController = viewController
        tableView.register("OpenCloseTimeTVCell")
        tableView.register("BusinessDetailsTVCell")
        tableView.register("CommonTextFieldTVCell")

    }
}

extension BusinessDetailsDataSource: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return BusinessDetailField.Total.rawValue
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == BusinessDetailField.OpenCloseTime.rawValue{
            return 8
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == BusinessDetailField.OpenCloseTime.rawValue{
            return 20
        }else {
            return 0.01
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == BusinessDetailField.Images.rawValue{
           return (2 * (tableView.bounds.width - 20)/3) + 30
        }else if indexPath.section == BusinessDetailField.OpenCloseTime.rawValue{
            if indexPath.row == 0 {
                return 50
            }else{
                return UITableView.automaticDimension
            }
        }else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == BusinessDetailField.OpenCloseTime.rawValue{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextFieldTVCell") as? CommonTextFieldTVCell{
                cell.lblTitle.text = "Opening and Closing Time"
                cell.imgIcon.isHidden = true
                cell.imgIconWidthConstraint.constant = 0
                cell.textField.isHidden = true
                return cell
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case BusinessDetailField.Images.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessDetailsTVCell", for: indexPath) as? BusinessDetailsTVCell{
                cell.selectionStyle = .none
                cell.cvImages.register("BussinessImageCVCell")
                cell.cvImages.tag = indexPath.section
                let layout = UICollectionViewFlowLayout()
//                cvsizeWidth = (cell.cvImages.frame.size.width - 15 )/2
//                let cellSize = CGSize(width:cvsizeWidth  , height:  200)
                layout.itemSize = UICollectionViewFlowLayout.automaticSize
//                layout.itemSize = cellSize
                layout.scrollDirection = .vertical
                cell.cvImages.collectionViewLayout.invalidateLayout()
                cell.cvImages.setCollectionViewLayout(layout, animated: false)
                cell.cvImages.delegate = self
                cell.cvImages.dataSource = self
                cell.cvImages.reloadData()
                cell.cvImages.setNeedsLayout()
                return cell
            }
        
        case BusinessDetailField.StoreName.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextFieldTVCell", for: indexPath) as? CommonTextFieldTVCell{
                cell.selectionStyle = .none
                cell.bottomView.isHidden = true
                cell.btnHidePassword.isHidden = true
                cell.textField.isSecureTextEntry = false
                cell.lblTitle.text = "Store Name"
                cell.imgIcon.isHidden = true
                cell.imgIconWidthConstraint.constant = 0
                cell.textField.text = ""//viewModel.getEmail()
                cell.textField.delegate = self
                cell.textField.returnKeyType = .next
                cell.textField.tag = indexPath.row
                
                return cell
            }
            
        case BusinessDetailField.StoreLocation.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextFieldTVCell", for: indexPath) as? CommonTextFieldTVCell{
                cell.selectionStyle = .none
                cell.bottomView.isHidden = true
                cell.btnHidePassword.isHidden = true
                cell.textField.isSecureTextEntry = false
                cell.lblTitle.text = "Store Location"
                cell.imgIcon.isHidden = true
                cell.imgIconWidthConstraint.constant = 0
                cell.btnHidePassword.isHidden = false
                cell.btnHidePassword.setImage(UIImage(named: "order_address_pin"), for: .normal)
                cell.btnHidePassword.tintColor = UIColor(named: "AppGreenColor")
                cell.textField.text = ""//viewModel.getEmail()
                cell.textField.delegate = self
                cell.textField.returnKeyType = .next
                cell.textField.tag = indexPath.row
                
                return cell
            }
        case BusinessDetailField.Email.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextFieldTVCell", for: indexPath) as? CommonTextFieldTVCell{
                cell.selectionStyle = .none
                cell.bottomView.isHidden = true
                cell.btnHidePassword.isHidden = true
                cell.textField.isSecureTextEntry = false
                cell.lblTitle.text = "Email"
                cell.imgIcon.isHidden = true
                cell.textField.text = ""//viewModel.getEmail()
                cell.textField.delegate = self
                cell.textField.returnKeyType = .next
                cell.textField.tag = indexPath.row
                
                return cell
            }
        case BusinessDetailField.ContactNumber.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextFieldTVCell", for: indexPath) as? CommonTextFieldTVCell{
                cell.selectionStyle = .none
                cell.bottomView.isHidden = true
                cell.btnHidePassword.isHidden = true
                cell.textField.isSecureTextEntry = false
                cell.lblTitle.text = "Contact Number"
                cell.imgIcon.isHidden = true
                cell.imgIconWidthConstraint.constant = 0
                cell.textField.text = ""//viewModel.getEmail()
                cell.textField.delegate = self
                cell.textField.returnKeyType = .next
                cell.textField.tag = indexPath.row
                
                return cell
            }
            
        case BusinessDetailField.Website.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextFieldTVCell", for: indexPath) as? CommonTextFieldTVCell{
                cell.selectionStyle = .none
                cell.bottomView.isHidden = true
                cell.btnHidePassword.isHidden = true
                cell.textField.isSecureTextEntry = false
                cell.lblTitle.text = "Website"
                cell.imgIcon.isHidden = true
                cell.imgIconWidthConstraint.constant = 0
                cell.textField.text = ""//viewModel.getEmail()
                cell.textField.delegate = self
                cell.textField.returnKeyType = .next
                cell.textField.tag = indexPath.row
                
                return cell
            }
            
            
        case BusinessDetailField.DeliveryType.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextFieldTVCell", for: indexPath) as? CommonTextFieldTVCell{
                cell.selectionStyle = .none
                cell.bottomView.isHidden = true
                cell.btnHidePassword.isHidden = true
                cell.textField.isSecureTextEntry = false
                cell.lblTitle.text = "Delivery Type"
                cell.imgIcon.isHidden = true
                cell.imgIconWidthConstraint.constant = 0
                cell.textField.text = ""//viewModel.getEmail()
                cell.textField.delegate = self
                cell.textField.returnKeyType = .next
                cell.textField.tag = indexPath.row
                
                return cell
            }
            
        case BusinessDetailField.LicenseNumber.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextFieldTVCell", for: indexPath) as? CommonTextFieldTVCell{
                cell.selectionStyle = .none
                cell.bottomView.isHidden = true
                cell.btnHidePassword.isHidden = true
                cell.textField.isSecureTextEntry = false
                cell.lblTitle.text = "Business License number"
                cell.imgIcon.isHidden = true
                cell.imgIconWidthConstraint.constant = 0
                cell.textField.text = ""//viewModel.getEmail()
                cell.textField.delegate = self
                cell.textField.returnKeyType = .next
                cell.textField.tag = indexPath.row
                
                return cell
            }
            
        case BusinessDetailField.OpenCloseTime.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OpenCloseTimeTVCell", for: indexPath) as? BusinessDetailsTVCell{
                cell.selectionStyle = .none
                if indexPath.row == 0 {
                    cell.svTitle.isHidden = false
                    cell.svTime.isHidden = true
                }else{
                    cell.svTitle.isHidden = true
                    cell.svTime.isHidden = false
                }
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    
}

extension BusinessDetailsDataSource : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            print(textField.text)//self.viewModel.setEmail(value: textField.text ?? "")
        case 1:
            print(textField.text)//self.viewModel.setEmail(value: textField.text ?? "")
        case 2:
            print(textField.text)//self.viewModel.setEmail(value: textField.text ?? "")
        default:
            break
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

extension BusinessDetailsDataSource : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BussinessImageCVCell", for: indexPath) as? BussinessImageCVCell{
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 20) / CGFloat(3.0), height: (collectionView.bounds.width - 20) / CGFloat(3.0))
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7.0
    }
}
