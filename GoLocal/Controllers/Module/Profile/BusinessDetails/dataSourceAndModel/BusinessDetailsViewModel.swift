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
    private var countryCode : String?
    private var countryId : String?
    private var shopSchedule : [Schedule] = []
    private var sliderImages : [SliderImages] = []
    private var deletedImages : [Int] = []
    private var arrImages : [UIImage] = []
    private var country : Country!
    
}

extension BusinessDetailsViewModel {
    func setBusinessDetail(objBusinessDetail : ShopDetail){
        self.objBusinessDetail = objBusinessDetail
        self.setStoreName(storeName: objBusinessDetail.name.asStringOrEmpty())
        self.setStoreLocation(storeLocation: objBusinessDetail.address.asStringOrEmpty())
        self.setEmail(email: objBusinessDetail.email.asStringOrEmpty())
        self.setContactNum(contactNum: objBusinessDetail.phone.asStringOrEmpty())
        self.setWebsite(website: objBusinessDetail.website.asStringOrEmpty())
        self.setCountryCode(countryCode: objBusinessDetail.countryCode.asStringOrEmpty())
        self.setCountryId(countryId: objBusinessDetail.countryId.asStringOrEmpty())
        self.setDeliveryType(deliveryType: objBusinessDetail.deliveryOption.asStringOrEmpty())
        self.setLicenseNum(licenseNum: objBusinessDetail.businessLicenceNumber.asStringOrEmpty())
        self.setLatitude(latitude: objBusinessDetail.latitude.asStringOrEmpty())
        self.setLongitude(longitude: objBusinessDetail.longitude.asStringOrEmpty())
        self.setShopSchedule(shopSchedule: objBusinessDetail.schedule!)
        self.setSliderImages(sliderImages: objBusinessDetail.sliderImages!)
        arrImages.removeAll()
        let obj = COUNTRY_LIST.filter({($0.id ?? 230) == objBusinessDetail.countryId})
        self.setSelectedCountry(country: obj[0])
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
    
    func setCountryCode(countryCode : String){
        self.countryCode = countryCode
    }
    
    func getCountryCode() -> String? {
        return countryCode
    }
    
    func setCountryId(countryId : String){
        self.countryId = countryId
    }
    
    func getCountryId() -> String? {
        return countryId
    }
    
    func setSelectedCountry(country : Country ){
        self.country = country
    }
    
    func getSelectedCountry() -> Country? {
        return country
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
    
    func getDeliveryTypeInt(str : String) -> Int?{
        switch str {
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
    
    func removeShopSchedule(){
         shopSchedule.removeAll()
    }
    
    func setSliderImages(sliderImages : [SliderImages]){
        self.sliderImages = sliderImages
    }
    
    func getSliderImages() -> [SliderImages] {
        return sliderImages
    }
    
    func removeSliderImage(at : Int){
        sliderImages.remove(at: at)
    }
    
    func setDeletedImage(strValue : Int){
        if !deletedImages.contains(strValue){
            self.deletedImages.append(strValue)
        }        
    }
    
    func getDeletedImage() -> [Int] {
        return deletedImages
    }
    
    
    func setImage(image : UIImage){
        self.arrImages.append(image)
    }
    
    func getImages() -> [UIImage] {
        return arrImages
    }
    
    func removeImages(at : Int) {
        arrImages.remove(at: at)
    }
    
    func getShopScheduleDic() -> NSMutableArray{
        let jsonArray : NSMutableArray = []
        if shopSchedule.count > 0{
            for obj in shopSchedule{
                var scheduleDic : [String:Any] = [:]
                scheduleDic["id"] = obj.id ?? 0
                scheduleDic["opening_time"] = obj.openingTime.asStringOrEmpty()
                scheduleDic["closing_time"] = obj.closingTime.asStringOrEmpty()
                scheduleDic["weekday"] = obj.weekday.asStringOrEmpty()
                scheduleDic["is_closed"] = obj.isClosed ?? 0
                scheduleDic["delivery_type"] = self.getDeliveryTypeInt(str: obj.deliveryType ?? "") ?? ""
                jsonArray.add(scheduleDic)
            }
        }
        print(json(from: jsonArray)!)
        return jsonArray
    }
}

