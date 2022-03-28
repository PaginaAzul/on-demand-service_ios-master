//
//  Data.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 22, 2020
//
import Foundation
import SwiftyJSON

struct DataStory {

	let status: String?
	let Id: String?
	let image: String?
	let resAndStoreId: ResAndStoreId?
	let username: String?
	let story: String?
	let createdAt: String?
	let updatedAt: String?
	let _v: Int?

	init(_ json: JSON) {
		status = json["status"].stringValue
		Id = json["_id"].stringValue
		image = json["image"].stringValue
		resAndStoreId = ResAndStoreId(json["resAndStoreId"])
		username = json["username"].stringValue
		story = json["story"].stringValue
		createdAt = json["createdAt"].stringValue
		updatedAt = json["updatedAt"].stringValue
		_v = json["__v"].intValue
	}

}
