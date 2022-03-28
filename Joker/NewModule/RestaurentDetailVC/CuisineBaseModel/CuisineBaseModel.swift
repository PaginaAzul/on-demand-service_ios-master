//
//  CuisineBaseModel.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on January 04, 2021
//
import Foundation
import SwiftyJSON

struct CuisineBaseModel {

	let responseCode: Int?
	let responseMessage: String?
	let Data: [DataCuisines]?

	init(_ json: JSON) {
		responseCode = json["response_code"].intValue
		responseMessage = json["response_message"].stringValue
		Data = json["Data"].arrayValue.map { DataCuisines($0) }
	}

}
