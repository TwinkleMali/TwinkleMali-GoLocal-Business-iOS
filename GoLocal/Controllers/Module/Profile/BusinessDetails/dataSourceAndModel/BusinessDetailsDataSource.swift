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
        tableView.register("MobileNumberTVCell")
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
        } else if section == BusinessDetailField.Images.rawValue {
            if viewModel.getSliderImages().count > 0 {
                return 1
            } else {
                return  businessDetailsViewController?.isEditEnable ?? false ? 1 : 0
            }
        } else {
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
            var arraycount : CGFloat = CGFloat(viewModel.getSliderImages().count + viewModel.getImages().count)
            if businessDetailsViewController?.isEditEnable == true{
                arraycount = arraycount + 1
            }
            let num : CGFloat = arraycount / 3
            let imageheight : CGFloat = (tableView.bounds.width - 20) / 3
            print("collectionview Height : \((CGFloat(num.rounded(.up)) * imageheight) + 30)")
            return (CGFloat(num.rounded(.up)) * imageheight) + 15

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
//            if businessDetailsViewController?.isEditEnable == true{
                if let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessDetailsTVCell", for: indexPath) as? BusinessDetailsTVCell{
                    cell.selectionStyle = .none
                    cell.cvImages.register("BussinessImageCVCell")
                    cell.cvImages.tag = indexPath.section
                    let layout = UICollectionViewFlowLayout()
                    layout.itemSize = UICollectionViewFlowLayout.automaticSize
                    layout.scrollDirection = .vertical
                    if viewModel.getSliderImages().count > 0 {
                        cell.cvImages.collectionViewLayout.invalidateLayout()
                        cell.cvImages.setCollectionViewLayout(layout, animated: false)
                        cell.cvImages.delegate = self
                    }
                    cell.cvImages.dataSource = self
                    cell.cvImages.reloadData()
                    
//                    cell.cvImages.setNeedsLayout()
                    return cell
                }
