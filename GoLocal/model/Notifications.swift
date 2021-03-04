//
//  Notifications.swift
//
//  Created by C110 on 03/03/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Notifications : Codable{

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let id = "id"
    static let dataId = "data_id"
    static let isRead = "is_read"
    static let notificationTypeId = "notification_type_id"
    static let notificationTitle = "notification_title"
    static let createdAt = "created_at"
    static let notificationType = "notification_type"
    static let notificationMessage = "notification_message"
    static let seviceCategory = "sevice_category"
    static let serviceCategoryId = "service_category_id"
  }

  // MARK: Properties
  public var id: Int?
  public var dataId: Int?
  public var isRead: Int?
  public var notificationTypeId: Int?
  public var notificationTitle: String?
  public var createdAt: String?
  public var notificationType: String?
  public var notificationMessage: String?
  public var seviceCategory: String?
  public var serviceCategoryId: Int?

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
    id = json[SerializationKeys.id].int
    dataId = json[SerializationKeys.dataId].int
    isRead = json[SerializationKeys.isRead].int
    notificationTypeId = json[SerializationKeys.notificationTypeId].int
    notificationTitle = json[SerializationKeys.notificationTitle].string
    createdAt = json[SerializationKeys.createdAt].string
    notificationType = json[SerializationKeys.notificationType].string
    notificationMessage = json[SerializationKeys.notificationMessage].string
    seviceCategory = json[SerializationKeys.seviceCategory].string
    serviceCategoryId = json[SerializationKeys.serviceCategoryId].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = dataId { dictionary[SerializationKeys.dataId] = value }
    if let value = isRead { dictionary[SerializationKeys.isRead] = value }
    if let value = notificationTypeId { dictionary[SerializationKeys.notificationTypeId] = value }
    if let value = notificationTitle { dictionary[SerializationKeys.notificationTitle] = value }
    if let value = createdAt { dictionary[SerializationKeys.createdAt] = value }
    if let value = notificationType { dictionary[SerializationKeys.notificationType] = value }
    if let value = notificationMessage { dictionary[SerializationKeys.notificationMessage] = value }
    if let value = seviceCategory { dictionary[SerializationKeys.seviceCategory] = value }
    if let value = serviceCategoryId { dictionary[SerializationKeys.serviceCategoryId] = value }
    return dictionary
  }

}
