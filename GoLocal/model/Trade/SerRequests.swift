//
//  SerRequests.swift
//
//  Created by Jagjeetsingh Labana on 28/05/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct SerRequests {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let requestId = "request_id"
    static let customerDetails = "customer_details"
    static let completedAt = "completed_at"
    static let createdAt = "created_at"
    static let questionAnswers = "question_answers"
    static let userAddress = "user_address"
    static let userLatitude = "user_latitude"
    static let serviceNeeded = "service_needed"
    static let statusModifiedAt = "status_modified_at"
    static let isEmergency = "is_emergency"
    static let serviceCategories = "service_categories"
    static let requestStatus = "request_status"
    static let requestAttachments = "request_attachments"
    static let id = "id"
    static let userLongitude = "user_longitude"
    static let requestType = "request_type"
    static let userId = "user_id"
    static let requestSchedule = "request_schedule"
  }

  // MARK: Properties
  public var requestId: Int?
  public var customerDetails: CustomerDetails?
  public var completedAt: String?
    public var createdAt: String?
  public var questionAnswers: [QuestionAnswers]?
  public var userAddress: String?
  public var userLatitude: String?
  public var serviceNeeded: String?
  public var statusModifiedAt: String?
  public var isEmergency: Int?
  public var serviceCategories: [ServiceCategories]?
  public var requestStatus: String?
  public var requestAttachments: [RequestAttachments]?
  public var id: Int?
  public var userLongitude: String?
  public var requestType: String?
  public var userId: Int?
  public var requestSchedule: [RequestSchedule]?

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
    requestId = json[SerializationKeys.requestId].int
    customerDetails = CustomerDetails(json: json[SerializationKeys.customerDetails])
    completedAt = json[SerializationKeys.completedAt].string
    createdAt = json[SerializationKeys.createdAt].string
    if let items = json[SerializationKeys.questionAnswers].array { questionAnswers = items.map { QuestionAnswers(json: $0) } }
    userAddress = json[SerializationKeys.userAddress].string
    userLatitude = json[SerializationKeys.userLatitude].string
    serviceNeeded = json[SerializationKeys.serviceNeeded].string
    statusModifiedAt = json[SerializationKeys.statusModifiedAt].string
    isEmergency = json[SerializationKeys.isEmergency].int
    if let items = json[SerializationKeys.serviceCategories].array { serviceCategories = items.map { ServiceCategories(json: $0) } }
    requestStatus = json[SerializationKeys.requestStatus].string
    if let items = json[SerializationKeys.requestAttachments].array { requestAttachments = items.map { RequestAttachments(json: $0) } }
    id = json[SerializationKeys.id].int
    userLongitude = json[SerializationKeys.userLongitude].string
    requestType = json[SerializationKeys.requestType].string
    userId = json[SerializationKeys.userId].int
    if let items = json[SerializationKeys.requestSchedule].array { requestSchedule = items.map { RequestSchedule(json: $0) } }
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = requestId { dictionary[SerializationKeys.requestId] = value }
    if let value = customerDetails { dictionary[SerializationKeys.customerDetails] = value.dictionaryRepresentation() }
    if let value = completedAt { dictionary[SerializationKeys.completedAt] = value }
    if let value = createdAt { dictionary[SerializationKeys.createdAt] = value }
    if let value = questionAnswers { dictionary[SerializationKeys.questionAnswers] = value.map { $0.dictionaryRepresentation() } }
    if let value = userAddress { dictionary[SerializationKeys.userAddress] = value }
    if let value = userLatitude { dictionary[SerializationKeys.userLatitude] = value }
    if let value = serviceNeeded { dictionary[SerializationKeys.serviceNeeded] = value }
    if let value = statusModifiedAt { dictionary[SerializationKeys.statusModifiedAt] = value }
    if let value = isEmergency { dictionary[SerializationKeys.isEmergency] = value }
    if let value = serviceCategories { dictionary[SerializationKeys.serviceCategories] = value.map { $0.dictionaryRepresentation() } }
    if let value = requestStatus { dictionary[SerializationKeys.requestStatus] = value }
    if let value = requestAttachments { dictionary[SerializationKeys.requestAttachments] = value.map { $0.dictionaryRepresentation() } }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = userLongitude { dictionary[SerializationKeys.userLongitude] = value }
    if let value = requestType { dictionary[SerializationKeys.requestType] = value }
    if let value = userId { dictionary[SerializationKeys.userId] = value }
    if let value = requestSchedule { dictionary[SerializationKeys.requestSchedule] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

}
