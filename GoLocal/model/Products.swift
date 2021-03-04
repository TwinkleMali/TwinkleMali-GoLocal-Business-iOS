//
//  Products.swift
//
//  Created by C110 on 10/02/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Products : Codable{

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let sku = "sku"
    static let productDescription = "product_description"
    static let slug = "slug"
    static let id = "id"
    static let selectedProducts = "selected_products"
    static let productName = "product_name"
    static let productTotalPrice = "product_total_price"
    static let productImage = "product_image"
  }

  // MARK: Properties
  public var sku: String?
  public var productDescription: String?
  public var slug: String?
  public var id: Int?
  public var selectedProducts: [SelectedProducts]?
  public var productName: String?
  public var productTotalPrice: Float?
  public var productImage: String?

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
    sku = json[SerializationKeys.sku].string
    productDescription = json[SerializationKeys.productDescription].string
    slug = json[SerializationKeys.slug].string
    id = json[SerializationKeys.id].int
    if let items = json[SerializationKeys.selectedProducts].array { selectedProducts = items.map { SelectedProducts(json: $0) } }
    productName = json[SerializationKeys.productName].string
    productTotalPrice = json[SerializationKeys.productTotalPrice].float
    productImage = json[SerializationKeys.productImage].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = sku { dictionary[SerializationKeys.sku] = value }
    if let value = productDescription { dictionary[SerializationKeys.productDescription] = value }
    if let value = slug { dictionary[SerializationKeys.slug] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = selectedProducts { dictionary[SerializationKeys.selectedProducts] = value.map { $0.dictionaryRepresentation() } }
    if let value = productName { dictionary[SerializationKeys.productName] = value }
    if let value = productTotalPrice { dictionary[SerializationKeys.productTotalPrice] = value }
    if let value = productImage { dictionary[SerializationKeys.productImage] = value }
    return dictionary
  }

}
