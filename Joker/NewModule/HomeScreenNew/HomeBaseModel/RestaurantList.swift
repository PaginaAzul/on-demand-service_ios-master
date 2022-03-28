//
//  RestaurantList.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 05, 2020
//
import Foundation
import SwiftyJSON

struct RestaurantList {

	let categoryName: [Any]?
	let status: String?
	let mobileNumber: String?
	let image: String?
	let openingTime: String?
	let Id: String?
	let document: String?
	let minimumValue: Int?
	let description: String?
	let updatedAt: String?
	let address: String?
	let name: String?
	let closingTime: String?
	let isFav: Bool?
	let location: Location?
	let dist: Dist?
	let deliveryTime: Int?
	let totalRating: Int?
	let totalRatingByUser: Int?
	let email: String?
	let cuisinesName: [String]?
	let avgRating: Float?
	let latitude: String?
	let longitude: String?
	let createdAt: String?
	let subCategoryName: [Any]?
	let storeType: String?

	init(_ json: JSON) {
		categoryName = json["categoryName"].arrayValue.map { $0 }
		status = json["status"].stringValue
		mobileNumber = json["mobileNumber"].stringValue
		image = json["image"].stringValue
		openingTime = json["openingTime"].stringValue
		Id = json["_id"].stringValue
		document = json["document"].stringValue
		minimumValue = json["minimumValue"].intValue
		description = json["description"].stringValue
		updatedAt = json["updatedAt"].stringValue
		address = json["address"].stringValue
		name = json["name"].stringValue
		closingTime = json["closingTime"].stringValue
		isFav = json["isFav"].boolValue
		location = Location(json["location"])
		dist = Dist(json["dist"])
		deliveryTime = json["deliveryTime"].intValue
		totalRating = json["totalRating"].intValue
		totalRatingByUser = json["totalRatingByUser"].intValue
		email = json["email"].stringValue
		cuisinesName = json["cuisinesName"].arrayValue.map { $0.stringValue }
		avgRating = json["avgRating"].floatValue
		latitude = json["latitude"].stringValue
		longitude = json["longitude"].stringValue
		createdAt = json["createdAt"].stringValue
		subCategoryName = json["subCategoryName"].arrayValue.map { $0 }
		storeType = json["storeType"].stringValue
	}

}
