//
//  ProductDetailBaseModel.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 25, 2020
//
import Foundation
import SwiftyJSON

struct ProductDetailBaseModel {

	let status: String?
	let responseMessage: String?
	let Data: DataProduct?

	init(_ json: JSON) {
		status = json["status"].stringValue
		responseMessage = json["response_message"].stringValue
		Data = DataProduct(json["Data"])
	}

}
