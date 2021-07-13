//
//  RequestSchedule.swift
//
//  Created by Jagjeetsingh Labana on 28/05/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct RequestSchedule {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let id = "id"
    static let endRequestDatetime = "end_request_datetime"
    static let startRequestDatetime = "start_request_datetime"
  }

  // MARK: Properties
  public var id: Int?
  public var endRequestDatetime: String?
  public var startRequestDatetime: String?

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
    endRequestDatetime = json[SerializationKeys.endRequestDatetime].string
    startRequestDatetime = json[SerializationKeys.startRequestDatetime].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = endRequestDatetime { dictionary[SerializationKeys.endRequestDatetime] = value }
    if let value = startRequestDatetime { dictionary[SerializationKeys.startRequestDatetime] = value }
    return dictionary
  }

}
