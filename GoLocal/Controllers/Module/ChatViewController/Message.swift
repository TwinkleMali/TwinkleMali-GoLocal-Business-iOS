//
//  Message.swift
//
//  Created by C100-104 on 03/03/21
//  Copyright (c) . All rights reserved.
//

import Foundation

struct Message: Codable {

  enum CodingKeys: String, CodingKey {
    case createdAt = "created_at"
    case message
    case updatedAt = "updated_at"
    case senderId = "sender_id"
    case id
    case receiverId = "receiver_id"
    case orderId = "order_id"
    case serviceRequestId = "service_request_id"
    case messageType = "message_type"
  }

  var createdAt: String?
  var message: String?
  var updatedAt: String?
  var senderId: Int?
  var id: Int?
  var receiverId: Int?
  var orderId: Int?
    var serviceRequestId: Int?
    var messageType: String?


  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
    message = try container.decodeIfPresent(String.self, forKey: .message)
    updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
    senderId = try container.decodeIfPresent(Int.self, forKey: .senderId)
    id = try container.decodeIfPresent(Int.self, forKey: .id)
    receiverId = try container.decodeIfPresent(Int.self, forKey: .receiverId)
    orderId = try container.decodeIfPresent(Int.self, forKey: .orderId)
    serviceRequestId = try container.decodeIfPresent(Int.self, forKey: .serviceRequestId)
    messageType = try container.decodeIfPresent(String.self, forKey: .messageType)
  }

}
