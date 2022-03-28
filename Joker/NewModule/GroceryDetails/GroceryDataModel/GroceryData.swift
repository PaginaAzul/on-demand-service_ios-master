//
//  Data.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 24, 2020
//
import Foundation
import SwiftyJSON

struct GroceryData {

	let status: String?
	let deleteStatus: Bool?
	let Id: String?
    let categoryId:String?
	let name: String?
	let image: String?
	let createdAt: String?
	let updatedAt: String?
	let _v: Int?

	init(_ json: JSON) {
		status = json["status"].stringValue
		deleteStatus = json["deleteStatus"].boolValue
		Id = json["_id"].stringValue
        categoryId = json["categoryId"].stringValue
		name = json["name"].stringValue
		image = json["image"].stringValue
		createdAt = json["createdAt"].stringValue
		updatedAt = json["updatedAt"].stringValue
		_v = json["__v"].intValue
	}

}
