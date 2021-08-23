//
//  API_Manager+Extensions.swift
//  GoLocal
//
//  Created by C100-104 on 28/12/20.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD
import NotificationBannerSwift


extension LoginViewController {
    func doLogin(){
        let email = self.viewModel.getEmail()!
        let password = self.viewModel.getPassword()!
        self.activityIndicator?.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        let  param : Parameters = [
            "email": email,
            "password": password,
            "device_type": DEVICE_TYPE,
            "device_token": FCM_TOKEN,
            "latitude" : "",
            "longitude" : "",
            "guest_user_id" : 0
        ]
        APIHelper.shared.postJsonRequest(url: APILogin, parameter: param, headers: headers) { (isCompleted, status, response) in
            self.activityIndicator?.stopAnimating()
            self.view.isUserInteractionEnabled = true
            if isCompleted {
                if !(response["status"] as! Bool) {
                    if let isMailSent =  response["mail_sent"] as? Bool ,isMailSent{
                        //show alert for mail sent
                        self.showVerifyAlert()
                    } else {
                        self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                    }
                } else {
                    let data = response["data"] as! NSDictionary
                    let userDict = data["user"] as! NSDictionary
                    let user : User =  User(object: JSON(userDict))
                    if let rol = UserRole(rawValue: user.roleId ?? 0){
                        if self.isRemember {
                            saveLoginCredentials(user: self.viewModel.getLoginCredentials())
                        } else {
                            USER_DEFAULTS.removeObject(forKey: defaultsKey.loginCredentials.rawValue)
                        }
                        USER_DEFAULTS.set(password, forKey: defaultsKey.password.rawValue)
                        
                        print("---User : ",user)
                        saveUserInUserDefaults(user: user)
                        APP_DELEGATE?.socketIOHandler = SocketIOHandler()
                        self.navigateToHome()
                    } else {
                        self.showBanner(bannerTitle: .none, message: "Invalid business credentials.", type: .danger)
                    }
                    
                }
            } else {
                if status != "ConnectionLost" {
                    self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                }
            }
        }
    }
}
 
extension ForgotPasswordViewController {
    func doForgotPassword(){        
        self.activityIndicator?.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        let email = viewModel.getEmail()!
        let  param : Parameters = [
            "email": email,
            "user_role" : USER_ROLE
        ]
        APIHelper.shared.postJsonRequest(url: (isForLoginPin ? API_RESET_PIN : APIForgotPassword), parameter: param, headers: headers) { (isCompleted, status, response) in
             self.activityIndicator?.stopAnimating()
             self.view.isUserInteractionEnabled = true
             
             if isCompleted {
                 if !(response["status"] as! Bool) {
                   // self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                   let banner = FloatingNotificationBanner(title: "", subtitle: response["message"] as? String ?? "Something went wrong.", leftView: nil, rightView: nil, style: .danger)
                   banner.delegate = self
                   banner.show(bannerPosition: .top, on: self)
                 } else {
                    let msg = response["message"] as? String ?? "Something went wrong."
                    let banner = NotificationBanner(title: "Success", subtitle: msg, leftView: nil, rightView: nil, style: .info)
                    banner.show(bannerPosition: .top, on: self)
                    if self.isForLoginPin {
                        if let data = response[WSDATA] as? NSDictionary {
                            if let newPin = data["new_pin"] as? String {
                                //let repository = configuration.repository
                                print(">>>>>>NEW PIN ::  ",newPin)
                                let repository = UserDefaultsPasscodeRepository()
                                repository.save(passcode: newPin)
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2 , execute: {
                            self.dismiss(animated: true)
                        })
                        
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5 , execute: {
                            self.back(withAnimation: true)
                        })
                    }
                 }
             } else {
                if status != "ConnectionLost" {
                    self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                   let banner = FloatingNotificationBanner(title: "", subtitle: response["message"] as? String ?? "Something went wrong.", leftView: nil, rightView: nil, style: .danger)
                   banner.delegate = self
                   banner.show(bannerPosition: .top, on: self)
                }
             }
        }
        
    }
}

extension BaseViewController{
    func getCountryList(completion: @escaping (Bool) -> ()){
        let  param : Parameters = [
            "user_role" : USER_ROLE
        ]
        APIHelper.shared.postJsonRequest(url: APIGetAllCountries, parameter: param, headers: headers) { (isCompleted, status, response) in
            COUNTRY_LIST.removeAll()
            if isCompleted {
                if !(response["status"] as! Bool) {
                    self.getCountryList { _ in
                    }
//                    self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                    completion(false)
                } else {
                    let data = response[WSDATA] as! NSDictionary
                    let arrCountry = data["countries"] as! NSArray
                    for countryData in arrCountry {
                        let country = countryData as! NSDictionary
                        COUNTRY_LIST.append(Country(object: JSON(country)))
                    }
                    completion(true)
                }
            }
//            else {
//                self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
//                completion(false)
//            }
        }
    }
    
