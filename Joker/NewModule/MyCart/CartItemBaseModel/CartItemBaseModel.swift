//
//  CartItemBaseModel.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 08, 2020
//
import Foundation
import SwiftyJSON

struct CartItemBaseModel {

	let status: String?
	let responseMessage: String?
	let Data: [CartItemData]?

	init(_ json: JSON) {
		status = json["status"].stringValue
		responseMessage = json["response_message"].stringValue
		Data = json["Data"].arrayValue.map { CartItemData($0) }
	}

}
