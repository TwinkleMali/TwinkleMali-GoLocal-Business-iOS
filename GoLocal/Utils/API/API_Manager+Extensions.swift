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
            "user_role" : USER_ROLE,
            "password": password,
            "device_type": DEVICE_TYPE,
            "device_token": DEVICE_TOKEN,
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
                    
                    if self.isRemember {
                        saveLoginCredentials(user: self.viewModel.getLoginCredentials())
                    } else {
                        USER_DEFAULTS.removeObject(forKey: defaultsKey.loginCredentials.rawValue)
                    }
                    USER_DEFAULTS.set(password, forKey: defaultsKey.password.rawValue)
                    let user : User =  User(object: JSON(userDict))
                    print("---User : ",user)
                    saveUserInUserDefaults(user: user)
                    APP_DELEGATE?.socketIOHandler = SocketIOHandler()
//                    APP_DELEGATE?.socketIOHandler?.connectWithSocket()

                    //isSyncApiCalledFterLogin = false
                    
                    self.navigateToHome()
                }
            } else {
                self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
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
        APIHelper.shared.postJsonRequest(url: APIForgotPassword, parameter: param, headers: headers) { (isCompleted, status, response) in
             self.activityIndicator?.stopAnimating()
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
                     //self.navigateNext()
                 }
             } else {
                 self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
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
                self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
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
                    print("---User : ",user)
                    saveUserInUserDefaults(user: user)
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5 , execute: {
//                       self.back(withAnimation: true)
//                   })
                }
            } else {
                self.showBanner(bannerTitle: .none, message: response["message"] as? String ?? "Something went wrong.", type: .danger)
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
                    
                } else {
                    if let data = response[WSDATA] as? NSDictionary {
                        if let arrTempOrders = data["orders"] as? NSArray {
                            var arrOrders : [OrderDetails] = []
                            for objOrder in arrTempOrders{
                                if let order = objOrder as? NSDictionary {
                                    arrOrders.append(OrderDetails(object: JSON(order)))
                                }
                            }
                            self.viewModel.setOrders(arrOrder: arrOrders, orderType:param["order_option"] as! Int)
                            self.tableView.reloadData()
                        }
                    }
                }
                if self.isLoadMore{
                    self.isLoadMore = false
                    self.indicatorView.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
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
    func getRatingReviews(offset : Int){
        if self.isLoader{
            KRProgressHUD.show()
        }
        
        let  param : Parameters = [
            "user_id" : USER_DETAILS?.id ?? 0,
            "user_role": USER_ROLE,
            "shop_id" : USER_DETAILS?.shopId ?? 0,
            "page_num" : offset,
        ]
        APIHelper.shared.postJsonRequest(url: APIGetRatingReview, parameter: param, headers: headers) { (isCompleted, status, response) in
            self.view.isUserInteractionEnabled = true
            self.tableView.isHidden = false
            if self.isLoader{
                KRProgressHUD.dismiss()
            }
            if isCompleted {
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
                if self.isLoadMore{
                    self.isLoadMore = false
                    self.indicatorView.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        
    }
}
