//
//  BusinessNotifications.swift
//
//  Created by Jagjeetsingh Labana on 17/06/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BusinessNotifications {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let notificationTitle = "notification_title"
    static let id = "id"
    static let notificationMessage = "notification_message"
    static let createdAt = "created_at"
  }

  // MARK: Properties
  public var notificationTitle: String?
  public var id: Int?
  public var notificationMessage: String?
  public var createdAt: String?

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
    notificationTitle = json[SerializationKeys.notificationTitle].string
    id = json[SerializationKeys.id].int
    notificationMessage = json[SerializationKeys.notificationMessage].string
    createdAt = json[SerializationKeys.createdAt].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = notificationTitle { dictionary[SerializationKeys.notificationTitle] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = notificationMessage { dictionary[SerializationKeys.notificationMessage] = value }
    if let value = createdAt { dictionary[SerializationKeys.createdAt] = value }
    return dictionary
  }

}
