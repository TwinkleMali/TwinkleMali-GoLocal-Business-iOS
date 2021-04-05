//
//  MergerRequestDetail.swift
//
//  Created by C100-104 on 01/04/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct MergerRequestDetail {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let orderUniqueId = "order_unique_id"
    static let id = "id"
    static let mergeRequestId = "merge_request_id"
    static let mergedOrderPickupTime = "merged_order_pickup_time"
  }

  // MARK: Properties
  public var orderUniqueId: String?
  public var id: Int?
  public var mergeRequestId: String?
  public var mergedOrderPickupTime: Int?

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
    orderUniqueId = json[SerializationKeys.orderUniqueId].string
    id = json[SerializationKeys.id].int
    mergeRequestId = json[SerializationKeys.mergeRequestId].string
    mergedOrderPickupTime = json[SerializationKeys.mergedOrderPickupTime].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = orderUniqueId { dictionary[SerializationKeys.orderUniqueId] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = mergeRequestId { dictionary[SerializationKeys.mergeRequestId] = value }
    if let value = mergedOrderPickupTime { dictionary[SerializationKeys.mergedOrderPickupTime] = value }
    return dictionary
  }

}
