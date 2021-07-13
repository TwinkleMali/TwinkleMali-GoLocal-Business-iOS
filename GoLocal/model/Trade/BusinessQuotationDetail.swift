//
//  BusinessQuotationDetail.swift
//
//  Created by C100-104 on 08/06/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BusinessQuotationDetail {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let tradeRequestBillingDetails = "trade_request_billing_details"
    static let requestId = "request_id"
    static let responseStatus = "response_status"
    static let businessOption = "business_option"
    static let callOutFeeOnly = "call_out_fee_only"
    static let paymentOptions = "payment_options"
    static let businessId = "business_id"
    static let arrivalTime = "arrival_time"
    static let bidAmount = "bid_amount"
    static let customerResponseStatus = "customer_response_status"
    static let depositeValue = "deposite_value"
    static let id = "id"
    static let quoteDesc = "quote_desc"
    static let businessOptionValue = "business_option_value"
    static let depositOption = "deposit_option"
  }

  // MARK: Properties
  public var tradeRequestBillingDetails: TradeRequestBillingDetails?
  public var requestId: Int?
  public var responseStatus: String?
  public var businessOption: String?
  public var callOutFeeOnly: Int?
  public var paymentOptions: [PaymentOptions]?
  public var businessId: Int?
  public var arrivalTime: Int?
  public var bidAmount: Int?
  public var customerResponseStatus: String?
  public var depositeValue: Int?
  public var id: Int?
  public var quoteDesc: String?
  public var businessOptionValue: String?
  public var depositOption: String?

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
    tradeRequestBillingDetails = TradeRequestBillingDetails(json: json[SerializationKeys.tradeRequestBillingDetails])
    requestId = json[SerializationKeys.requestId].int
    responseStatus = json[SerializationKeys.responseStatus].string
    businessOption = json[SerializationKeys.businessOption].string
    callOutFeeOnly = json[SerializationKeys.callOutFeeOnly].int
    if let items = json[SerializationKeys.paymentOptions].array { paymentOptions = items.map { PaymentOptions(json: $0) } }
    businessId = json[SerializationKeys.businessId].int
    arrivalTime = json[SerializationKeys.arrivalTime].int
    bidAmount = json[SerializationKeys.bidAmount].int
    customerResponseStatus = json[SerializationKeys.customerResponseStatus].string
    depositeValue = json[SerializationKeys.depositeValue].int
    id = json[SerializationKeys.id].int
    quoteDesc = json[SerializationKeys.quoteDesc].string
    businessOptionValue = json[SerializationKeys.businessOptionValue].string
    depositOption = json[SerializationKeys.depositOption].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = tradeRequestBillingDetails { dictionary[SerializationKeys.tradeRequestBillingDetails] = value.dictionaryRepresentation() }
    if let value = requestId { dictionary[SerializationKeys.requestId] = value }
    if let value = responseStatus { dictionary[SerializationKeys.responseStatus] = value }
    if let value = businessOption { dictionary[SerializationKeys.businessOption] = value }
    if let value = callOutFeeOnly { dictionary[SerializationKeys.callOutFeeOnly] = value }
    if let value = paymentOptions { dictionary[SerializationKeys.paymentOptions] = value.map { $0.dictionaryRepresentation() } }
    if let value = businessId { dictionary[SerializationKeys.businessId] = value }
    if let value = arrivalTime { dictionary[SerializationKeys.arrivalTime] = value }
    if let value = bidAmount { dictionary[SerializationKeys.bidAmount] = value }
    if let value = customerResponseStatus { dictionary[SerializationKeys.customerResponseStatus] = value }
    if let value = depositeValue { dictionary[SerializationKeys.depositeValue] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = quoteDesc { dictionary[SerializationKeys.quoteDesc] = value }
    if let value = businessOptionValue { dictionary[SerializationKeys.businessOptionValue] = value }
    if let value = depositOption { dictionary[SerializationKeys.depositOption] = value }
    return dictionary
  }

}
