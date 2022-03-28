//
//  RatingModel.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on January 08, 2021
//
import Foundation
import SwiftyJSON

struct RatingModel {

	let userData: UserData?
	let review: String?
	let userId: String?
	let Id: String?
	let createdAt: String?
	let resAndStoreId: String?
	let updatedAt: String?
	let rating: Int?
	let status: String?

	init(_ json: JSON) {
		userData = UserData(json["userData"])
		review = json["review"].stringValue
		userId = json["userId"].stringValue
		Id = json["_id"].stringValue
		createdAt = json["createdAt"].stringValue
		resAndStoreId = json["resAndStoreId"].stringValue
		updatedAt = json["updatedAt"].stringValue
		rating = json["rating"].intValue
		status = json["status"].stringValue
	}

}