    func getUpdatedUserData(){
        let  param : Parameters = [
            "user_id" : USER_DETAILS?.id ?? 0
        ]
        APIHelper.shared.postJsonRequest(url: APIGetSingleUserDetail, parameter: param, headers: headers) { (isCompleted, status, response) in
            
            if isCompleted {
                if !(response["status"] as! Bool) {
                        self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                } else {
                    let data = response[WSDATA] as! NSDictionary
                    if let userDict = data[WSUSER] as? NSDictionary {
                        let user : User =  User(object: JSON(userDict))
                        saveUserInUserDefaults(user: user)
                    }
                    if let arrURL = data["media_urls"] as? NSArray {
                        for urlData in arrURL {
                            let urlDict = urlData as! NSDictionary
                            let urlObj = MediaUrl(object: JSON(urlDict))
                            //let typeName = urlObj.type ?? ""
                            //let typeEnum = URLTypes(rawValue: typeName)
                            
                            savePathInUserDefaults(mediaUrl: urlObj)
                            //COUNTRY_LIST.append(Country(object: JSON(country)))
                        }
                    }
                }
                
            } else {
                if status != "ConnectionLost" {
                    self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                }
            }
        }
    }
}

extension ChangePasswordViewController {
    func changePassword(param : Parameters){
        KRProgressHUD.show()
        APIHelper.shared.postJsonRequest(url: APIChangePassword, parameter: param, headers: headers) { (isCompleted, status, response) in
            KRProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
            if isCompleted {
                if !(response["status"] as! Bool) {
                    self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                } else {
                    let msg = response["message"] as? String ?? "Something went wrong."
                    let banner = NotificationBanner(title: "Success", subtitle: msg, leftView: nil, rightView: nil, style: .success)
                    banner.show()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5 , execute: {
                       self.back(withAnimation: true)
                   })
                }
            } else {
                if status != "ConnectionLost" {
                    self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                }
            }
        }
    }
}
extension ProfileViewController {
    func doLogout(completion: @escaping (Bool) -> ()){
        let param : Parameters = [
            "user_id" : USER_DETAILS?.id ?? 0,
            "user_role" : USER_DETAILS?.roleId ?? 0,
            "device_type": DEVICE_TYPE,
            "device_token": FCM_TOKEN,
        ]
        KRProgressHUD.show()
        APIHelper.shared.postJsonRequest(url: APILogout, parameter: param, headers: headers) { (isCompleted, status, response) in
            KRProgressHUD.dismiss()
             if isCompleted {
                 if !(response["status"] as! Bool) {
                     self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                    completion(false)
                 } else {
                     let msg = response["message"] as? String ?? "User Logged out successfully."
                    self.showBanner(bannerTitle: .none, message: msg, type: .success)
                    completion(true)
                 }
             } else {
                if status != "ConnectionLost" {
                    self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                }
                completion(false)
             }
         }
    }
}
extension EditProfileViewController {
    func editProfileInfo(param : Parameters){
        KRProgressHUD.show()
        APIHelper.shared.postJsonRequest(url: APIEditUserProfile, parameter: param, headers: headers) { (isCompleted, status, response) in
            KRProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
            if isCompleted {
                if !(response["status"] as! Bool) {
                    self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                } else {
                    let msg = response["message"] as? String ?? "Something went wrong."
                    let banner = NotificationBanner(title: "Success", subtitle: msg, leftView: nil, rightView: nil, style: .success)
                    banner.show()
                    let data = response["data"] as! NSDictionary
                    let userDict = data["user"] as! NSDictionary
                    let user : User =  User(object: JSON(userDict))
//                    print("---User : ",user)
                    saveUserInUserDefaults(user: user)
                    self.tableView.reloadData()
                }
            } else {
                if status != "ConnectionLost" {
                    self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                }
            }
        }
    }
}

extension BusinessDetailsViewController {
    func editBusinessDetails(){
        KRProgressHUD.show()
        let  param : Parameters = [
            "user_id": USER_DETAILS?.id ?? 0,
            "shop_id": USER_DETAILS?.shopId ?? 0,
            "shop_name" : self.viewModel.getStoreName().asStringOrEmpty(),
            "shop_address" : self.viewModel.getStoreLocation().asStringOrEmpty(),
            "latitude" : self.viewModel.getLatitude().asStringOrEmpty(),
            "longitude" : self.viewModel.getLongitude().asStringOrEmpty(),
            "email":self.viewModel.getEmail().asStringOrEmpty(),
            "website":self.viewModel.getWebsite().asStringOrEmpty(),
            "country_id": self.viewModel.getSelectedCountry()?.id ?? 0,
            "phone":self.viewModel.getContactNum().asStringOrEmpty(),
            "delivery_type":self.viewModel.getDeliveryTypeInt(str: self.viewModel.getDeliveryType() ?? "")!,
            "licence_number":self.viewModel.getLicenseNum().asStringOrEmpty(),
            "shop_schedule": json(from: self.viewModel.getShopScheduleDic())!,
            "delete_slider_image_ids":"\(viewModel.getDeletedImage().map(String.init).joined(separator: ","))",
            "slider_image[]":self.viewModel.getImages()
        ]
        

        APIHelper.shared.postMultipartJSONRequest(url: APIEditBusinessDetails, parameters: param, headers: headers) { (isCompleted, status, response) in
            KRProgressHUD.dismiss()
            if isCompleted {
                if !(response["status"] as! Bool) {
                    self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                } else {
                    let msg = response["message"] as? String ?? "Something went wrong."
                    let banner = NotificationBanner(title: "Success", subtitle: msg, leftView: nil, rightView: nil, style: .success)
                    banner.show()
                    if let data = response[WSDATA] as? NSDictionary, let shopDict = data["shop_detail"] as? NSDictionary {
                        let shop = ShopDetail(object: JSON(shopDict))
                        self.viewModel.setBusinessDetail(objBusinessDetail: shop)
                    }
                    self.isEditEnable = false
                    self.btnEdit.setTitle("Edit Detail", for: .normal)
                    self.tableView.reloadData()
                }
            } else {
                if status != "ConnectionLost" {
                    self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                }
            }
        }
    }
    
