//
//  BillingDetails.swift
//
//  Created by C110 on 10/02/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BillingDetails : Codable{

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let offerAppliedOnDelivery = "offer_applied_on_delivery"
    static let offerAppliedOnServiceCharge = "offer_applied_on_service_charge"
    static let tip = "tip"
    static let appliedCouponCode = "applied_coupon_code"
    static let serviceCharge = "service_charge"
    static let deliveryCharge = "delivery_charge"
    static let totalItemsPrice = "total_items_price"
    static let offerDiscountPrice = "offer_discount_price"
    static let isCouponApplied = "is_coupon_applied"
    static let grandTotal = "grand_total"
  }

  // MARK: Properties
  public var offerAppliedOnDelivery: Int?
  public var offerAppliedOnServiceCharge: Int?
  public var tip: Int?
  public var appliedCouponCode: String?
  public var serviceCharge: Int?
  public var deliveryCharge: Int?
  public var totalItemsPrice: Float?
  public var offerDiscountPrice: Int?
  public var isCouponApplied: Int?
  public var grandTotal: Float?

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
    offerAppliedOnDelivery = json[SerializationKeys.offerAppliedOnDelivery].int
    offerAppliedOnServiceCharge = json[SerializationKeys.offerAppliedOnServiceCharge].int
    tip = json[SerializationKeys.tip].int
    appliedCouponCode = json[SerializationKeys.appliedCouponCode].string
    serviceCharge = json[SerializationKeys.serviceCharge].int
    deliveryCharge = json[SerializationKeys.deliveryCharge].int
    totalItemsPrice = json[SerializationKeys.totalItemsPrice].float
    offerDiscountPrice = json[SerializationKeys.offerDiscountPrice].int
    isCouponApplied = json[SerializationKeys.isCouponApplied].int
    grandTotal = json[SerializationKeys.grandTotal].float
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = offerAppliedOnDelivery { dictionary[SerializationKeys.offerAppliedOnDelivery] = value }
    if let value = offerAppliedOnServiceCharge { dictionary[SerializationKeys.offerAppliedOnServiceCharge] = value }
    if let value = tip { dictionary[SerializationKeys.tip] = value }
    if let value = appliedCouponCode { dictionary[SerializationKeys.appliedCouponCode] = value }
    if let value = serviceCharge { dictionary[SerializationKeys.serviceCharge] = value }
    if let value = deliveryCharge { dictionary[SerializationKeys.deliveryCharge] = value }
    if let value = totalItemsPrice { dictionary[SerializationKeys.totalItemsPrice] = value }
    if let value = offerDiscountPrice { dictionary[SerializationKeys.offerDiscountPrice] = value }
    if let value = isCouponApplied { dictionary[SerializationKeys.isCouponApplied] = value }
    if let value = grandTotal { dictionary[SerializationKeys.grandTotal] = value }
    return dictionary
  }

}
