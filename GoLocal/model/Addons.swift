//
//  Addons.swift
//
//  Created by C110 on 10/02/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Addons : Codable{

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let addonPrice = "addon_price"
    static let id = "id"
    static let addonName = "addon_name"
    static let addonId = "addon_id"
  }

  // MARK: Properties
  public var addonPrice: Float?
  public var id: Int?
  public var addonName: String?
  public var addonId: Int?

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
    addonPrice = json[SerializationKeys.addonPrice].float
    id = json[SerializationKeys.id].int
    addonName = json[SerializationKeys.addonName].string
    addonId = json[SerializationKeys.addonId].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = addonPrice { dictionary[SerializationKeys.addonPrice] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = addonName { dictionary[SerializationKeys.addonName] = value }
    if let value = addonId { dictionary[SerializationKeys.addonId] = value }
    return dictionary
  }

}
