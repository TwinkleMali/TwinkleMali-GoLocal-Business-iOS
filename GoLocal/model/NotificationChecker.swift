//
//  NotificationChecker.swift
//
//  Created by Jagjeetsingh Labana on 17/06/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct NotificationChecker {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let lastNotificationDate = "last_notification_date"
    static let hoursDifference = "hours_difference"
    static let canSendNotification = "can_send_notification"
  }

  // MARK: Properties
  public var lastNotificationDate: String?
  public var hoursDifference: String?
  public var canSendNotification: Bool? = false

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
    lastNotificationDate = json[SerializationKeys.lastNotificationDate].string
    hoursDifference = json[SerializationKeys.hoursDifference].string
    canSendNotification = json[SerializationKeys.canSendNotification].boolValue
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = lastNotificationDate { dictionary[SerializationKeys.lastNotificationDate] = value }
    if let value = hoursDifference { dictionary[SerializationKeys.hoursDifference] = value }
    dictionary[SerializationKeys.canSendNotification] = canSendNotification
    return dictionary
  }

}
