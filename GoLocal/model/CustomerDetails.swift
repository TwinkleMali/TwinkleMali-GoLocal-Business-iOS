//
//  CustomerDetails.swift
//
//  Created by C110 on 10/02/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CustomerDetails : Codable{

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let email = "email"
    static let isBusinessDriver = "is_business_driver"
    static let rating = "rating"
    static let roleName = "role_name"
    static let username = "username"
    static let latitude = "latitude"
    static let roleId = "role_id"
    static let id = "id"
    static let driverStatus = "driver_status"
    static let lname = "lname"
    static let countryCode = "country_code"
    static let phone = "phone"
    static let userImage = "user_image"
    static let longitude = "longitude"
  }

  // MARK: Properties
  public var name: String?
  public var email: String?
  public var isBusinessDriver: Int?
  public var rating: Int?
  public var roleName: String?
  public var username: String?
  public var latitude: String?
  public var roleId: Int?
  public var id: Int?
  public var driverStatus: Int?
  public var lname: String?
  public var countryCode: Int?
  public var phone: String?
  public var userImage: String?
  public var longitude: String?

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
    isBusinessDriver = json[SerializationKeys.isBusinessDriver].int
    rating = json[SerializationKeys.rating].int
    roleName = json[SerializationKeys.roleName].string
    username = json[SerializationKeys.username].string
    latitude = json[SerializationKeys.latitude].string
    roleId = json[SerializationKeys.roleId].int
    id = json[SerializationKeys.id].int
    driverStatus = json[SerializationKeys.driverStatus].int
    lname = json[SerializationKeys.lname].string
    countryCode = json[SerializationKeys.countryCode].int
    phone = json[SerializationKeys.phone].string
    userImage = json[SerializationKeys.userImage].string
    longitude = json[SerializationKeys.longitude].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = email { dictionary[SerializationKeys.email] = value }
    if let value = isBusinessDriver { dictionary[SerializationKeys.isBusinessDriver] = value }
    if let value = rating { dictionary[SerializationKeys.rating] = value }
    if let value = roleName { dictionary[SerializationKeys.roleName] = value }
    if let value = username { dictionary[SerializationKeys.username] = value }
    if let value = latitude { dictionary[SerializationKeys.latitude] = value }
    if let value = roleId { dictionary[SerializationKeys.roleId] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = driverStatus { dictionary[SerializationKeys.driverStatus] = value }
    if let value = lname { dictionary[SerializationKeys.lname] = value }
    if let value = countryCode { dictionary[SerializationKeys.countryCode] = value }
    if let value = phone { dictionary[SerializationKeys.phone] = value }
    if let value = userImage { dictionary[SerializationKeys.userImage] = value }
    if let value = longitude { dictionary[SerializationKeys.longitude] = value }
    return dictionary
  }

}