//            }else {
//                if let cell = tableView.dequeueReusableCell(withIdentifier: "ImageSliderTVCell", for: indexPath) as? BusinessDetailsTVCell{
//                    cell.selectionStyle = .none
//                    cell.viewimageSlider.contentMode = .scaleAspectFill
//                    if let images: [SliderImages] = viewModel.getBusinessDetail()?.sliderImages {
//                        var arrimg: [String] = []
//                        var image_is_available_count = 0
//                        for image in images {
//                            if let imgName = image.image {
//                                let imgName1 = imgName.components(separatedBy: "/").last ?? ""
//                                var finalPath = PATH_shopGallery.replacingOccurrences(of: "{ImageName}", with: imgName1) // + "/" + imgName
//                                finalPath = finalPath.replacingOccurrences(of: "{Id}", with: "\(USER_DETAILS?.shopId ?? 0)")
//                                //let imgUrl = URL(string: finalPath)
//                                arrimg.append(finalPath)
//                                image_is_available_count  += 1
//                            }
//                        }
//                        cell.pageControl.numberOfPages = arrimg.count
//                        cell.pageControl.currentPage = 0
//                        cell.viewimageSlider.delegate = self
//
//                        cell.viewimageSlider.setCarouselData(paths: arrimg, describedTitle: [], isAutoScroll: true, timer: 2, defaultImage: "product_details_placeholder")
//
//                        cell.viewimageSlider.setCarouselOpaque(layer: false, describedTitle: false, pageIndicator: false)
//                        cell.viewimageSlider.setCarouselLayout(displayStyle: 0, pageIndicatorPositon: 2, pageIndicatorColor: .clear, describedTitleColor: .clear, layerColor: .clear)
//
//                        }
//                        return cell
//                    }
//            }
        
        case BusinessDetailField.StoreName.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextFieldTVCell", for: indexPath) as? CommonTextFieldTVCell{
                cell.selectionStyle = .none
                cell.stviewRadio.isHidden = true
                cell.bottomView.isHidden = true
                cell.btnHidePassword.isHidden = true
                cell.textField.isSecureTextEntry = false
                cell.lblTitle.text = "Store Name"
                cell.textField.textColor = .black
                cell.imgIcon.isHidden = true
                cell.textField.isHidden = false
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
                cell.textField.text = viewModel.getStoreName()
                cell.textField.delegate = self
                cell.textField.returnKeyType = .next
                cell.textField.tag = indexPath.section
                
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
                cell.textField.textColor = .black
                cell.imgIconWidthConstraint.constant = 0
                cell.btnHidePassword.isHidden = false
                cell.btnHidePassword.setImage(UIImage(named: "placeholder"), for: .normal)
                
                cell.textField.isHidden = false
                if businessDetailsViewController?.isEditEnable == true{
                    cell.lblTitle.alpha = 1
                    cell.textField.alpha = 1
                    cell.imgIcon.alpha = 1
                    cell.textField.isUserInteractionEnabled = true
                    cell.btnHidePassword.isUserInteractionEnabled = true
                }else {
                    cell.textField.isUserInteractionEnabled = false
                    cell.btnHidePassword.isUserInteractionEnabled = false
                    cell.textField.alpha = 0.7
                    cell.imgIcon.alpha = 0.5
                }
                cell.textField.text = viewModel.getStoreLocation()
                cell.textField.delegate = self
                cell.textField.returnKeyType = .next
                cell.textField.tag = indexPath.section
                cell.btnHidePassword.addTarget(self.businessDetailsViewController, action: #selector(self.businessDetailsViewController?.showSearchPlaceView(_:)), for: .touchUpInside)
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
                cell.textField.textColor = .black
                cell.textField.isHidden = false
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
                cell.textField.text = viewModel.getEmail()
                cell.textField.delegate = self
                cell.textField.returnKeyType = .next
                cell.textField.tag = indexPath.section
                return cell
            }
            
        case BusinessDetailField.ContactNumber.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MobileNumberTVCell", for: indexPath) as? MobileNumberTVCell{
                cell.selectionStyle = .none
                if let country = viewModel.getSelectedCountry() {
                    cell.lblCountryPhoneCode.text = "+\(country.phonecode.asStringOrEmpty())"
                } else {
                    cell.lblCountryPhoneCode.text = "+0"
                }
                
                cell.textPhoneNumber.delegate = self
                cell.textPhoneNumber.keyboardType = .numberPad
                cell.textPhoneNumber.text = viewModel.getContactNum()
                cell.btnCodePicker.addTarget(self.businessDetailsViewController, action: #selector(self.businessDetailsViewController?.actionShowCodePicker(_:)), for: .touchUpInside)
                if businessDetailsViewController?.isEditEnable == true{
                    cell.textPhoneNumber.alpha = 1
                    cell.lblCountryPhoneCode.alpha = 1
                    cell.textPhoneNumber.isUserInteractionEnabled = true
                    cell.btnCodePicker.isUserInteractionEnabled = true
                }else {
                    cell.textPhoneNumber.isUserInteractionEnabled = false
                    cell.btnCodePicker.isUserInteractionEnabled = false
                    cell.textPhoneNumber.alpha = 0.7
                    cell.lblCountryPhoneCode.alpha = 0.7
                }
                return cell
            }
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextFieldTVCell", for: indexPath) as? CommonTextFieldTVCell{
//                cell.selectionStyle = .none
//                cell.bottomView.isHidden = true
//                cell.stviewRadio.isHidden = true
//                cell.btnHidePassword.isHidden = true
//                cell.textField.isSecureTextEntry = false
//                cell.textField.isHidden = false
//                cell.lblTitle.text = "Contact Number"
//                cell.imgIcon.isHidden = true
//                if businessDetailsViewController?.isEditEnable == true{
//                    cell.lblTitle.alpha = 1
//                    cell.textField.alpha = 1
//                    cell.imgIcon.alpha = 1
//                    cell.textField.isUserInteractionEnabled = true
//                }else {
//                    cell.textField.isUserInteractionEnabled = false
//                    cell.textField.alpha = 0.7
//                    cell.imgIcon.alpha = 0.5
//                }
//                cell.imgIconWidthConstraint.constant = 0
//                cell.textField.text = viewModel.getContactNum()
//                cell.textField.delegate = self
//                cell.textField.returnKeyType = .next
//                cell.textField.tag = indexPath.section
//
//                return cell
//            }

        case BusinessDetailField.Website.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextFieldTVCell", for: indexPath) as? CommonTextFieldTVCell{
                cell.selectionStyle = .none
                cell.bottomView.isHidden = true
                cell.btnHidePassword.isHidden = true
                cell.stviewRadio.isHidden = true
                cell.textField.isSecureTextEntry = false
                cell.textField.isHidden = false
                cell.textField.textColor = .blue
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
                cell.textField.text = viewModel.getWebsite()
                cell.textField.delegate = self
                cell.textField.returnKeyType = .next
                cell.textField.tag = indexPath.section
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
                cell.textField.textColor = .black
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
                    if viewModel.getDeliveryType() == DeliveryType.delivery.rawValue{
                        cell.rdb1.setImage(UIImage(named: "icon_radio_select"), for: .normal)
                    }else if viewModel.getDeliveryType() == DeliveryType.collection.rawValue{
                        cell.rdb2.setImage(UIImage(named: "icon_radio_select"), for: .normal)
                    }else if viewModel.getDeliveryType() == DeliveryType.both.rawValue{
                        cell.rdb3.setImage(UIImage(named: "icon_radio_select"), for: .normal)
                    }
                    cell.textField.isUserInteractionEnabled = true
                }else {
                    cell.textField.isUserInteractionEnabled = false
                    cell.textField.alpha = 0.7
                    cell.imgIcon.alpha = 0.5
                    cell.stviewRadio.isHidden = true
                    cell.textField.isHidden = false
                    cell.textField.text = viewModel.getDeliveryType()
                }
                cell.textField.tag = indexPath.section
                cell.rdb1.tag = 1
                cell.rdb1.addTarget(self.businessDetailsViewController, action: #selector(self.businessDetailsViewController?.btnRadioClick(_:)), for: .touchUpInside)
                cell.rdb2.tag = 2
                cell.rdb2.addTarget(self.businessDetailsViewController, action: #selector(self.businessDetailsViewController?.btnRadioClick(_:)), for: .touchUpInside)
                cell.rdb3.tag = 3
                cell.rdb3.addTarget(self.businessDetailsViewController, action: #selector(self.businessDetailsViewController?.btnRadioClick(_:)), for: .touchUpInside)
                
              
                return cell
            }
            
        case BusinessDetailField.LicenseNumber.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextFieldTVCell", for: indexPath) as? CommonTextFieldTVCell{
                cell.selectionStyle = .none
                cell.bottomView.isHidden = true
                cell.stviewRadio.isHidden = true
                cell.btnHidePassword.isHidden = true
                cell.textField.isHidden = false
                cell.textField.textColor = .black
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
                cell.textField.text = viewModel.getLicenseNum()
                cell.textField.delegate = self
                cell.textField.returnKeyType = .next
                cell.textField.tag = indexPath.section
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
                    
                    let customIndex : Int = indexPath.row - 2
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
                    let days = ["","","Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
                    cell.btnSwitch.setTitle(days[indexPath.row], for: .normal)
                    if  viewModel.getShopSchedule().count > 0 && viewModel.getShopSchedule()[customIndex].isClosed == 0{
                        cell.btnSwitch.setImage(UIImage(named: "switch_on"), for: .normal)
                        cell.btnSwitch.accessibilityLabel = "switch_on"
                        cell.btnClosed.isHidden = true
                        cell.txtOpenTime.isUserInteractionEnabled = true
                        cell.txtCloseTime.isUserInteractionEnabled = true
                        cell.txtOpenTime.text = viewModel.getShopSchedule()[customIndex].openingTime
                        cell.txtCloseTime.text = viewModel.getShopSchedule()[customIndex].closingTime
                        cell.txtOpenTime.layer.borderWidth = 1
                        cell.txtCloseTime.layer.borderWidth = 1
                        cell.btnSwitch.setTitle(String((viewModel.getShopSchedule()[customIndex].weekday?.prefix(3))!), for: .normal)
                    }else {
                        cell.btnSwitch.setImage(UIImage(named: "switch_off"), for: .normal)
                        cell.btnSwitch.accessibilityLabel = "switch_off"
                        cell.btnClosed.isHidden = false
                        cell.txtOpenTime.isUserInteractionEnabled = false
                        cell.txtCloseTime.isUserInteractionEnabled = false
                        cell.txtOpenTime.text = ""
                        cell.txtCloseTime.text = ""
                        cell.txtOpenTime.layer.borderWidth = 0
                        cell.txtCloseTime.layer.borderWidth = 0
                        
                    }
                    cell.btnSwitch.tag = customIndex
                    cell.txtOpenTime.tag = indexPath.section
                    cell.txtCloseTime.tag = indexPath.section
                    cell.txtOpenTime.accessibilityLabel = "OpenTime"
                    cell.txtCloseTime.accessibilityLabel = "CloseTime"
                    cell.txtOpenTime.accessibilityValue = "\(customIndex)"
                    cell.txtCloseTime.accessibilityValue = "\(customIndex)"
                    //cell.btnSwitch.setTitle(String((viewModel.getShopSchedule()[customIndex].weekday?.prefix(3))!), for: .normal)
                    cell.svTime.isHidden = false
                    cell.txtOpenTime.delegate = self
                    cell.txtCloseTime.delegate = self
                    cell.btnSwitch.addTarget(businessDetailsViewController, action: #selector(self.businessDetailsViewController?.btnTimeSwitchClick(_:)), for: .touchUpInside)
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
                
            case BusinessDetailField.OpenCloseTime.rawValue:
                break
                
            case BusinessDetailField.DeliveryType.rawValue:
                break
                
            default:
                break
            }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == BusinessDetailField.OpenCloseTime.rawValue{
            businessDetailsViewController?.showDatePicker(textfield: textField)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

extension BusinessDetailsDataSource : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if businessDetailsViewController?.isEditEnable == true{
            return viewModel.getSliderImages().count + viewModel.getImages().count + 1
        }else {
            return viewModel.getSliderImages().count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BussinessImageCVCell", for: indexPath) as? BussinessImageCVCell{
            cell.btnCancel.isHidden = true
            cell.btnAddImage.isHidden = true
            cell.imgBusiness.isHidden = true
            if viewModel.getSliderImages().count > 0 && indexPath.row < viewModel.getSliderImages().count{
                if businessDetailsViewController?.isEditEnable == true{
                    cell.btnCancel.isHidden = false
                    cell.btnCancel.addTarget(businessDetailsViewController, action: #selector(self.businessDetailsViewController?.btnRemoveImage(_:)), for: .touchUpInside)
                }
                cell.btnCancel.tag = indexPath.row
                cell.imgBusiness.isHidden = false
                let imgUrl  = (viewModel.getSliderImages()[indexPath.row]).image
                let imgName = imgUrl?.components(separatedBy: "/").last ?? ""
                var finalPath = PATH_shopGallery.replacingOccurrences(of: "{ImageName}", with: imgName) // + "/" + imgName
                finalPath = finalPath.replacingOccurrences(of: "{Id}", with: "\(USER_DETAILS?.shopId ?? 0)")
                cell.imgBusiness.sd_setImage(with: URL(string: finalPath), placeholderImage: UIImage(named: "product_details_placeholder"))
                cell.btnCancel.accessibilityLabel = "OldImage"
                
            }else if viewModel.getImages().count > 0 && indexPath.row < (viewModel.getSliderImages().count + viewModel.getImages().count){
                if businessDetailsViewController?.isEditEnable == true{
                    cell.btnCancel.isHidden = false
                    cell.btnCancel.addTarget(businessDetailsViewController, action: #selector(self.businessDetailsViewController?.btnRemoveImage(_:)), for: .touchUpInside)
                }
                cell.imgBusiness.isHidden = false
                cell.btnCancel.tag = indexPath.row - viewModel.getSliderImages().count
                cell.imgBusiness.image = viewModel.getImages()[indexPath.row - viewModel.getSliderImages().count]
                cell.btnCancel.accessibilityLabel = "NewImage"
                
            }else {
                cell.btnAddImage.isHidden = false
                cell.btnAddImage.setImage(UIImage(named: "icon_add_image"), for: .normal)
                cell.btnAddImage.addTarget(businessDetailsViewController, action: #selector(self.businessDetailsViewController?.btnAddImage(_:)), for: .touchUpInside)
            }
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

//extension BusinessDetailsDataSource : AACarouselDelegate{
//    func didSelectCarouselView(_ view: AACarousel, _ index: Int) {
//        print("Did Press")
//    }
//    
////    func callBackFirstDisplayView(_ imageView: UIImageView, _ url: [String], _ index: Int) {
////
////        imageView.sd_setImage(with: URL(string: url[index])!)
////
////    }
//    func updatePageControll(currentIndex: Int) {
//        self.pageControl.currentPage = currentIndex
//    }
//    func downloadImages(_ url: String, _ index: Int) {
//        let imageURL = URL(string: url)!
//        downloadImage(from: imageURL, index: index)
////        imageView.sd_setImage(with: URL(string: url)!) { (image, error, catch, url) in
////            self.viewimageSlider.images[index] = image!
////        }
//    }
//    
//    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
//        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
//    }
//    func downloadImage(from url: URL,index :Int) {
//        print("Download Started")
//        getData(from: url) { data, response, error in
//            guard let data = data, error == nil else { return }
//            print(response?.suggestedFilename ?? url.lastPathComponent)
//            print("Download Finished")
//            DispatchQueue.main.async() { [weak self] in
//                //self?.imageView.image = UIImage(data: data)
//                self?.viewimageSlider.images[index] = UIImage(data: data) ?? #imageLiteral(resourceName: "product_details_placeholder")
//            }
//        }
//    }
//}
