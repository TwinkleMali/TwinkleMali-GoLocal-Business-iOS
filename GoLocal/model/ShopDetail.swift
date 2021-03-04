//
//  ShopDetail.swift
//
//  Created by C110 on 10/02/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct ShopDetail : Codable{

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let email = "email"
    static let website = "website"
    static let address = "address"
    static let countryId = "country_id"
    static let products = "products"
    static let storeOrderAmount = "store_order_amount"
    static let latitude = "latitude"
    static let storeLogo = "store_logo"
    static let businessLicenceNumber = "business_licence_number"
    static let phone = "phone"
    static let orderShopId = "order_shop_id"
    static let deliveryOption = "delivery_option"
    static let userId = "user_id"
    static let longitude = "longitude"
    static let shopDesc = "shop_desc"
  }

  // MARK: Properties
  public var name: String?
  public var email: String?
  public var website: String?
  public var address: String?
  public var countryId: Int?
  public var products: [Products]?
  public var storeOrderAmount: Float?
  public var latitude: String?
  public var storeLogo: String?
  public var businessLicenceNumber: String?
  public var phone: String?
  public var orderShopId: Int?
  public var deliveryOption: String?
  public var userId: Int?
  public var longitude: String?
  public var shopDesc: String?

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
    name = json[SerializationKeys.name].string
    email = json[SerializationKeys.email].string
    website = json[SerializationKeys.website].string
    address = json[SerializationKeys.address].string
    countryId = json[SerializationKeys.countryId].int
    if let items = json[SerializationKeys.products].array { products = items.map { Products(json: $0) } }
    storeOrderAmount = json[SerializationKeys.storeOrderAmount].float
    latitude = json[SerializationKeys.latitude].string
    storeLogo = json[SerializationKeys.storeLogo].string
    businessLicenceNumber = json[SerializationKeys.businessLicenceNumber].string
    phone = json[SerializationKeys.phone].string
    orderShopId = json[SerializationKeys.orderShopId].int
    deliveryOption = json[SerializationKeys.deliveryOption].string
    userId = json[SerializationKeys.userId].int
    longitude = json[SerializationKeys.longitude].string
    shopDesc = json[SerializationKeys.shopDesc].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = email { dictionary[SerializationKeys.email] = value }
    if let value = website { dictionary[SerializationKeys.website] = value }
    if let value = address { dictionary[SerializationKeys.address] = value }
    if let value = countryId { dictionary[SerializationKeys.countryId] = value }
    if let value = products { dictionary[SerializationKeys.products] = value.map { $0.dictionaryRepresentation() } }
    if let value = storeOrderAmount { dictionary[SerializationKeys.storeOrderAmount] = value }
    if let value = latitude { dictionary[SerializationKeys.latitude] = value }
    if let value = storeLogo { dictionary[SerializationKeys.storeLogo] = value }
    if let value = businessLicenceNumber { dictionary[SerializationKeys.businessLicenceNumber] = value }
    if let value = phone { dictionary[SerializationKeys.phone] = value }
    if let value = orderShopId { dictionary[SerializationKeys.orderShopId] = value }
    if let value = deliveryOption { dictionary[SerializationKeys.deliveryOption] = value }
    if let value = userId { dictionary[SerializationKeys.userId] = value }
    if let value = longitude { dictionary[SerializationKeys.longitude] = value }
    if let value = shopDesc { dictionary[SerializationKeys.shopDesc] = value }
    return dictionary
  }

}
