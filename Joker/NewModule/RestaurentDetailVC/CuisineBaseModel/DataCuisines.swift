//
//  Data.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on January 04, 2021
//
import Foundation
import SwiftyJSON

struct DataCuisines {

	let status: String?
	let deleteStatus: Bool?
	let Id: String?
	let name: String?
	let image: String?
	let resAndStoreId: String?
	let createdAt: String?
	let updatedAt: String?
	let _v: Int?

	init(_ json: JSON) {
		status = json["status"].stringValue
		deleteStatus = json["deleteStatus"].boolValue
		Id = json["_id"].stringValue
		name = json["name"].stringValue
		image = json["image"].stringValue
		resAndStoreId = json["resAndStoreId"].stringValue
		createdAt = json["createdAt"].stringValue
		updatedAt = json["updatedAt"].stringValue
		_v = json["__v"].intValue
	}

}