    func getBusinessDetails(){
        self.view.isUserInteractionEnabled = false
        KRProgressHUD.show()
        let  param : Parameters = [
            "shop_id" : USER_DETAILS?.shopId ?? 0
        ]
        APIHelper.shared.postJsonRequest(url: APIGetSingleStoreDetail, parameter: param, headers: headers) { (isCompleted, status, response) in
            KRProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
            if isCompleted {
                if !(response[WSSTATUS] as! Bool) {
                    
                } else {
                    if let data = response[WSDATA] as? NSDictionary {
                        if let  objShopDetail = data["shop_detail"] as? NSDictionary {
                           let reqObj = ShopDetail(object: JSON(objShopDetail))
                           self.viewModel.setBusinessDetail(objBusinessDetail: reqObj)
                            self.tableView.reloadDataWithAutoSizingCellWorkAround()
                        }
                    }
                }
                
            }
        }
    }
}


extension OrderRequestViewController {
    func getOrderRequestList(){
        self.view.isUserInteractionEnabled = false
        
        let  param : Parameters = [
            "user_id" : USER_DETAILS?.id ?? 0,
            "shop_id" : USER_DETAILS?.shopId ?? 0
        ]
        KRProgressHUD.show()
        APIHelper.shared.postJsonRequest(url: APIGetBusinessOrderRequests, parameter: param, headers: headers) { (isCompleted, status, response) in
            self.view.isUserInteractionEnabled = true
            KRProgressHUD.dismiss()
            if isCompleted {
                var arrOrderRequest : [OrderRequests] = []
                if !(response[WSSTATUS] as! Bool) {
                    self.viewModel.removeAllRequest()
                } else {
                    if let data = response[WSDATA] as? NSDictionary {
                        
                        if let arrRequests = data["order_requests"] as? NSArray {
                            for requestObj in arrRequests{
                                if let request = requestObj as? NSDictionary {
                                    let reqObj = OrderRequests(object: JSON(request))
                                    arrOrderRequest.append(reqObj)
                                    if APP_DELEGATE?.arrOrderRequestMain.contains(where: { $0.orderDetails?.id == reqObj.orderDetails?.id }) == false{
                                        APP_DELEGATE!.arrOrderRequestMain.append(reqObj)
                                    }
                                }
                            }
                        }
                    }
                }
                self.viewModel.removeExistingRequests()
                self.viewModel.setOrderRequests(arrOrderRequest: arrOrderRequest)
                self.tableView.reloadData()
            }
        }
    }
}


extension DriverSeleListViewController {
    func getDriverList(){
        let  param : Parameters = [
            "user_id" : USER_DETAILS?.id ?? 0,
            "shop_id" : USER_DETAILS?.shopId ?? 0
        ]
        KRProgressHUD.show()
        APIHelper.shared.postJsonRequest(url: APIGetBusinessDrivers, parameter: param, headers: headers) { (isCompleted, status, response) in
            self.view.isUserInteractionEnabled = true
            self.tableView.isHidden = false
            KRProgressHUD.dismiss()
            if isCompleted {
                if !(response["status"] as! Bool) {
                } else {
                    let data : BusinessDrivers = BusinessDrivers(object: JSON(response["data"] as! NSDictionary))
                    self.viewModel.setAllDrivers(objDrivers: data)
                    if data.availableDrivers != nil && data.availableDrivers!.count > 0 {
                        self.viewModel.setDrivers(drivers: data.availableDrivers!)
                    }
                    self.tableView.reloadData()
                    
                }
            }
        }
    }
}


