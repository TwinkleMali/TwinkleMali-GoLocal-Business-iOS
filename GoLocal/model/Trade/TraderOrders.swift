//
//  TraderOrders.swift
//
//  Created by C100-104 on 08/06/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct TraderOrders {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let businessQuotationDetail = "business_quotation_detail"
    static let serRequest = "trade_request_detail"
  }

  // MARK: Properties
  public var businessQuotationDetail: BusinessQuotationDetail?
  public var serRequest: SerRequests?

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
    businessQuotationDetail = BusinessQuotationDetail(json: json[SerializationKeys.businessQuotationDetail])
    serRequest = SerRequests(json: json[SerializationKeys.serRequest])
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = businessQuotationDetail { dictionary[SerializationKeys.businessQuotationDetail] = value.dictionaryRepresentation() }
    if let value = serRequest { dictionary[SerializationKeys.serRequest] = value.dictionaryRepresentation() }
    return dictionary
  }

}
