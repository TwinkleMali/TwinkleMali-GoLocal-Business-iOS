//
//  OrderRequests.swift
//
//  Created by C110 on 10/02/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct OrderRequests : Codable{

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let orderDetails = "order_details"
    static let orderId = "order_id"
    static let status = "status"
    static let orderTimerValue = "order_timer_value"
    static let customerId = "customer_id"
  }

  // MARK: Properties
  public var orderDetails: OrderDetails?
  public var orderId: Int?
  public var status: Int?
  public var orderTimerValue: Int?
  public var customerId: Int?

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
    orderDetails = OrderDetails(json: json[SerializationKeys.orderDetails])
    orderId = json[SerializationKeys.orderId].int
    status = json[SerializationKeys.status].int
    orderTimerValue = json[SerializationKeys.orderTimerValue].int
    customerId = json[SerializationKeys.customerId].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = orderDetails { dictionary[SerializationKeys.orderDetails] = value.dictionaryRepresentation() }
    if let value = orderId { dictionary[SerializationKeys.orderId] = value }
    if let value = status { dictionary[SerializationKeys.status] = value }
    if let value = orderTimerValue { dictionary[SerializationKeys.orderTimerValue] = value }
    if let value = customerId { dictionary[SerializationKeys.customerId] = value }
    return dictionary
  }

}
