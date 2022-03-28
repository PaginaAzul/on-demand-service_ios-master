//
//  Data.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 29, 2020
//
import Foundation
import SwiftyJSON

struct OfferCategoryData {

	let status: String?
	let deleteStatus: Bool?
	let Id: String?
	let image: String?
	let storeId: String?
	let name: String?
	let createdAt: String?
	let updatedAt: String?
	let _v: Int?

	init(_ json: JSON) {
		status = json["status"].stringValue
		deleteStatus = json["deleteStatus"].boolValue
		Id = json["_id"].stringValue
		image = json["image"].stringValue
		storeId = json["storeId"].stringValue
		name = json["name"].stringValue
		createdAt = json["createdAt"].stringValue
		updatedAt = json["updatedAt"].stringValue
		_v = json["__v"].intValue
	}

}
