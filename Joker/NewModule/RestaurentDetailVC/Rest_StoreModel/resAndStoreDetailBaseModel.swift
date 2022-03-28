//
//  resAndStoreDetailBaseModel.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 05, 2020
//
import Foundation
import SwiftyJSON

struct ResAndStoreDetailBaseModel {

	let status: String?
	let responseMessage: String?
	let Data: DataDetails?

	init(_ json: JSON) {
		status = json["status"].stringValue
		responseMessage = json["response_message"].stringValue
		Data = DataDetails(json["Data"])
	}

}
