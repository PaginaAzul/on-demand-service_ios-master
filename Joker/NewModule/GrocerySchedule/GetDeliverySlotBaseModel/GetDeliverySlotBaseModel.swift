//
//  GetDeliverySlotBaseModel.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 28, 2020
//
import Foundation
import SwiftyJSON

struct GetDeliverySlotBaseModel {

	let status: String?
	let responseMessage: String?
	let Data: [DataSlot]?

	init(_ json: JSON) {
		status = json["status"].stringValue
		responseMessage = json["response_message"].stringValue
		Data = json["Data"].arrayValue.map { DataSlot($0) }
	}

}
