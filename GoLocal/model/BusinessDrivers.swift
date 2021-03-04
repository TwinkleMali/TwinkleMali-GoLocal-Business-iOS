//
//  BusinessDrivers.swift
//
//  Created by C110 on 11/02/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BusinessDrivers  {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let busyDrivers = "busy_drivers"
    static let availableDrivers = "available_drivers"
    static let offlineDrivers = "offline_drivers"
  }

  // MARK: Properties
  public var busyDrivers: [Drivers]?
  public var availableDrivers: [Drivers]?
  public var offlineDrivers: [Drivers]?

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
    if let items = json[SerializationKeys.busyDrivers].array { busyDrivers = items.map { Drivers(json: $0) } }
    if let items = json[SerializationKeys.availableDrivers].array { availableDrivers = items.map { Drivers(json: $0) } }
    if let items = json[SerializationKeys.offlineDrivers].array { offlineDrivers = items.map { Drivers(json: $0) } }
    
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]  
    if let value = busyDrivers { dictionary[SerializationKeys.busyDrivers] = value.map { $0.dictionaryRepresentation() } }
    if let value = availableDrivers { dictionary[SerializationKeys.availableDrivers] = value.map { $0.dictionaryRepresentation() } }
    if let value = offlineDrivers { dictionary[SerializationKeys.offlineDrivers] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

}
