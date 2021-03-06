//
//  Schedule.swift
//
//  Created by C110 on 05/03/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Schedule {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let openingTime = "opening_time"
    static let id = "id"
    static let deliveryType = "delivery_type"
    static let weekday = "weekday"
    static let closingTime = "closing_time"
    static let coinPercentage = "coin_percentage"
    static let isClosed = "is_closed"
  }

  // MARK: Properties
  public var openingTime: String?
  public var id: Int?
  public var deliveryType: String?
  public var weekday: String?
  public var closingTime: String?
  public var coinPercentage: Int?
  public var isClosed: Int?

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
    openingTime = json[SerializationKeys.openingTime].string
    id = json[SerializationKeys.id].int
    deliveryType = json[SerializationKeys.deliveryType].string
    weekday = json[SerializationKeys.weekday].string
    closingTime = json[SerializationKeys.closingTime].string
    coinPercentage = json[SerializationKeys.coinPercentage].int
    isClosed = json[SerializationKeys.isClosed].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = openingTime { dictionary[SerializationKeys.openingTime] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = deliveryType { dictionary[SerializationKeys.deliveryType] = value }
    if let value = weekday { dictionary[SerializationKeys.weekday] = value }
    if let value = closingTime { dictionary[SerializationKeys.closingTime] = value }
    if let value = coinPercentage { dictionary[SerializationKeys.coinPercentage] = value }
    if let value = isClosed { dictionary[SerializationKeys.isClosed] = value }
    return dictionary
  }

}
