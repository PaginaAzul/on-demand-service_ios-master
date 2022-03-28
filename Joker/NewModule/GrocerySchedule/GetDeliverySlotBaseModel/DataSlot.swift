//
//  Data.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 28, 2020
//
import Foundation
import SwiftyJSON

struct DataSlot {

	let status: String?
	let deleteStatus: Bool?
	let Id: String?
	let resAndStoreId: String?
	let openTime: String?
	let closeTime: String?
	let day: String?
	let timeSlot: String?
	let createdAt: String?
	let updatedAt: String?
	let _v: Int?

	init(_ json: JSON) {
		status = json["status"].stringValue
		deleteStatus = json["deleteStatus"].boolValue
		Id = json["_id"].stringValue
		resAndStoreId = json["resAndStoreId"].stringValue
		openTime = json["openTime"].stringValue
		closeTime = json["closeTime"].stringValue
		day = json["day"].stringValue
		timeSlot = json["timeSlot"].stringValue
		createdAt = json["createdAt"].stringValue
		updatedAt = json["updatedAt"].stringValue
		_v = json["__v"].intValue
	}

}
