//
//  TradeRequestBillingDetails.swift
//
//  Created by C100-104 on 08/06/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct TradeRequestBillingDetails {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let serviceCharge = "service_charge"
    static let extraCharge = "extra_charge"
    static let totalAmount = "total_amount"
    static let isPaymentDone = "is_payment_done"
    static let extraChargeDetail = "extra_charge_detail"
    static let bidAmount = "bid_amount"
  }

  // MARK: Properties
  public var serviceCharge: Double?
  public var extraCharge: Double?
  public var totalAmount: Double?
  public var isPaymentDone: Bool? = false
  public var extraChargeDetail: ExtraChargeDetail?
  public var bidAmount: Double?

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
    serviceCharge = json[SerializationKeys.serviceCharge].double
    extraCharge = json[SerializationKeys.extraCharge].double
    totalAmount = json[SerializationKeys.totalAmount].double
    isPaymentDone = json[SerializationKeys.isPaymentDone].boolValue
    extraChargeDetail = ExtraChargeDetail(json: json[SerializationKeys.extraChargeDetail])
    bidAmount = json[SerializationKeys.bidAmount].double
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = serviceCharge { dictionary[SerializationKeys.serviceCharge] = value }
    if let value = extraCharge { dictionary[SerializationKeys.extraCharge] = value }
    if let value = totalAmount { dictionary[SerializationKeys.totalAmount] = value }
    dictionary[SerializationKeys.isPaymentDone] = isPaymentDone
    if let value = extraChargeDetail { dictionary[SerializationKeys.extraChargeDetail] = value.dictionaryRepresentation() }
    if let value = bidAmount { dictionary[SerializationKeys.bidAmount] = value }
    return dictionary
  }

}
