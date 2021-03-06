//
//  Categories.swift
//
//  Created by C110 on 05/03/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Categories {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let parentId = "parent_id"
    static let categoryName = "category_name"
    static let id = "id"
    static let categoryImage = "category_image"
  }

  // MARK: Properties
  public var parentId: Int?
  public var categoryName: String?
  public var id: Int?
  public var categoryImage: String?

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
    parentId = json[SerializationKeys.parentId].int
    categoryName = json[SerializationKeys.categoryName].string
    id = json[SerializationKeys.id].int
    categoryImage = json[SerializationKeys.categoryImage].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = parentId { dictionary[SerializationKeys.parentId] = value }
    if let value = categoryName { dictionary[SerializationKeys.categoryName] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = categoryImage { dictionary[SerializationKeys.categoryImage] = value }
    return dictionary
  }

}
