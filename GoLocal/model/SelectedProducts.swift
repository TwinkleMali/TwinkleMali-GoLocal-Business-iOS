//
//  SelectedProducts.swift
//
//  Created by C110 on 10/02/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct SelectedProducts : Codable{

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let variationName = "variation_name"
    static let id = "id"
    static let addons = "addons"
    static let quantity = "quantity"
    static let productVariationId = "product_variation_id"
    static let productPrice = "product_price"
    static let offerPercentage = "offer_percentage"
    static let productOfferId = "product_offer_id"
  }

  // MARK: Properties
  public var variationName: String?
  public var id: Int?
  public var addons: [Addons]?
  public var quantity: Int?
  public var productVariationId: Int?
  public var productPrice: Float?
  public var offerPercentage: Int?
  public var productOfferId: Int?

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
    variationName = json[SerializationKeys.variationName].string
    id = json[SerializationKeys.id].int
    if let items = json[SerializationKeys.addons].array { addons = items.map { Addons(json: $0) } }
    quantity = json[SerializationKeys.quantity].int
    productVariationId = json[SerializationKeys.productVariationId].int
    productPrice = json[SerializationKeys.productPrice].float
    offerPercentage = json[SerializationKeys.offerPercentage].int
    productOfferId = json[SerializationKeys.productOfferId].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = variationName { dictionary[SerializationKeys.variationName] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = addons { dictionary[SerializationKeys.addons] = value.map { $0.dictionaryRepresentation() } }
    if let value = quantity { dictionary[SerializationKeys.quantity] = value }
    if let value = productVariationId { dictionary[SerializationKeys.productVariationId] = value }
    if let value = productPrice { dictionary[SerializationKeys.productPrice] = value }
    if let value = offerPercentage { dictionary[SerializationKeys.offerPercentage] = value }
    if let value = productOfferId { dictionary[SerializationKeys.productOfferId] = value }
    return dictionary
  }

}
