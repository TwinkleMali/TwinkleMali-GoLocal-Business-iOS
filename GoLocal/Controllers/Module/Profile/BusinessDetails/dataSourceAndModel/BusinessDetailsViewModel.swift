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
    private var latitude : String?
    private var longitude : String?
    private var shopSchedule : [Schedule]!
}

extension BusinessDetailsViewModel {
    
    func setBusinessDetail(objBusinessDetail : ShopDetail){
        self.objBusinessDetail = objBusinessDetail
        self.setStoreName(storeName: objBusinessDetail.name.asStringOrEmpty())
        self.setStoreLocation(storeLocation: objBusinessDetail.address.asStringOrEmpty())
        self.setEmail(email: objBusinessDetail.email.asStringOrEmpty())
        self.setContactNum(contactNum: objBusinessDetail.phone.asStringOrEmpty())
        self.setWebsite(website: objBusinessDetail.website.asStringOrEmpty())
        self.setDeliveryType(deliveryType: objBusinessDetail.deliveryOption.asStringOrEmpty())
        self.setLicenseNum(licenseNum: objBusinessDetail.businessLicenceNumber.asStringOrEmpty())
        self.setLatitude(latitude: objBusinessDetail.latitude.asStringOrEmpty())
        self.setLongitude(longitude: objBusinessDetail.longitude.asStringOrEmpty())
        self.setShopSchedule(shopSchedule: objBusinessDetail
                                .schedule!)
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
    
    func setLatitude(latitude : String){
        self.latitude = latitude
    }
    
    func getLatitude() -> String? {
        return latitude
    }
    
    func setLongitude(longitude : String){
        self.longitude = longitude
    }
    
    func getLongitude() -> String? {
        return longitude
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
    
    func getDeliveryTypeInt() -> Int?{
        switch getDeliveryType() {
        case DeliveryType.delivery.rawValue:
            return 1
            
        case DeliveryType.collection.rawValue:
            return 2
            
        case DeliveryType.delivery.rawValue:
            return 3
            
        default:
            return 1
        }
    }
    
    
    func setLicenseNum(licenseNum : String){
        self.licenseNum = licenseNum
    }
    
    func getLicenseNum() -> String? {
        return licenseNum
    }
    
    func setShopSchedule(shopSchedule : [Schedule]){
        self.shopSchedule = shopSchedule
    }
    
    func getShopSchedule() -> [Schedule] {
        return shopSchedule
    }
}

