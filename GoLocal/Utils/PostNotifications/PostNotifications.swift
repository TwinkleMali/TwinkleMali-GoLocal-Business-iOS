//
//  PostNotifications.swift
//  GoferDeliveryCustomer
//
//  Created by C100-104 on 31/03/20.
//  Copyright © 2020 C100-104. All rights reserved.
//

import Foundation

//MARK:- NOTIFICATION CENTER
let nc = NotificationCenter.default

//MARK:- SEND NOTIFICATION CENTER NOTIFICATION
func postNotification(withName notificationName: String, userInfo : [AnyHashable : Any]) {
  nc.post(name: Notification.Name(rawValue: notificationName), object: nil, userInfo: userInfo)
}

//MARK:- NOTIFICATION KEYS
enum notificationCenterKeys : String {
	case commentReceived = "comment-received-for-feedback"
	case leaveFeedbackRoom = "Leave_Feedback_Chat_Room"
    case joinFeedbackRoom = "Join_Feedback_Room"
    case shopOrderRequest = "shop_order_request"
    case shopRequestTimeout = "shop_request_timeout"
    case shopRejectOrder = "shop_reject_order"
    case shopAcceptOrder = "shop_accept_order"
    case shopRejectOrderByOther = "shop_reject_order_by_other"
    case shopAcceptOrderByOther = "shop_accept_order_by_other"
    case rejectReason = "reject_reason"
    case driverRunningOrderDetail = "driver_running_order_detail"
    case driver_availibility_change_ack = "driver_availibility_change_ack"
    case changeTakeawayOrderStatus = "changeTakeawayOrderStatus"
    case getSingleOrderDetails = "getSingleOrderDetails"
    case updateDriverLocation = "updateDriverLocation"
    case sendBusinessPaymentRequest = "sendBusinessPaymentRequest"
    case changeBusinessPaymentRequestStatus = "changeBusinessPaymentRequestStatus"
    case paymentRequestStatusChangeAck = "payment_request_status_change_ack"
  
}
