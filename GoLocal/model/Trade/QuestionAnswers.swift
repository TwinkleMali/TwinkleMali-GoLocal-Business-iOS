//
//  QuestionAnswers.swift
//
//  Created by Jagjeetsingh Labana on 28/05/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct QuestionAnswers {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let optionId = "option_id"
    static let questionId = "question_id"
    static let isEmergency = "is_emergency"
    static let isInitialQuestion = "is_initial_question"
    static let optionValue = "option_value"
    static let isSubcategory = "is_subcategory"
    static let optionType = "option_type"
    static let question = "question"
  }

  // MARK: Properties
  public var optionId: Int?
  public var questionId: Int?
  public var isEmergency: Int?
  public var isInitialQuestion: Int?
  public var optionValue: String?
  public var isSubcategory: Int?
  public var optionType: String?
  public var question: String?

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
    optionId = json[SerializationKeys.optionId].int
    questionId = json[SerializationKeys.questionId].int
    isEmergency = json[SerializationKeys.isEmergency].int
    isInitialQuestion = json[SerializationKeys.isInitialQuestion].int
    optionValue = json[SerializationKeys.optionValue].string
    isSubcategory = json[SerializationKeys.isSubcategory].int
    optionType = json[SerializationKeys.optionType].string
    question = json[SerializationKeys.question].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = optionId { dictionary[SerializationKeys.optionId] = value }
    if let value = questionId { dictionary[SerializationKeys.questionId] = value }
    if let value = isEmergency { dictionary[SerializationKeys.isEmergency] = value }
    if let value = isInitialQuestion { dictionary[SerializationKeys.isInitialQuestion] = value }
    if let value = optionValue { dictionary[SerializationKeys.optionValue] = value }
    if let value = isSubcategory { dictionary[SerializationKeys.isSubcategory] = value }
    if let value = optionType { dictionary[SerializationKeys.optionType] = value }
    if let value = question { dictionary[SerializationKeys.question] = value }
    return dictionary
  }

}
