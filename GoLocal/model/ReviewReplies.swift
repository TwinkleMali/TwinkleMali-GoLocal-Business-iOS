//
//  ReviewReplies.swift
//
//  Created by C110 on 04/03/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct ReviewReplies {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let review = "review"
    static let email = "email"
    static let id = "id"
    static let lname = "lname"
    static let reviewId = "review_id"
    static let userId = "user_id"
    static let userImage = "user_image"
    static let username = "username"
  }

  // MARK: Properties
  public var name: String?
  public var review: String?
  public var email: String?
  public var id: Int?
  public var lname: String?
  public var reviewId: Int?
  public var userId: Int?
  public var userImage: String?
  public var username: String?

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
    review = json[SerializationKeys.review].string
    email = json[SerializationKeys.email].string
    id = json[SerializationKeys.id].int
    lname = json[SerializationKeys.lname].string
    reviewId = json[SerializationKeys.reviewId].int
    userId = json[SerializationKeys.userId].int
    userImage = json[SerializationKeys.userImage].string
    username = json[SerializationKeys.username].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = review { dictionary[SerializationKeys.review] = value }
    if let value = email { dictionary[SerializationKeys.email] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = lname { dictionary[SerializationKeys.lname] = value }
    if let value = reviewId { dictionary[SerializationKeys.reviewId] = value }
    if let value = userId { dictionary[SerializationKeys.userId] = value }
    if let value = userImage { dictionary[SerializationKeys.userImage] = value }
    if let value = username { dictionary[SerializationKeys.username] = value }
    return dictionary
  }

}
