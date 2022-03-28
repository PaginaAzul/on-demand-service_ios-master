//
//  RatingData.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on January 12, 2021
//
import Foundation
import SwiftyJSON

struct RatingData {

	let orderId: String?
	let rating: Int?
	let userId: String?
	let status: String?
	let Id: String?
	let updatedAt: String?
	let resAndStoreId: String?
	let createdAt: String?
	let _v: Int?
	let review: String?

	init(_ json: JSON) {
		orderId = json["orderId"].stringValue
		rating = json["rating"].intValue
		userId = json["userId"].stringValue
		status = json["status"].stringValue
		Id = json["_id"].stringValue
		updatedAt = json["updatedAt"].stringValue
		resAndStoreId = json["resAndStoreId"].stringValue
		createdAt = json["createdAt"].stringValue
		_v = json["__v"].intValue
		review = json["review"].stringValue
	}

}