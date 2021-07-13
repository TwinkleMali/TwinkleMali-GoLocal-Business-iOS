//
//  ExtraChargeDetail.swift
//
//  Created by C100-104 on 08/06/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct ExtraChargeDetail {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let isApproved = "is_approved"
    static let extra = "extra"
    static let chargeDescription = "charge_description"
  }

  // MARK: Properties
  public var isApproved: Int?
  public var extra: Int?
  public var chargeDescription: String?

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
    isApproved = json[SerializationKeys.isApproved].int
    extra = json[SerializationKeys.extra].int
    chargeDescription = json[SerializationKeys.chargeDescription].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = isApproved { dictionary[SerializationKeys.isApproved] = value }
    if let value = extra { dictionary[SerializationKeys.extra] = value }
    if let value = chargeDescription { dictionary[SerializationKeys.chargeDescription] = value }
    return dictionary
  }

}
