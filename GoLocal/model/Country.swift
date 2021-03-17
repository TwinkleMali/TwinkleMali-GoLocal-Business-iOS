//
//  Country.swift
//
//  Created by C100-104 on 05/01/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Country : Codable {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let phonecode = "phonecode"
    static let name = "name"
    static let id = "id"
    static let sortname = "sortname"
  }

  // MARK: Properties
  public var phonecode: Int?
  public var name: String?
  public var id: Int?
  public var sortname: String?

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
    phonecode = json[SerializationKeys.phonecode].int
    name = json[SerializationKeys.name].string
    id = json[SerializationKeys.id].int
    sortname = json[SerializationKeys.sortname].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = phonecode { dictionary[SerializationKeys.phonecode] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = sortname { dictionary[SerializationKeys.sortname] = value }
    return dictionary
  }

}