extension DriversListViewController {
    func getAllBusinessDriverList(){
        let  param : Parameters = [
            "user_id" : USER_DETAILS?.id ?? 0,
            "shop_id" : USER_DETAILS?.shopId ?? 0
        ]
        KRProgressHUD.show()
        APIHelper.shared.postJsonRequest(url: APIGetAllBusinessDrivers, parameter: param, headers: headers) { (isCompleted, status, response) in
            self.view.isUserInteractionEnabled = true
            self.tableView.isHidden = false
            KRProgressHUD.dismiss()
            if isCompleted {
                if !(response["status"] as! Bool) {
                } else {
                    if let data = response[WSDATA] as? NSDictionary {
                        if let arrTempDrivers = data["business_drivers"] as? NSArray {
                            var arrDrivers : [Drivers] = []
                            for objDriver in arrTempDrivers{
                                if let driver = objDriver as? NSDictionary {
                                    arrDrivers.append(Drivers(object: JSON(driver)))
                                }
                            }
                            self.viewModel.setDrivers(drivers: arrDrivers)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}

extension DriverDetailsViewController {
    
    func getBusyDriverOrderDetails(driver_id : String, completion: @escaping (Bool) -> ()){
//    func getBusyDriverOrderDetails(){
        let  param : Parameters = [
            "user_id" : USER_DETAILS?.id ?? 0,
            "shop_id" : USER_DETAILS?.shopId ?? 0,
            "driver_id" : driver_id
        ]
        KRProgressHUD.show()
        APIHelper.shared.postJsonRequest(url: APIGetBusyDriverOrderDetails, parameter: param, headers: headers) { (isCompleted, status, response) in
            self.view.isUserInteractionEnabled = true
            self.tableView.isHidden = false
            KRProgressHUD.dismiss()
            if isCompleted {
                if !(response["status"] as! Bool) {
                    completion(false)
                } else {
                    if let data = response[WSDATA] as? NSDictionary {
                        if let objDriverOrder = data["order_details"] as? NSDictionary {
                            self.viewModel.setDriverOrder(objDriverOrder: OrderDetails(object: JSON(objDriverOrder)))
                            self.tableView.reloadData()                        
                        }
                    }
                    completion(true)
                }
            }
        }
    }
}

extension OrderViewController {
    func getListOfOrders(param : Parameters){
           if self.isLoader{
               KRProgressHUD.show()
           }
        APIHelper.shared.postJsonRequest(url: APIGetAllBusinessOrders, parameter: param, headers: headers) { (isCompleted, status, response) in
            
            self.view.isUserInteractionEnabled = true
            self.tableView.isHidden = false
            
            if self.isLoader{
                KRProgressHUD.dismiss()
            }
            
            if isCompleted {
                if !(response["status"] as! Bool) {
                    self.tableView.reloadData() //reloadDataWithAutoSizingCellWorkAround()
                    self.lblNoMsg.isHidden = self.isLoadMore
                } else {
                    //                    if let data = response[WSDATA] as? NSDictionary {
                    //                        if let arrTempOrders = data["order_list"] as? NSArray {
                    //                            var arrOrders : [OrderDetails] = []
                    //                            for objOrder in arrTempOrders{
                    //                                if let order = objOrder as? NSDictionary {
                    //                                    arrOrders.append(OrderDetails(object: JSON(order)))
                    //                                }
                    //                            }
                    //                            self.viewModel.setOrders(arrOrder: arrOrders, orderType:param["order_option"] as! Int)
                    //                            self.tableView.reloadData()
                    //                        }
                    //                    }
                    
                    if let data = response[WSDATA] as? NSDictionary {
                        if let arrTempOrders = data["order_list"] as? NSArray {
                            var arrOrders : [OrderList] = []
                            for objOrder in arrTempOrders{
                                arrOrders.append(OrderList(object: JSON(objOrder)))
                            }
                            
                            self.viewModel.setOrderList(isloadMore:self.isLoadMore, arrOrderList: arrOrders, orderType: param["order_option"] as! Int)
                            self.lblNoMsg.isHidden = true
//                            self.tableView.reloadDataWithAutoSizingCellWorkAround()
                            self.tableView.isScrollEnabled = true
                            self.tableView.reloadData()
                        }
                    } else {
                        //self.tableView.reloadDataWithAutoSizingCellWorkAround()
                        self.tableView.scrollToTop()
                        self.tableView.reloadData()
                        self.lblNoMsg.isHidden = false
                    }
                }
                if self.isLoadMore{
                    self.isLoadMore = false
                    self.indicatorView.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
            } else {
                self.tableView.reloadData()//reloadDataWithAutoSizingCellWorkAround()
                self.lblNoMsg.isHidden = self.isLoadMore
            }
        }
        
    }
}


extension NotificationsViewController {
    func getNotification(offset : Int){
        if self.isLoader{
            KRProgressHUD.show()
        }
        
        let  param : Parameters = [
            "user_id" : USER_DETAILS?.id ?? 0,
            "service_category_id": 0,
            "page_num" : offset
        ]
        APIHelper.shared.postJsonRequest(url: APIGetNotifications, parameter: param, headers: headers) { (isCompleted, status, response) in
            self.view.isUserInteractionEnabled = true
            self.tableView.isHidden = false
            if self.isLoader{
                KRProgressHUD.dismiss()
            }
            if isCompleted {
                if !(response["status"] as! Bool) {
                } else {
                    if let data = response[WSDATA] as? NSDictionary {
                        if let arrTempNoti = data["notifications"] as? NSArray {
                            var arrNotifiaction : [Notifications] = []
                            for objNotifi in arrTempNoti{
                                if let notification = objNotifi as? NSDictionary {
                                    arrNotifiaction.append(Notifications(object: JSON(notification)))
                                }
                            }
                           
                            self.viewModel.setNotifications(arrNoti: arrNotifiaction)
                            self.tableView.reloadData()
                        }
                    }
                }
                self.lblNoMsg.isHidden = self.viewModel.getNotificationCount() > 0
                self.refresher.endRefreshing()
                if self.isLoadMore{
                    self.isLoadMore = false
                    self.indicatorView.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        
    }
}

extension  RatingViewController{
    func getRatingReviews(isLoadMore : Bool){
        if isLoadMore {
            viewModel.incrementPageCount()
        } else {
            viewModel.resetPageCount()
            KRProgressHUD.show()
            //shimmerView.isHidden = false
            self.viewModel.removeAllReview()
        }
        
        let  param : Parameters = [
            "user_id" : USER_DETAILS?.id ?? 0,
            "user_role": USER_ROLE,
            "shop_id" : USER_DETAILS?.shopId ?? 0,
            "page_num" : viewModel.getCurrentPageCount(),
        ]
        APIHelper.shared.postJsonRequest(url: APIGetRatingReview, parameter: param, headers: headers) { (isCompleted, status, response) in
            if self.isLoader{
                KRProgressHUD.dismiss()
            }
            if isCompleted {
                if let loadmore = response["load_more"] as? Bool {
                    self.viewModel.UpdateLoadMore(value: loadmore)
                }
                if !(response["status"] as! Bool) {
                } else {
                    if let data = response[WSDATA] as? NSDictionary {
                        if let arrTempReviews = data["reviews"] as? NSArray {
                            var arrRatingReviews : [RatingReviews] = []
                            for objReview in arrTempReviews{
                                if let review = objReview as? NSDictionary {
                                    arrRatingReviews.append(RatingReviews(object: JSON(review)))
                                }
                            }
                            self.viewModel.setRatings(arrRating: arrRatingReviews)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
        
    }
    
    func replyToRatingReview(strReply : String, reviewId : Int){
        KRProgressHUD.show()
        let  param : Parameters = [
            "user_id" : USER_DETAILS?.id ?? 0,
            "review_id": reviewId,
            "reply" : strReply,
        ]
        APIHelper.shared.postJsonRequest(url: APIReplyToRatingReview, parameter: param, headers: headers) { (isCompleted, status, response) in
            let index = self.viewModel.getReplyIndex()
            self.viewModel.updateReplyIndex(index: -1)
            KRProgressHUD.dismiss()
            if isCompleted {
                if !(response["status"] as! Bool) {
                } else {
                    self.isLoader = true
                    if let data = response[WSDATA] as? NSDictionary {
                        if let arrReply = data["replies"] as? NSArray {
                            var arrObjReply : [ReviewReplies] = []
                            for objReply in arrReply{
                                if let reply = objReply as? NSDictionary {
                                    arrObjReply.append(ReviewReplies(object: JSON(reply)))
                                }
                            }
                            self.viewModel.addReplyToReview(index: index, replies: arrObjReply){
                                self.tableView.reloadSections([index], with: .fade)
                            }
                        }
                    }
                }
            }
        }
        
    }
}

extension StripeConnectViewController {
    func updateConnectedAccountId(strId : String) {
        self.view.isUserInteractionEnabled = false
        
        let  param : Parameters = [
            "user_id" : USER_DETAILS?.id ?? 0,
            "connected_user_id" : strId
        ]
        APIHelper.shared.postJsonRequest(url: API_SAVE_BUSINESS_ACCOUNT_DETAIL, parameter: param, headers: headers) { (isCompleted, status, response) in
            self.view.isUserInteractionEnabled = true
            if isCompleted {
                if !(response["status"] as! Bool) {
                    //self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .info)
                    let banner = NotificationBanner(title: .none, subtitle: response["message"] as? String ?? "Something went wrong.", leftView: nil, rightView: nil, style: .info)
                    //banner.delegate = self
                    banner.show()
                } else {
                    let data = response["data"] as! NSDictionary
                    let userDict = data["user"] as! NSDictionary
                    
                    let bannerTitle = "Business Account linked"
                    let banner = NotificationBanner(title: bannerTitle, subtitle: response["message"] as? String ?? "Something went wrong.", leftView: nil, rightView: nil, style: .success)
                    banner.autoDismiss = true
                    banner.dismissOnTap = true
                    //banner.delegate = self
                    banner.show()
                    let user : User =  User(object: JSON(userDict))
                    saveUserInUserDefaults(user: user)
                }
                self.navigationController?.popViewController(animated: true)
            } else {
                //self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .info)

                if status != "ConnectionLost" {
                    let banner = NotificationBanner(title: .none, subtitle: response["message"] as? String ?? "Something went wrong.", leftView: nil, rightView: nil, style: .info)
                    //banner.delegate = self
                    banner.show()
                }
            }
        }
    }
    
}
extension PaymentOptionViewController {
    func getCustomerDetails(code : String){
        KRProgressHUD.show()
        let  param : Parameters = [
            "qrcode" : code
        ]
        APIHelper.shared.postJsonRequest(url: APIGetCustomerInfo, parameter: param, headers: headers) { (isCompleted, status, response) in
            KRProgressHUD.dismiss()
            if isCompleted {
                if !(response["status"] as! Bool) {
                    self.back(withAnimation: true)
                    self.showBanner(bannerTitle: .none, message: "Customer not found in system", type: .danger)
                } else {
                    if let data = response[WSDATA] as? NSDictionary {
                        if let user = data[WSUSER.lowercased()] as? NSDictionary {
                            let customer = User(json: JSON(user))
                            print("@ Customer found : ",customer.name)
                            self.customerDetails = customer
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}
extension TradeHomeViewController {
    func getAvailableQuote(){
        let  param : Parameters = [
            "user_id":USER_DETAILS?.id ?? 0,
            "latitude":USER_DETAILS?.latitude ?? "",
            "longitude": USER_DETAILS?.longitude ?? "",
            "postcode":USER_DETAILS?.zipcode ?? "",
            "shop_id":USER_DETAILS?.shopId ?? 0
        ]
        self.viewModel.clearRequeets()
        APIHelper.shared.postJsonRequest(url: APIGetAllNearestServices, parameter: param, headers: headers) { (isCompleted, status, response) in
            KRProgressHUD.dismiss()
            if isCompleted {
                if !(response["status"] as! Bool) {
                    if let msg = response["message"] as? String {
                        //self.showBanner(bannerTitle: .none, message: , type: .danger)
                    } else {
                        //self.showBanner(bannerTitle: .none, message: "Something went wrong.", type: .danger)
                    }
                } else {
                    if let data = response[WSDATA] as? NSDictionary {
                        if let serviceRequests = data["service_requests"] as? NSDictionary {
                            let serviceRequestsObj = ServiceRequests(json: JSON(serviceRequests))
                            //print("@ Service found : ",ser)
                            self.viewModel.setServicesDetails(value: serviceRequestsObj)
                            self.lblDataNotFound.isHidden = (serviceRequestsObj.ser_requests?.count ?? 0) > 0
                        }
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
}
extension TradeServiceDetailsViewController {
    func getsingleQuoteationdetails() {
        let  param : Parameters = [
            "user_id":customerId,
            "request_id":QuotationId
        ]
        APIHelper.shared.postJsonRequest(url: APIGetSingleTradeRequestDetail, parameter: param, headers: headers) { (isCompleted, status, response) in
            KRProgressHUD.dismiss()
            //            self.shimmerView.isHidden = true
            if isCompleted {
                if !(response["status"] as! Bool) {
                    self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                    
                } else {
                    if let data = response[WSDATA] as? NSDictionary {
                        if let tradeOrderDict = data["trade_request_detail"] as? NSDictionary {
                            let quoteRequestDetails = SerRequests(object: JSON(tradeOrderDict))
                            self.viewModel.setRequestDetails(value: quoteRequestDetails)
                        }
                        if let timerValue = data["trade_request_timer_value"] as? Int {
                            self.viewModel.setTimerValue(value: timerValue)
                        }
                    }
                    self.tableView.reloadData()
                }
            } else {
                if status != "ConnectionLost" {
                    self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                }
            }
        }
        
    }
}
extension TradeOrdersViewController{
    func getTradeOrders(isLoadMore : Bool = false){
        if isLoadMore {
            viewModel.incrementPageCount()
        } else {
            viewModel.resetPageCount()
            KRProgressHUD.show()
            //shimmerView.isHidden = false
            self.viewModel.removeAllData()
        }
        let param : Parameters = [
            "user_id" : USER_DETAILS?.id ?? 0,
            "shop_id" : USER_DETAILS?.shopId ?? 0,
            "order_option" : viewModel.getCurrentOption(),
            "filter_type" : viewModel.getCurrentOption() == 2 ? viewModel.getFilterOption().rawValue : 0,
            "filter_date" : viewModel.getCurrentOption() == 2 ? viewModel.getSelectedDate() : "",
            "filter_year" : viewModel.getCurrentOption() == 2 ? viewModel.getSelectedYear() : "",
            "filter_month" : viewModel.getCurrentOption() == 2 ? viewModel.getSelectedMonth() : "",
            "page_num" : viewModel.getCurrentOption() == 2 ? viewModel.getCurrentPageCount() : 0
        ]
        APIHelper.shared.postJsonRequest(url: APIGetTradeBusinessOrders, parameter: param, headers: headers) { (isCompleted, status, response) in
            KRProgressHUD.dismiss()
            //            self.shimmerView.isHidden = true
//            self.viewModel.removeAllData()
            if isCompleted {
                if !(response["status"] as! Bool) {
                    if let loadmore = response["load_more"] as? Bool {
                        self.viewModel.UpdateLoadMore(value: loadmore)
                    }
                    //self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                } else {
                    //LOAD MORE
                    if let loadmore = response["load_more"] as? Bool {
                        self.viewModel.UpdateLoadMore(value: loadmore)
                    }
                    //DATA
                    if let data = response[WSDATA] as? NSDictionary {
                        if let arrTradeOrder = data["trader_orders"] as? NSArray {
                            var arrTraderOrders : [TraderOrders] = []
                            for tradeOrder in arrTradeOrder {
                                let orderDict = tradeOrder as! NSDictionary
                                let orderObj = TraderOrders(object: JSON(orderDict))
                                arrTraderOrders.append(orderObj)
                            }
                            self.viewModel.setOrderDetails(value: arrTraderOrders)
                        }
                    }
                    
                }
            } else {
                if status != "ConnectionLost" {
                    self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                }
            }
            self.tableView.reloadData()
            self.lblOrderNotFound.isHidden = !(self.viewModel.getAllOrderDetails().count == 0)
            
        }
    }
}
extension TradeOrderDetailsViewController {
    func getsingleTradeOrderDetails() {
        let  param : Parameters = [
            "response_id":viewModel.getResponseId() ?? 0
        ]
        self.lblOrderNotFound.isHidden = true
        KRProgressHUD.show()
        APIHelper.shared.postJsonRequest(url: APIGetTradeBusinessOrderDetails, parameter: param, headers: headers) { (isCompleted, status, response) in
            KRProgressHUD.dismiss()
            //            self.shimmerView.isHidden = true
            if isCompleted {
                if !(response["status"] as! Bool) {
                    self.btnMarkAsComplete.isHidden = true
                    self.lblOrderNotFound.isHidden = false
                    self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                    
                } else {
                    self.lblOrderNotFound.isHidden = true
                    self.btnMarkAsComplete.isHidden = false
                    if let data = response[WSDATA] as? NSDictionary {
                        if let tradeOrderDict = data["trader_order_detail"] as? NSDictionary {
                            let tradeOrder = TraderOrders(object: JSON(tradeOrderDict))
                            self.viewModel.setOrderDetails(value: tradeOrder)
                        }
                    }
                    if let isPaymentDone = self.viewModel.isCustomerPaymentDone(){
                        self.btnMarkAsComplete.isEnabled = isPaymentDone
                        self.btnMarkAsComplete.alpha = isPaymentDone ? 1 : 0.5
                    }
                    if self.viewModel.isPastOrder() {
                        self.btnMarkAsComplete.isUserInteractionEnabled = false
                        self.btnMarkAsComplete.alpha =  1
                        self.btnMarkAsComplete.isHidden = false
                        self.btnMarkAsComplete.backgroundColor = .clear
                        let strReqStatus = self.viewModel.getOrderDetails()?.serRequest?.requestStatus ?? ""
                        let dateStr =  self.viewModel.getOrderDetails()?.serRequest?.statusModifiedAt ?? ""
                        let date = dateStr.toDate()?.UTCtoLocal(format: "dd/MM/yyyy") ?? ""
                        let time = dateStr.toDate()?.UTCtoLocal(format: "hh:mm a") ?? ""
                        let reqStatus = TRADE_SERVICE_STATUS(rawValue: strReqStatus) ?? .REJECTED
                        if reqStatus == .COMPLETED {
                            self.btnMarkAsComplete.setTitleColor(.systemGreen, for: .normal)
                        } else {
                            self.btnMarkAsComplete.setTitleColor(.systemRed, for: .normal)
                        }
                        
                        let text = "\(strReqStatus) on \(date) at \(time.uppercased())"
                        self.btnMarkAsComplete.setTitle("⬤ \(text)", for: .normal)
                        self.btnMarkAsComplete.titleLabel?.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 15))
                        self.btnMarkAsComplete.contentHorizontalAlignment = .left
                    }
                    self.tableView.reloadData()
                }
            } else {
                if status != "ConnectionLost" {
                    self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                }
                self.lblOrderNotFound.isHidden = false
                self.btnMarkAsComplete.isHidden = true
            }
        }
        
    }
}
extension BusinessNotificationViewController{
    func getNotificationHistory(isLoadMore : Bool = false){
        if isLoadMore {
            viewModel.incrementPageCount()
        } else {
            viewModel.resetPageCount()
            KRProgressHUD.show()
            //shimmerView.isHidden = false
            self.viewModel.removeAllNotification()
        }
        let param : Parameters = [
            "user_id" : USER_DETAILS?.id ?? 0,
            "shop_id" : USER_DETAILS?.shopId ?? 0,
            "page_num" : viewModel.getCurrentPageCount()
        ]
        APIHelper.shared.postJsonRequest(url: API_GetBusinessPushNotificationList, parameter: param, headers: headers) { (isCompleted, status, response) in
            KRProgressHUD.dismiss()
            
            self.checkSendNotificationAvailablity()
            if isCompleted {
                if !(response["status"] as! Bool) {
                    //LOAD MORE
                    if let loadmore = response["load_more"] as? Bool {
                        self.viewModel.UpdateLoadMore(value: loadmore)
                    }
                    //self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                } else {
                    //LOAD MORE
                    if let loadmore = response["load_more"] as? Bool {
                        self.viewModel.UpdateLoadMore(value: loadmore)
                    }
                    //DATA
                    
                    if let data = response[WSDATA] as? NSDictionary {
                        if let arrNotificationsData = data["business_notifications"] as? NSArray {
                            var arrNotifications : [BusinessNotifications] = []
                            for notificationData in arrNotificationsData {
                                let notificationDict = notificationData as! NSDictionary
                                let notification = BusinessNotifications(object: JSON(notificationDict))
                                arrNotifications.append(notification)
                            }
                            
                            self.viewModel.setNotifications(arrNoti: arrNotifications)
                        }
                    }
                    
                }
            } else {
                if status != "ConnectionLost" {
                    self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                }
            }
            self.tableView.reloadData()
            self.lblNoData.isHidden = !(self.viewModel.getNotificationCount() == 0)
            
        }
    }
    func checkSendNotificationAvailablity(){
        KRProgressHUD.show()
        let param : Parameters = [
            "user_id" : USER_DETAILS?.id ?? 0,
            "shop_id" : USER_DETAILS?.shopId ?? 0
        ]
        APIHelper.shared.postJsonRequest(url: API_CheckBusinessPushNotificationTiming, parameter: param, headers: headers) { (isCompleted, status, response) in
            KRProgressHUD.dismiss()
            if isCompleted {
                if  let message = response["message"] as? String {
                    self.viewModel.setMessage(value: message)
                    self.viewMessage.isHidden = !(message.count > 0)
                    self.lblMessage.text = message
                }
                if !(response["status"] as! Bool) {
                    
                    
                    //self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                } else {
                    //DATA
                    if let data = response[WSDATA] as? NSDictionary {
                        if let notificationCheckerObj = data["notification_checker"] as? NSDictionary {
                            let notification = NotificationChecker(object: JSON(notificationCheckerObj))
                            self.viewModel.setNotificationChecker(value: notification)
                            self.btnShowSendView.isHidden = !(self.viewModel.getNotificationChecker()?.canSendNotification ?? false)
                        }
                    }
                }
            } else {
                if status != "ConnectionLost" {
                    self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                }
            }
        }
    }
    func sendPostNotification(titleText:String,messageText:String){
        KRProgressHUD.show()
        let param : Parameters = [
            "user_id" : USER_DETAILS?.id ?? 0,
            "shop_id" : USER_DETAILS?.shopId ?? 0,
            "title":titleText,
            "message":messageText
        ]
        APIHelper.shared.postJsonRequest(url: API_SendBusinessNotifications, parameter: param, headers: headers) { (isCompleted, status, response) in
            KRProgressHUD.dismiss()
            if isCompleted {
                if  let message = response["message"] as? String {
                    self.viewModel.setMessage(value: message)
                }
                if !(response["status"] as! Bool) {
                    self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                } else {
                    self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .success)
                    //change screen & check notification availability
                    self.back(withAnimation: true)
                
                }
            } else {
                if status != "ConnectionLost" {
                    self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                }
            }
        }
    }
}

extension TradeSentQuotationHistoryViewController {
    func getPendingQuotions(isLoadMore : Bool = false){
        if isLoadMore {
            viewModel.incrementPageCount()
        } else {
            viewModel.resetPageCount()
            KRProgressHUD.show()
            //shimmerView.isHidden = false
            self.viewModel.removeAllData()
        }
        let param : Parameters = [
            "user_id" : USER_DETAILS?.id ?? 0,
            "shop_id" : USER_DETAILS?.shopId ?? 0,
            "page_num" : viewModel.getCurrentPageCount()
        ]
        APIHelper.shared.postJsonRequest(url: APIGetPendingQuotationList, parameter: param, headers: headers) { (isCompleted, status, response) in
            KRProgressHUD.dismiss()
            
            if isCompleted {
                //LOAD MORE
                if let loadmore = response["load_more"] as? Bool {
                    self.viewModel.UpdateLoadMore(value: loadmore)
                }
                if !(response["status"] as! Bool) {
                    //self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                } else {
                    //DATA
                    if let data = response[WSDATA] as? NSDictionary {
                        if let arrTradeOrder = data["trader_orders"] as? NSArray {
                            var arrTraderOrders : [TraderOrders] = []
                            for tradeOrder in arrTradeOrder {
                                let orderDict = tradeOrder as! NSDictionary
                                let orderObj = TraderOrders(object: JSON(orderDict))
                                arrTraderOrders.append(orderObj)
                            }
                            self.viewModel.setOrderDetails(value: arrTraderOrders)
                        }
                    }
                    
                }
            } else {
                if status != "ConnectionLost" {
                    self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
                }
            }
            self.tableView.reloadData()
            self.lblNoData.isHidden = !(self.viewModel.getAllOrderDetails().count == 0)
            
        }
    }
}
