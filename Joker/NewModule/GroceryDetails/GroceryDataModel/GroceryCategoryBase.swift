//
//  GroceryCategoryBase.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 24, 2020
//
import Foundation
import SwiftyJSON

struct GroceryCategoryBase {

	let responseCode: Int?
	let responseMessage: String?
	let Data: [GroceryData]?

	init(_ json: JSON) {
		responseCode = json["response_code"].intValue
		responseMessage = json["response_message"].stringValue
		Data = json["Data"].arrayValue.map { GroceryData($0) }
	}

}
