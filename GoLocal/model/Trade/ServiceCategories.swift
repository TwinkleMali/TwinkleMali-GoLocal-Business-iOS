//
//  ServiceCategories.swift
//
//  Created by Jagjeetsingh Labana on 28/05/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct ServiceCategories {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let serviceName = "service_name"
    static let serviceCategoryId = "service_category_id"
  }

  // MARK: Properties
  public var serviceName: String?
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
    serviceName = json[SerializationKeys.serviceName].string
    serviceCategoryId = json[SerializationKeys.serviceCategoryId].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = serviceName { dictionary[SerializationKeys.serviceName] = value }
    if let value = serviceCategoryId { dictionary[SerializationKeys.serviceCategoryId] = value }
    return dictionary
  }

}
