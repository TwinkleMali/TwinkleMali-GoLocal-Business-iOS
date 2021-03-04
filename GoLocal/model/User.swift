//
//  User.swift
//
//  Created by C110 on 03/03/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct User : Codable{

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let state = "state"
    static let accountStatus = "account_status"
    static let googleKey = "google_key"
    static let zipcode = "zipcode"
    static let driverIdentityDetail = "driver_identity_detail"
    static let roleName = "role_name"
    static let isPasswordAvail = "is_password_avail"
    static let latitude = "latitude"
    static let id = "id"
    static let isEmailVerified = "is_email_verified"
    static let isPhoneVerified = "is_phone_verified"
    static let countryCode = "country_code"
    static let phone = "phone"
    static let userImage = "user_image"
    static let longitude = "longitude"
    static let emailVerifiedAt = "email_verified_at"
    static let name = "name"
    static let city = "city"
    static let email = "email"
    static let isBusinessDriver = "is_business_driver"
    static let stripeCustomerId = "stripe_customer_id"
    static let rating = "rating"
    static let shopId = "shop_id"
    static let username = "username"
    static let isDriverVerified = "is_driver_verified"
    static let roleId = "role_id"
    static let appleKey = "apple_key"
    static let totalPoints = "total_points"
    static let lname = "lname"
    static let streetAddress = "street_address"
    static let driverStatus = "driver_status"
    static let loginType = "login_type"
    static let qrcode = "qrcode"
    static let country = "country"
  }

  // MARK: Properties
  public var state: Int?
  public var accountStatus: Int?
  public var googleKey: String?
  public var zipcode: String?
  public var driverIdentityDetail: String?
  public var roleName: String?
  public var isPasswordAvail: Int?
  public var latitude: String?
  public var id: Int?
  public var isEmailVerified: Int?
  public var isPhoneVerified: Int?
  public var countryCode: Int?
  public var phone: String?
  public var userImage: String?
  public var longitude: String?
  public var emailVerifiedAt: String?
  public var name: String?
  public var city: Int?
  public var email: String?
  public var isBusinessDriver: Int?
  public var stripeCustomerId: String?
  public var rating: Int?
  public var shopId: Int?
  public var username: String?
  public var isDriverVerified: Int?
  public var roleId: Int?
  public var appleKey: String?
  public var totalPoints: Int?
  public var lname: String?
  public var streetAddress: String?
  public var driverStatus: Int?
  public var loginType: String?
  public var qrcode: String?
  public var country: Int?

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
    state = json[SerializationKeys.state].int
    accountStatus = json[SerializationKeys.accountStatus].int
    googleKey = json[SerializationKeys.googleKey].string
    zipcode = json[SerializationKeys.zipcode].string
    driverIdentityDetail = json[SerializationKeys.driverIdentityDetail].string
    roleName = json[SerializationKeys.roleName].string
    isPasswordAvail = json[SerializationKeys.isPasswordAvail].int
    latitude = json[SerializationKeys.latitude].string
    id = json[SerializationKeys.id].int
    isEmailVerified = json[SerializationKeys.isEmailVerified].int
    isPhoneVerified = json[SerializationKeys.isPhoneVerified].int
    countryCode = json[SerializationKeys.countryCode].int
    phone = json[SerializationKeys.phone].string
    userImage = json[SerializationKeys.userImage].string
    longitude = json[SerializationKeys.longitude].string
    emailVerifiedAt = json[SerializationKeys.emailVerifiedAt].string
    name = json[SerializationKeys.name].string
    city = json[SerializationKeys.city].int
    email = json[SerializationKeys.email].string
    isBusinessDriver = json[SerializationKeys.isBusinessDriver].int
    stripeCustomerId = json[SerializationKeys.stripeCustomerId].string
    rating = json[SerializationKeys.rating].int
    shopId = json[SerializationKeys.shopId].int
    username = json[SerializationKeys.username].string
    isDriverVerified = json[SerializationKeys.isDriverVerified].int
    roleId = json[SerializationKeys.roleId].int
    appleKey = json[SerializationKeys.appleKey].string
    totalPoints = json[SerializationKeys.totalPoints].int
    lname = json[SerializationKeys.lname].string
    streetAddress = json[SerializationKeys.streetAddress].string
    driverStatus = json[SerializationKeys.driverStatus].int
    loginType = json[SerializationKeys.loginType].string
    qrcode = json[SerializationKeys.qrcode].string
    country = json[SerializationKeys.country].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = state { dictionary[SerializationKeys.state] = value }
    if let value = accountStatus { dictionary[SerializationKeys.accountStatus] = value }
    if let value = googleKey { dictionary[SerializationKeys.googleKey] = value }
    if let value = zipcode { dictionary[SerializationKeys.zipcode] = value }
    if let value = driverIdentityDetail { dictionary[SerializationKeys.driverIdentityDetail] = value }
    if let value = roleName { dictionary[SerializationKeys.roleName] = value }
    if let value = isPasswordAvail { dictionary[SerializationKeys.isPasswordAvail] = value }
    if let value = latitude { dictionary[SerializationKeys.latitude] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = isEmailVerified { dictionary[SerializationKeys.isEmailVerified] = value }
    if let value = isPhoneVerified { dictionary[SerializationKeys.isPhoneVerified] = value }
    if let value = countryCode { dictionary[SerializationKeys.countryCode] = value }
    if let value = phone { dictionary[SerializationKeys.phone] = value }
    if let value = userImage { dictionary[SerializationKeys.userImage] = value }
    if let value = longitude { dictionary[SerializationKeys.longitude] = value }
    if let value = emailVerifiedAt { dictionary[SerializationKeys.emailVerifiedAt] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = city { dictionary[SerializationKeys.city] = value }
    if let value = email { dictionary[SerializationKeys.email] = value }
    if let value = isBusinessDriver { dictionary[SerializationKeys.isBusinessDriver] = value }
    if let value = stripeCustomerId { dictionary[SerializationKeys.stripeCustomerId] = value }
    if let value = rating { dictionary[SerializationKeys.rating] = value }
    if let value = shopId { dictionary[SerializationKeys.shopId] = value }
    if let value = username { dictionary[SerializationKeys.username] = value }
    if let value = isDriverVerified { dictionary[SerializationKeys.isDriverVerified] = value }
    if let value = roleId { dictionary[SerializationKeys.roleId] = value }
    if let value = appleKey { dictionary[SerializationKeys.appleKey] = value }
    if let value = totalPoints { dictionary[SerializationKeys.totalPoints] = value }
    if let value = lname { dictionary[SerializationKeys.lname] = value }
    if let value = streetAddress { dictionary[SerializationKeys.streetAddress] = value }
    if let value = driverStatus { dictionary[SerializationKeys.driverStatus] = value }
    if let value = loginType { dictionary[SerializationKeys.loginType] = value }
    if let value = qrcode { dictionary[SerializationKeys.qrcode] = value }
    if let value = country { dictionary[SerializationKeys.country] = value }
    return dictionary
  }

}
