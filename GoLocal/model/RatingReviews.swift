//
//  RatingReviews.swift
//
//  Created by C110 on 03/03/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct RatingReviews {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let orderId = "order_id"
    static let email = "email"
    static let rating = "rating"
    static let shopId = "shop_id"
    static let username = "username"
    static let storeLogo = "store_logo"
    static let review = "review"
    static let replies = "replies"
    static let id = "id"
    static let lname = "lname"
    static let createdAt = "created_at"
    static let userImage = "user_image"
    static let shopName = "shop_name"
    static let userId = "user_id"
  }

  // MARK: Properties
  public var name: String?
  public var orderId: Int?
  public var email: String?
  public var rating: Float?
  public var shopId: Int?
  public var username: String?
  public var storeLogo: String?
  public var review: String?
  public var replies: [Any]?
  public var id: Int?
  public var lname: String?
  public var createdAt: String?
  public var userImage: String?
  public var shopName: String?
  public var userId: Int?

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
    orderId = json[SerializationKeys.orderId].int
    email = json[SerializationKeys.email].string
    rating = json[SerializationKeys.rating].float
    shopId = json[SerializationKeys.shopId].int
    username = json[SerializationKeys.username].string
    storeLogo = json[SerializationKeys.storeLogo].string
    review = json[SerializationKeys.review].string
    if let items = json[SerializationKeys.replies].array { replies = items.map { $0.object} }
    id = json[SerializationKeys.id].int
    lname = json[SerializationKeys.lname].string
    createdAt = json[SerializationKeys.createdAt].string
    userImage = json[SerializationKeys.userImage].string
    shopName = json[SerializationKeys.shopName].string
    userId = json[SerializationKeys.userId].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = orderId { dictionary[SerializationKeys.orderId] = value }
    if let value = email { dictionary[SerializationKeys.email] = value }
    if let value = rating { dictionary[SerializationKeys.rating] = value }
    if let value = shopId { dictionary[SerializationKeys.shopId] = value }
    if let value = username { dictionary[SerializationKeys.username] = value }
    if let value = storeLogo { dictionary[SerializationKeys.storeLogo] = value }
    if let value = review { dictionary[SerializationKeys.review] = value }
    if let value = replies { dictionary[SerializationKeys.replies] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = lname { dictionary[SerializationKeys.lname] = value }
    if let value = createdAt { dictionary[SerializationKeys.createdAt] = value }
    if let value = userImage { dictionary[SerializationKeys.userImage] = value }
    if let value = shopName { dictionary[SerializationKeys.shopName] = value }
    if let value = userId { dictionary[SerializationKeys.userId] = value }
    return dictionary
  }

}
