//
//  DeliveryChargeDataModel.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on June 05, 2021
//
import Foundation
import SwiftyJSON

class DeliveryChargeDataModel {

	let status: String?
	let Data: DeliveryChargeData?
	let responseMessage: String?

	init(_ json: JSON) {
		status = json["status"].stringValue
		Data = DeliveryChargeData(json["Data"])
		responseMessage = json["response_message"].stringValue
	}

}
