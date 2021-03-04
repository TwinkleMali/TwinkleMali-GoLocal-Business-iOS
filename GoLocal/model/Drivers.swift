//
//  Drivers.swift
//
//  Created by C110 on 12/02/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Drivers {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let email = "email"
    static let username = "username"
    static let latitude = "latitude"
    static let phonecode = "phonecode"
    static let isDriverVerified = "is_driver_verified"
    static let id = "id"
    static let driverStatus = "driver_status"
    static let isPhoneVerified = "is_phone_verified"
    static let lname = "lname"
    static let phone = "phone"
    static let userImage = "user_image"
    static let longitude = "longitude"
  }

  // MARK: Properties
  public var name: String?
  public var email: String?
  public var username: String?
  public var latitude: String?
  public var phonecode: Int?
  public var isDriverVerified: Int?
  public var id: Int?
  public var driverStatus: Int?
  public var isPhoneVerified: Int?
  public var lname: String?
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
    username = json[SerializationKeys.username].string
    latitude = json[SerializationKeys.latitude].string
    phonecode = json[SerializationKeys.phonecode].int
    isDriverVerified = json[SerializationKeys.isDriverVerified].int
    id = json[SerializationKeys.id].int
    driverStatus = json[SerializationKeys.driverStatus].int
    isPhoneVerified = json[SerializationKeys.isPhoneVerified].int
    lname = json[SerializationKeys.lname].string
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
    if let value = username { dictionary[SerializationKeys.username] = value }
    if let value = latitude { dictionary[SerializationKeys.latitude] = value }
    if let value = phonecode { dictionary[SerializationKeys.phonecode] = value }
    if let value = isDriverVerified { dictionary[SerializationKeys.isDriverVerified] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = driverStatus { dictionary[SerializationKeys.driverStatus] = value }
    if let value = isPhoneVerified { dictionary[SerializationKeys.isPhoneVerified] = value }
    if let value = lname { dictionary[SerializationKeys.lname] = value }
    if let value = phone { dictionary[SerializationKeys.phone] = value }
    if let value = userImage { dictionary[SerializationKeys.userImage] = value }
    if let value = longitude { dictionary[SerializationKeys.longitude] = value }
    return dictionary
  }

}
