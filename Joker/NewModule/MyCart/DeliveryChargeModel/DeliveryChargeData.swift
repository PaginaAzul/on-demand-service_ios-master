//
//  Data.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on June 05, 2021
//
import Foundation
import SwiftyJSON

class DeliveryChargeData {

	let Id: String?
	let updatedAt: String?
	let deleteStatus: Bool?
	let deliveryCharge: Int?
	let resAndStoreId: String?
	let createdAt: String?
	let _v: Int?
	let currency: String?
	let status: String?
	let commission: Int?
	let minimumValue: Int?

	init(_ json: JSON) {
		Id = json["_id"].stringValue
		updatedAt = json["updatedAt"].stringValue
		deleteStatus = json["deleteStatus"].boolValue
		deliveryCharge = json["deliveryCharge"].intValue
		resAndStoreId = json["resAndStoreId"].stringValue
		createdAt = json["createdAt"].stringValue
		_v = json["__v"].intValue
		currency = json["currency"].stringValue
		status = json["status"].stringValue
		commission = json["commission"].intValue
		minimumValue = json["minimumValue"].intValue
	}

}
