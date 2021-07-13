//
//  ServiceRequests.swift
//
//  Created by Jagjeetsingh Labana on 28/05/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct ServiceRequests {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let ser_requests = "requests"
    static let timerValue = "timer_value"
  }

  // MARK: Properties
  public var ser_requests: [SerRequests]?
  public var timerValue: Int?

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
    if let items = json[SerializationKeys.ser_requests].array { ser_requests = items.map { SerRequests(json: $0) } }
    timerValue = json[SerializationKeys.timerValue].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = ser_requests { dictionary[SerializationKeys.ser_requests] = value.map { $0.dictionaryRepresentation() } }
    if let value = timerValue { dictionary[SerializationKeys.timerValue] = value }
    return dictionary
  }

}
