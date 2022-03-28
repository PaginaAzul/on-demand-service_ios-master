//
//  SellerData.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 21, 2020
//
import Foundation
import SwiftyJSON

struct SellerDataGetOrder {

	let email: String?
	let cuisinesName: [String]?
	let mobileNumber: String?
	let closingTime: String?
	let openingTime: String?
	let subCategoryName: [Any]?
	let totalRatingByUser: Int?
	let description: String?
	let deliveryTime: Int?
	let image: String?
	let totalRating: Int?
	let longitude: String?
	let address: String?
	let location: LocationGetOrder?
	let name: String?
	let minimumValue: Int?
	let latitude: String?
	let avgRating: Int?
	let categoryName: [Any]?

	init(_ json: JSON) {
		email = json["email"].stringValue
		cuisinesName = json["cuisinesName"].arrayValue.map { $0.stringValue }
		mobileNumber = json["mobileNumber"].stringValue
		closingTime = json["closingTime"].stringValue
		openingTime = json["openingTime"].stringValue
		subCategoryName = json["subCategoryName"].arrayValue.map { $0 }
		totalRatingByUser = json["totalRatingByUser"].intValue
		description = json["description"].stringValue
		deliveryTime = json["deliveryTime"].intValue
		image = json["image"].stringValue
		totalRating = json["totalRating"].intValue
		longitude = json["longitude"].stringValue
		address = json["address"].stringValue
		location = LocationGetOrder(json["location"])
		name = json["name"].stringValue
		minimumValue = json["minimumValue"].intValue
		latitude = json["latitude"].stringValue
		avgRating = json["avgRating"].intValue
		categoryName = json["categoryName"].arrayValue.map { $0 }
	}

}
