//
//  ShopDetail.swift
//
//  Created by C110 on 05/03/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct ShopDetail {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let isActive = "is_active"
    static let isPromoted = "is_promoted"
    static let zipcode = "zipcode"
    static let maxRedeemPoint = "max_redeem_point"
    static let minDeliveryCharge = "min_delivery_charge"
    static let latitude = "latitude"
    static let minDeliveryTime = "min_delivery_time"
    static let businessLicenceNumber = "business_licence_number"
    static let countryCode = "country_code"
    static let id = "id"
    static let deliveryRating = "delivery_rating"
    static let phone = "phone"
    static let deliveryRange = "delivery_range"
    static let schedule = "schedule"
    static let longitude = "longitude"
    static let deliveryOption = "delivery_option"
    static let shopDesc = "shop_desc"
    static let landmark = "landmark"
    static let foodRating = "food_rating"
    static let name = "name"
    static let email = "email"
    static let website = "website"
    static let address = "address"
    static let countryId = "country_id"
    static let sliderImages = "slider_images"
    static let storeLogo = "store_logo"
    static let categories = "categories"
    static let zipcodeId = "zipcode_id"
    static let userId = "user_id"
    static let products = "products"
  }

  // MARK: Properties
  public var isActive: Int?
  public var isPromoted: Int?
  public var zipcode: String?
  public var maxRedeemPoint: Int?
  public var minDeliveryCharge: Float?
  public var latitude: String?
  public var minDeliveryTime: Int?
  public var businessLicenceNumber: String?
  public var countryCode: Int?
  public var id: Int?
  public var deliveryRating: Int?
  public var phone: String?
  public var deliveryRange: Int?
  public var schedule: [Schedule]?
  public var longitude: String?
  public var deliveryOption: String?
  public var shopDesc: String?
  public var landmark: String?
  public var foodRating: Int?
  public var name: String?
  public var email: String?
  public var website: String?
  public var address: String?
  public var countryId: Int?
  public var sliderImages: [SliderImages]?
  public var storeLogo: String?
  public var categories: [Categories]?
  public var products: [Products]?
  public var zipcodeId: Int?
  public var userId: Int?

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public init(json: JSON) {
    isActive = json[SerializationKeys.isActive].int
    isPromoted = json[SerializationKeys.isPromoted].int
    zipcode = json[SerializationKeys.zipcode].string
    maxRedeemPoint = json[SerializationKeys.maxRedeemPoint].int
    minDeliveryCharge = json[SerializationKeys.minDeliveryCharge].float
    latitude = json[SerializationKeys.latitude].string
    minDeliveryTime = json[SerializationKeys.minDeliveryTime].int
    businessLicenceNumber = json[SerializationKeys.businessLicenceNumber].string
    countryCode = json[SerializationKeys.countryCode].int
    id = json[SerializationKeys.id].int
    deliveryRating = json[SerializationKeys.deliveryRating].int
    phone = json[SerializationKeys.phone].string
    deliveryRange = json[SerializationKeys.deliveryRange].int
    if let items = json[SerializationKeys.schedule].array { schedule = items.map { Schedule(json: $0) } }
    longitude = json[SerializationKeys.longitude].string
    deliveryOption = json[SerializationKeys.deliveryOption].string
    shopDesc = json[SerializationKeys.shopDesc].string
    landmark = json[SerializationKeys.landmark].string
    foodRating = json[SerializationKeys.foodRating].int
    name = json[SerializationKeys.name].string
    email = json[SerializationKeys.email].string
    website = json[SerializationKeys.website].string
    address = json[SerializationKeys.address].string
    countryId = json[SerializationKeys.countryId].int
    if let items = json[SerializationKeys.sliderImages].array { sliderImages = items.map { SliderImages(json: $0) } }
    storeLogo = json[SerializationKeys.storeLogo].string
    if let items = json[SerializationKeys.categories].array { categories = items.map { Categories(json: $0) } }
    if let items = json[SerializationKeys.products].array { products = items.map { Products(json: $0) } }
    zipcodeId = json[SerializationKeys.zipcodeId].int
    userId = json[SerializationKeys.userId].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = isActive { dictionary[SerializationKeys.isActive] = value }
    if let value = isPromoted { dictionary[SerializationKeys.isPromoted] = value }
    if let value = zipcode { dictionary[SerializationKeys.zipcode] = value }
    if let value = maxRedeemPoint { dictionary[SerializationKeys.maxRedeemPoint] = value }
    if let value = minDeliveryCharge { dictionary[SerializationKeys.minDeliveryCharge] = value }
    if let value = latitude { dictionary[SerializationKeys.latitude] = value }
    if let value = minDeliveryTime { dictionary[SerializationKeys.minDeliveryTime] = value }
    if let value = businessLicenceNumber { dictionary[SerializationKeys.businessLicenceNumber] = value }
    if let value = countryCode { dictionary[SerializationKeys.countryCode] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = deliveryRating { dictionary[SerializationKeys.deliveryRating] = value }
    if let value = phone { dictionary[SerializationKeys.phone] = value }
    if let value = deliveryRange { dictionary[SerializationKeys.deliveryRange] = value }
    if let value = schedule { dictionary[SerializationKeys.schedule] = value.map { $0.dictionaryRepresentation() } }
    if let value = longitude { dictionary[SerializationKeys.longitude] = value }
    if let value = deliveryOption { dictionary[SerializationKeys.deliveryOption] = value }
    if let value = shopDesc { dictionary[SerializationKeys.shopDesc] = value }
    if let value = landmark { dictionary[SerializationKeys.landmark] = value }
    if let value = foodRating { dictionary[SerializationKeys.foodRating] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = email { dictionary[SerializationKeys.email] = value }
    if let value = website { dictionary[SerializationKeys.website] = value }
    if let value = address { dictionary[SerializationKeys.address] = value }
    if let value = countryId { dictionary[SerializationKeys.countryId] = value }
    if let value = sliderImages { dictionary[SerializationKeys.sliderImages] = value.map { $0.dictionaryRepresentation() } }
    if let value = storeLogo { dictionary[SerializationKeys.storeLogo] = value }
    if let value = categories { dictionary[SerializationKeys.categories] = value.map { $0.dictionaryRepresentation() } }
    if let value = products { dictionary[SerializationKeys.products] = value.map { $0.dictionaryRepresentation() } }
    if let value = zipcodeId { dictionary[SerializationKeys.zipcodeId] = value }
    if let value = userId { dictionary[SerializationKeys.userId] = value }
    return dictionary
  }

}
