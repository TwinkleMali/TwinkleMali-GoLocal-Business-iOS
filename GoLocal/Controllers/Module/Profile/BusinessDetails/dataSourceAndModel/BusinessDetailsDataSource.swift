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
        tableView.register("ImageSliderTVCell")
    }
}

extension BusinessDetailsDataSource: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.getBusinessDetail() != nil{
            return BusinessDetailField.Total.rawValue
        }
        return 0
    }    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == BusinessDetailField.OpenCloseTime.rawValue{
            return 9
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == BusinessDetailField.Images.rawValue{
            if businessDetailsViewController?.isEditEnable == true{
                return (2 * (tableView.bounds.width - 20)/3) + 30
            }else {
                return 250
            }
        }else if indexPath.section == BusinessDetailField.OpenCloseTime.rawValue{
            if indexPath.row == 0 {
                return 30
            }else if indexPath.row == 1 {
                return 50
            }
        }
        return UITableView.automaticDimension        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case BusinessDetailField.Images.rawValue:
            if businessDetailsViewController?.isEditEnable == true{
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
            }else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "ImageSliderTVCell", for: indexPath) as? BusinessDetailsTVCell{
                    cell.selectionStyle = .none
                    if let images: [SliderImages] = viewModel.getBusinessDetail()?.sliderImages {
                        var arrimg: [String] = []
                        var image_is_available_count = 0
                        for image in images {
                            if let imgName = image.image {
                                let imgName1 = imgName.components(separatedBy: "/").last ?? ""
                                var finalPath = PATH_shopGallery.replacingOccurrences(of: "{ImageName}", with: imgName1) // + "/" + imgName
                                finalPath = finalPath.replacingOccurrences(of: "{Id}", with: "\(USER_DETAILS?.shopId ?? 0)")
                                //let imgUrl = URL(string: finalPath)
                                arrimg.append(finalPath)
                                image_is_available_count  += 1
                            }
                        }
                        cell.pageControl.numberOfPages = arrimg.count
                        cell.pageControl.currentPage = 0
//                        cell.viewimageSlider.delegate = self
                            
                        cell.viewimageSlider.setCarouselData(paths: arrimg, describedTitle: [], isAutoScroll: true, timer: 2, defaultImage: "product_details_placeholder")
                            
                        cell.viewimageSlider.setCarouselOpaque(layer: false, describedTitle: false, pageIndicator: false)
                        cell.viewimageSlider.setCarouselLayout(displayStyle: 0, pageIndicatorPositon: 2, pageIndicatorColor: .clear, describedTitleColor: .clear, layerColor: .clear)
                            
                        }
                    }
            }
            
        
        case BusinessDetailField.StoreName.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextFieldTVCell", for: indexPath) as? CommonTextFieldTVCell{
                cell.selectionStyle = .none
                cell.stviewRadio.isHidden = true
                cell.bottomView.isHidden = true
                cell.btnHidePassword.isHidden = true
                cell.textField.isSecureTextEntry = false
                cell.lblTitle.text = "Store Name"
                cell.imgIcon.isHidden = true
                if businessDetailsViewController?.isEditEnable == true{
                    cell.lblTitle.alpha = 1
                    cell.textField.alpha = 1
                    cell.imgIcon.alpha = 1
                    cell.textField.isUserInteractionEnabled = true
                }else {
                    cell.textField.alpha = 0.7
                    cell.imgIcon.alpha = 0.5
                    cell.textField.isUserInteractionEnabled = false
                }
                cell.imgIconWidthConstraint.constant = 0
                cell.textField.text = viewModel.getBusinessDetail()?.name
                cell.textField.delegate = self
                cell.textField.returnKeyType = .next
                cell.textField.tag = indexPath.row
                
                return cell
            }
            
        case BusinessDetailField.StoreLocation.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextFieldTVCell", for: indexPath) as? CommonTextFieldTVCell{
                cell.selectionStyle = .none
                cell.stviewRadio.isHidden = true
                cell.bottomView.isHidden = true
                cell.textField.isSecureTextEntry = false
                cell.lblTitle.text = "Store Location"
                cell.imgIcon.isHidden = true
                cell.imgIconWidthConstraint.constant = 0
                cell.btnHidePassword.isHidden = false
                cell.btnHidePassword.setImage(UIImage(named: "placeholder"), for: .normal)
                cell.btnHidePassword.isUserInteractionEnabled = false
                if businessDetailsViewController?.isEditEnable == true{
                    cell.lblTitle.alpha = 1
                    cell.textField.alpha = 1
                    cell.imgIcon.alpha = 1
                    cell.textField.isUserInteractionEnabled = true
                }else {
                    cell.textField.isUserInteractionEnabled = false
                    cell.textField.alpha = 0.7
                    cell.imgIcon.alpha = 0.5
                }
                cell.textField.text = viewModel.getBusinessDetail()?.address
                cell.textField.delegate = self
                cell.textField.returnKeyType = .next
                cell.textField.tag = indexPath.row
                
                return cell
            }
            
        case BusinessDetailField.Email.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextFieldTVCell", for: indexPath) as? CommonTextFieldTVCell{
                cell.selectionStyle = .none
                cell.bottomView.isHidden = true
                cell.stviewRadio.isHidden = true
                cell.btnHidePassword.isHidden = true
                cell.textField.isSecureTextEntry = false
                cell.lblTitle.text = "Email"
                cell.imgIconWidthConstraint.constant = 0
                cell.imgIcon.isHidden = true
                if businessDetailsViewController?.isEditEnable == true{
                    cell.lblTitle.alpha = 1
                    cell.textField.alpha = 1
                    cell.imgIcon.alpha = 1
                    cell.textField.isUserInteractionEnabled = true
                }else {
                    cell.textField.isUserInteractionEnabled = false
                    cell.textField.alpha = 0.7
                    cell.imgIcon.alpha = 0.5
                }
                cell.textField.text = viewModel.getBusinessDetail()?.email
                cell.textField.delegate = self
                cell.textField.returnKeyType = .next
                cell.textField.tag = indexPath.row
                
                return cell
            }
        case BusinessDetailField.ContactNumber.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextFieldTVCell", for: indexPath) as? CommonTextFieldTVCell{
                cell.selectionStyle = .none
                cell.bottomView.isHidden = true
                cell.stviewRadio.isHidden = true
                cell.btnHidePassword.isHidden = true
                cell.textField.isSecureTextEntry = false
                cell.lblTitle.text = "Contact Number"
                cell.imgIcon.isHidden = true
                if businessDetailsViewController?.isEditEnable == true{
                    cell.lblTitle.alpha = 1
                    cell.textField.alpha = 1
                    cell.imgIcon.alpha = 1
                    cell.textField.isUserInteractionEnabled = true
                }else {
                    cell.textField.isUserInteractionEnabled = false
                    cell.textField.alpha = 0.7
                    cell.imgIcon.alpha = 0.5
                }
                cell.imgIconWidthConstraint.constant = 0
                cell.textField.text = viewModel.getBusinessDetail()?.phone
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
                cell.stviewRadio.isHidden = true
                cell.textField.isSecureTextEntry = false
                cell.lblTitle.text = "Website"
                cell.imgIcon.isHidden = true
                if businessDetailsViewController?.isEditEnable == true{
                    cell.lblTitle.alpha = 1
                    cell.textField.alpha = 1
                    cell.imgIcon.alpha = 1
                    cell.textField.isUserInteractionEnabled = true
                }else {
                    cell.textField.isUserInteractionEnabled = false
                    cell.textField.alpha = 0.7
                    cell.imgIcon.alpha = 0.5
                }
                cell.imgIconWidthConstraint.constant = 0
                cell.textField.text = viewModel.getBusinessDetail()?.website
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
                if businessDetailsViewController?.isEditEnable == true{
                    cell.lblTitle.alpha = 1
                    cell.textField.alpha = 1
                    cell.imgIcon.alpha = 1
                    cell.stviewRadio.isHidden = false
                    cell.textField.isHidden = true
                    cell.rdb1.setImage(UIImage(named: "icon_radio_unselect"), for: .normal)
                    cell.rdb2.setImage(UIImage(named: "icon_radio_unselect"), for: .normal)
                    cell.rdb3.setImage(UIImage(named: "icon_radio_unselect"), for: .normal)
                    if viewModel.getBusinessDetail()?.deliveryOption == DeliveryType.delivery.rawValue{
                        cell.rdb1.setImage(UIImage(named: "icon_radio_select"), for: .normal)
                    }else if viewModel.getBusinessDetail()?.deliveryOption == DeliveryType.collection.rawValue{
                        cell.rdb2.setImage(UIImage(named: "icon_radio_select"), for: .normal)
                    }else if viewModel.getBusinessDetail()?.deliveryOption == DeliveryType.both.rawValue{
                        cell.rdb3.setImage(UIImage(named: "icon_radio_select"), for: .normal)
                    }
                    cell.textField.isUserInteractionEnabled = true
                }else {
                    cell.textField.isUserInteractionEnabled = false
                    cell.textField.alpha = 0.7
                    cell.imgIcon.alpha = 0.5
                    cell.stviewRadio.isHidden = true
                    cell.textField.isHidden = false
                    cell.textField.text = viewModel.getBusinessDetail()?.deliveryOption
                }
                return cell
            }
            
        case BusinessDetailField.LicenseNumber.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextFieldTVCell", for: indexPath) as? CommonTextFieldTVCell{
                cell.selectionStyle = .none
                cell.bottomView.isHidden = true
                cell.stviewRadio.isHidden = true
                cell.btnHidePassword.isHidden = true
                cell.textField.isSecureTextEntry = false
                cell.lblTitle.text = "Business License number"
                cell.imgIcon.isHidden = true
                if businessDetailsViewController?.isEditEnable == true{
                    cell.lblTitle.alpha = 1
                    cell.textField.alpha = 1
                    cell.imgIcon.alpha = 1
                    cell.textField.isUserInteractionEnabled = true
                }else {
                    cell.textField.isUserInteractionEnabled = false
                    cell.textField.alpha = 0.7
                    cell.imgIcon.alpha = 0.5
                }
                cell.imgIconWidthConstraint.constant = 0
                cell.textField.text = viewModel.getBusinessDetail()?.businessLicenceNumber
                cell.textField.delegate = self
                cell.textField.returnKeyType = .next
                cell.textField.tag = indexPath.row
                return cell
            }
            
        case BusinessDetailField.OpenCloseTime.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OpenCloseTimeTVCell", for: indexPath) as? BusinessDetailsTVCell{
                cell.svTitle.isHidden = true
                cell.svTime.isHidden = true
                cell.lblTitle.isHidden = true
                if indexPath.row == 0 {
                    cell.lblTitle.isHidden = false
                    cell.lblTitle.text = "Opening and Closing Time"
                }else if indexPath.row == 1 {
                    cell.svTitle.isHidden = false
                }else{
                    if businessDetailsViewController?.isEditEnable == true{
                        cell.txtOpenTime.isUserInteractionEnabled = true
                        cell.txtCloseTime.isUserInteractionEnabled = true
                        cell.btnSwitch.isUserInteractionEnabled = true
                        cell.txtOpenTime.alpha = 1
                        cell.txtCloseTime.alpha = 1
                        cell.btnSwitch.alpha = 1
                    }else {
                        cell.txtOpenTime.isUserInteractionEnabled = false
                        cell.txtCloseTime.isUserInteractionEnabled = false
                        cell.btnSwitch.isUserInteractionEnabled = false
                        cell.txtOpenTime.alpha = 0.5
                        cell.txtCloseTime.alpha = 0.5
                        cell.btnSwitch.alpha = 0.5
                    }
                    if  viewModel.getBusinessDetail()?.schedule?[indexPath.row - 2].isClosed == 0{
                        cell.btnSwitch.setImage(UIImage(named: "switch_on"), for: .normal)
                    }else {
                        cell.btnSwitch.setImage(UIImage(named: "switch_off"), for: .normal)
                    }
                    cell.btnSwitch.setTitle(String((viewModel.getBusinessDetail()?.schedule?[indexPath.row - 2].weekday?.prefix(3))!), for: .normal)
                    cell.txtOpenTime.text = viewModel.getBusinessDetail()?.schedule?[indexPath.row - 2].openingTime
                    cell.txtCloseTime.text = viewModel.getBusinessDetail()?.schedule?[indexPath.row - 2].closingTime
                    cell.svTime.isHidden = false
                }
               
                cell.selectionStyle = .none
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
        print(textField.text.asStringOrEmpty())
        switch textField.tag {
        
        case BusinessDetailField.StoreName.rawValue:
            self.viewModel.setStoreName(storeName: textField.text.asStringOrEmpty())
            break
            
        case BusinessDetailField.StoreLocation.rawValue:
            self.viewModel.setStoreLocation(storeLocation: textField.text.asStringOrEmpty())
            break
            
        case BusinessDetailField.StoreName.rawValue:
            self.viewModel.setStoreName(storeName: textField.text.asStringOrEmpty())
            break
            
        case BusinessDetailField.Email.rawValue:
            self.viewModel.setEmail(email: textField.text.asStringOrEmpty())
            break
            
        case BusinessDetailField.ContactNumber.rawValue:
            self.viewModel.setContactNum(contactNum: textField.text.asStringOrEmpty())
            break
            
        case BusinessDetailField.Website.rawValue:
            self.viewModel.setWebsite(website: textField.text.asStringOrEmpty())
            break
            
        case BusinessDetailField.LicenseNumber.rawValue:
            self.viewModel.setLicenseNum(licenseNum: textField.text.asStringOrEmpty())
            break
            
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
