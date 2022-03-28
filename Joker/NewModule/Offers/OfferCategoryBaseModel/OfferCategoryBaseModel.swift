//
//  OfferCategoryBaseModel.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 29, 2020
//
import Foundation
import SwiftyJSON

struct OfferCategoryBaseModel {

	let status: String?
	let responseMessage: String?
	let Data: [OfferCategoryData]?

	init(_ json: JSON) {
		status = json["status"].stringValue
		responseMessage = json["response_message"].stringValue
		Data = json["Data"].arrayValue.map { OfferCategoryData($0) }
	}

}
