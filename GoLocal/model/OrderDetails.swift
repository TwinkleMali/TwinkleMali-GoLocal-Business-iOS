//
//  OrderDetails.swift
//
//  Created by C110 on 20/02/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct OrderDetails {

  // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
      static let totalDistance = "total_distance"
      static let deliveryLatitude = "delivery_latitude"
      static let driverDetails = "driver_details"
      static let driverNote = "driver_note"
      static let orderReceipt = "order_receipt"
      static let orderFor = "order_for"
      static let ontimeDeliveryRating = "ontime_delivery_rating"
      static let orderTotal = "order_total"
      static let isDriverRequestSent = "is_driver_request_sent"
      static let orderType = "order_type"
      static let sentShopRequestAt = "sent_shop_request_at"
      static let id = "id"
      static let orderScheduledDate = "order_scheduled_date"
      static let deliveryType = "delivery_type"
      static let estimatedDeliveryTime = "estimated_delivery_time"
      static let updatedServerTime = "updated_server_time"
      static let driverOrderTimerValue = "driver_order_timer_value"
      static let mergeRequestId = "merge_request_id"
      static let shopOrderTimerValue = "shop_order_timer_value"
      static let customerDetails = "customer_details"
      static let updatedAt = "updated_at"
      static let tip = "tip"
      static let shopDetail = "shop_detail"
      static let rejectReason = "reject_reason"
      static let deliveryAddress = "delivery_address"
      static let orderUniqueId = "order_unique_id"
      static let deliveryCharge = "delivery_charge"
      static let driverId = "driver_id"
      static let sentDriverRequestAt = "sent_driver_request_at"
      static let billingDetails = "billing_details"
      static let isReviewGiven = "is_review_given"
      static let orderStatus = "order_status"
      static let offerApplied = "offer_applied"
      static let orderTotalAmount = "order_total_amount"
      static let createdAt = "created_at"
      static let appliedPartnerCode = "applied_partner_code"
      static let serviceCharge = "service_charge"
      static let userId = "user_id"
      static let orderPickupTime = "order_pickup_time"
      static let mergerRequestDetail = "merger_request_detail"
      static let deliveryLongitude = "delivery_longitude"
      static let allergyDescription = "allergy_description"
    }

    // MARK: Properties
    public var totalDistance: Int?
    public var deliveryLatitude: String?
    public var driverDetails: Drivers?
    public var driverNote: String?
    public var orderReceipt: String?
    public var orderFor: String?
    public var ontimeDeliveryRating: Int?
    public var orderTotal: Double?
    public var isDriverRequestSent: Int?
    public var orderType: String?
    public var sentShopRequestAt: String?
    public var id: Int?
    public var orderScheduledDate: String?
    public var deliveryType: String?
    public var estimatedDeliveryTime: Int?
    public var updatedServerTime: String?
    public var driverOrderTimerValue: Int?
    public var mergeRequestId: String?
    public var shopOrderTimerValue: Int?
    public var customerDetails: CustomerDetails?
    public var updatedAt: String?
    public var tip: Int?
    public var shopDetail: ShopDetail?
    public var rejectReason: String?
    public var deliveryAddress: String?
    public var orderUniqueId: String?
    public var deliveryCharge: Double?
    public var driverId: Int?
    public var sentDriverRequestAt: String?
    public var billingDetails: BillingDetails?
    public var isReviewGiven: Int?
    public var orderStatus: String?
    public var offerApplied: Int?
    public var orderTotalAmount: Double?
    public var createdAt: String?
    public var appliedPartnerCode: String?
    public var serviceCharge: Float?
    public var userId: Int?
    public var orderPickupTime: Int?
    public var mergerRequestDetail: MergerRequestDetail?
    public var deliveryLongitude: String?
    public var allergyDescription: String?

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
      totalDistance = json[SerializationKeys.totalDistance].int
      deliveryLatitude = json[SerializationKeys.deliveryLatitude].string
      driverDetails = Drivers(json: json[SerializationKeys.driverDetails])
      driverNote = json[SerializationKeys.driverNote].string
      orderReceipt = json[SerializationKeys.orderReceipt].string
      orderFor = json[SerializationKeys.orderFor].string
      ontimeDeliveryRating = json[SerializationKeys.ontimeDeliveryRating].int
      orderTotal = json[SerializationKeys.orderTotal].double
      isDriverRequestSent = json[SerializationKeys.isDriverRequestSent].int
      orderType = json[SerializationKeys.orderType].string
      sentShopRequestAt = json[SerializationKeys.sentShopRequestAt].string
      id = json[SerializationKeys.id].int
      orderScheduledDate = json[SerializationKeys.orderScheduledDate].string
      deliveryType = json[SerializationKeys.deliveryType].string
      estimatedDeliveryTime = json[SerializationKeys.estimatedDeliveryTime].int
      updatedServerTime = json[SerializationKeys.updatedServerTime].string
      driverOrderTimerValue = json[SerializationKeys.driverOrderTimerValue].int
      mergeRequestId = json[SerializationKeys.mergeRequestId].string
      shopOrderTimerValue = json[SerializationKeys.shopOrderTimerValue].int
      customerDetails = CustomerDetails(json: json[SerializationKeys.customerDetails])
      updatedAt = json[SerializationKeys.updatedAt].string
      tip = json[SerializationKeys.tip].int
      shopDetail = ShopDetail(json: json[SerializationKeys.shopDetail])
      rejectReason = json[SerializationKeys.rejectReason].string
      deliveryAddress = json[SerializationKeys.deliveryAddress].string
      orderUniqueId = json[SerializationKeys.orderUniqueId].string
      deliveryCharge = json[SerializationKeys.deliveryCharge].double
      driverId = json[SerializationKeys.driverId].int
      sentDriverRequestAt = json[SerializationKeys.sentDriverRequestAt].string
      billingDetails = BillingDetails(json: json[SerializationKeys.billingDetails])
      isReviewGiven = json[SerializationKeys.isReviewGiven].int
      orderStatus = json[SerializationKeys.orderStatus].string
      offerApplied = json[SerializationKeys.offerApplied].int
      orderTotalAmount = json[SerializationKeys.orderTotalAmount].double
      createdAt = json[SerializationKeys.createdAt].string
      appliedPartnerCode = json[SerializationKeys.appliedPartnerCode].string
      serviceCharge = json[SerializationKeys.serviceCharge].float
      userId = json[SerializationKeys.userId].int
      orderPickupTime = json[SerializationKeys.orderPickupTime].int
      mergerRequestDetail = MergerRequestDetail(json: json[SerializationKeys.mergerRequestDetail])
      deliveryLongitude = json[SerializationKeys.deliveryLongitude].string
      allergyDescription = json[SerializationKeys.allergyDescription].string
    }

    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
      var dictionary: [String: Any] = [:]
      if let value = totalDistance { dictionary[SerializationKeys.totalDistance] = value }
      if let value = deliveryLatitude { dictionary[SerializationKeys.deliveryLatitude] = value }
      if let value = driverDetails { dictionary[SerializationKeys.driverDetails] = value.dictionaryRepresentation() }
      if let value = driverNote { dictionary[SerializationKeys.driverNote] = value }
      if let value = orderReceipt { dictionary[SerializationKeys.orderReceipt] = value }
      if let value = orderFor { dictionary[SerializationKeys.orderFor] = value }
      if let value = ontimeDeliveryRating { dictionary[SerializationKeys.ontimeDeliveryRating] = value }
      if let value = orderTotal { dictionary[SerializationKeys.orderTotal] = value }
      if let value = isDriverRequestSent { dictionary[SerializationKeys.isDriverRequestSent] = value }
      if let value = orderType { dictionary[SerializationKeys.orderType] = value }
      if let value = sentShopRequestAt { dictionary[SerializationKeys.sentShopRequestAt] = value }
      if let value = id { dictionary[SerializationKeys.id] = value }
      if let value = orderScheduledDate { dictionary[SerializationKeys.orderScheduledDate] = value }
      if let value = deliveryType { dictionary[SerializationKeys.deliveryType] = value }
      if let value = estimatedDeliveryTime { dictionary[SerializationKeys.estimatedDeliveryTime] = value }
      if let value = updatedServerTime { dictionary[SerializationKeys.updatedServerTime] = value }
      if let value = driverOrderTimerValue { dictionary[SerializationKeys.driverOrderTimerValue] = value }
      if let value = mergeRequestId { dictionary[SerializationKeys.mergeRequestId] = value }
      if let value = shopOrderTimerValue { dictionary[SerializationKeys.shopOrderTimerValue] = value }
      if let value = customerDetails { dictionary[SerializationKeys.customerDetails] = value.dictionaryRepresentation() }
      if let value = updatedAt { dictionary[SerializationKeys.updatedAt] = value }
      if let value = tip { dictionary[SerializationKeys.tip] = value }
      if let value = shopDetail { dictionary[SerializationKeys.shopDetail] = value.dictionaryRepresentation() }
      if let value = rejectReason { dictionary[SerializationKeys.rejectReason] = value }
      if let value = deliveryAddress { dictionary[SerializationKeys.deliveryAddress] = value }
      if let value = orderUniqueId { dictionary[SerializationKeys.orderUniqueId] = value }
      if let value = deliveryCharge { dictionary[SerializationKeys.deliveryCharge] = value }
      if let value = driverId { dictionary[SerializationKeys.driverId] = value }
      if let value = sentDriverRequestAt { dictionary[SerializationKeys.sentDriverRequestAt] = value }
      if let value = billingDetails { dictionary[SerializationKeys.billingDetails] = value.dictionaryRepresentation() }
      if let value = isReviewGiven { dictionary[SerializationKeys.isReviewGiven] = value }
      if let value = orderStatus { dictionary[SerializationKeys.orderStatus] = value }
      if let value = offerApplied { dictionary[SerializationKeys.offerApplied] = value }
      if let value = orderTotalAmount { dictionary[SerializationKeys.orderTotalAmount] = value }
      if let value = createdAt { dictionary[SerializationKeys.createdAt] = value }
      if let value = appliedPartnerCode { dictionary[SerializationKeys.appliedPartnerCode] = value }
      if let value = serviceCharge { dictionary[SerializationKeys.serviceCharge] = value }
      if let value = userId { dictionary[SerializationKeys.userId] = value }
      if let value = orderPickupTime { dictionary[SerializationKeys.orderPickupTime] = value }
      if let value = mergerRequestDetail { dictionary[SerializationKeys.mergerRequestDetail] = value.dictionaryRepresentation() }
      if let value = deliveryLongitude { dictionary[SerializationKeys.deliveryLongitude] = value }
      if let value = allergyDescription { dictionary[SerializationKeys.allergyDescription] = value }
      return dictionary
    }

}
