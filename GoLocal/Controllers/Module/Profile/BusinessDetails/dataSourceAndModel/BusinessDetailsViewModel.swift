//
//  BusinessDetailsViewModel.swift
//  GoLocalDriver
//
//  Created by C110 on 15/01/21.
//

import Foundation
import UIKit

class BusinessDetailsViewModel {
    var objBusinessDetail : ShopDetail!
    private var storeName : String?
    private var storeLocation : String?
    private var email : String?
    private var contactNum : String?
    private var website : String?
    private var deliveryType : String?
    private var licenseNum : String?
}

extension BusinessDetailsViewModel {
    
    func setBusinessDetail(objBusinessDetail : ShopDetail){
        self.objBusinessDetail = objBusinessDetail
    }
    
    func getBusinessDetail() -> ShopDetail? {
        return objBusinessDetail
    }
    
    func setStoreName(storeName : String){
        self.storeName = storeName
    }
    
    func getStoreName() -> String? {
        return storeName
    }
    
    func setStoreLocation(storeLocation : String){
        self.storeLocation = storeLocation
    }
    
    func getStoreLocation() -> String? {
        return storeLocation
    }
    
    func setEmail(email : String){
        self.email = email
    }
    
    func getEmail() -> String? {
        return email
    }
    
    func setContactNum(contactNum : String){
        self.contactNum = contactNum
    }
    
    func getContactNum() -> String? {
        return contactNum
    }
    
    func setWebsite(website : String){
        self.website = website
    }
    
    func getWebsite() -> String? {
        return website
    }
    
    func setDeliveryType(deliveryType : String){
        self.deliveryType = deliveryType
    }
    
    func getDeliveryType() -> String? {
        return deliveryType
    }
    
    func setLicenseNum(licenseNum : String){
        self.licenseNum = licenseNum
    }
    
    func getLicenseNum() -> String? {
        return licenseNum
    }

}

