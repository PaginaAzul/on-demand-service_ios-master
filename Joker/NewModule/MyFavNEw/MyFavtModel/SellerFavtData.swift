//
//  SellerData.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 08, 2020
//
import Foundation
import SwiftyJSON

struct SellerFavtData {

	let totalRating: Int?
	let avgRating: Int?
	let totalRatingByUser: Int?
	let cuisinesName: [String]?
	let categoryName: [Any]?
	let subCategoryName: [Any]?
	let name: String?
	let image: String?
	let email: String?
	let mobileNumber: String?
	let address: String?
	let longitude: String?
	let latitude: String?
	let closingTime: String?
	let deliveryTime: Int?
	let minimumValue: Int?
	let openingTime: String?
	let description: String?

	init(_ json: JSON) {
		totalRating = json["totalRating"].intValue
		avgRating = json["avgRating"].intValue
		totalRatingByUser = json["totalRatingByUser"].intValue
		cuisinesName = json["cuisinesName"].arrayValue.map { $0.stringValue }
		categoryName = json["categoryName"].arrayValue.map { $0 }
		subCategoryName = json["subCategoryName"].arrayValue.map { $0 }
		name = json["name"].stringValue
		image = json["image"].stringValue
		email = json["email"].stringValue
		mobileNumber = json["mobileNumber"].stringValue
		address = json["address"].stringValue
		longitude = json["longitude"].stringValue
		latitude = json["latitude"].stringValue
		closingTime = json["closingTime"].stringValue
		deliveryTime = json["deliveryTime"].intValue
		minimumValue = json["minimumValue"].intValue
		openingTime = json["openingTime"].stringValue
		description = json["description"].stringValue
	}

}
