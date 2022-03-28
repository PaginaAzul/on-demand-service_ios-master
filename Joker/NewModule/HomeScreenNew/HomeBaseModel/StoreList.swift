//
//  StoreList.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 05, 2020
//
import Foundation
import SwiftyJSON

struct StoreList {

	let name: String?
	let Id: String?
	let status: String?
	let updatedAt: String?
	let isFav: Bool?
	let dist: Dist?
	let totalRatingByUser: Int?
	let image: String?
	let latitude: String?
	let address: String?
	let avgRating: Float?
	let createdAt: String?
	let email: String?
	let storeType: String?
	let document: String?
	let location: Location?
	let categoryName: [String]?
	let subCategoryName: [String]?
	let totalRating: Int?
	let mobileNumber: String?
	let cuisinesName: [String]?
	let longitude: String?

	init(_ json: JSON) {
		name = json["name"].stringValue
		Id = json["_id"].stringValue
		status = json["status"].stringValue
		updatedAt = json["updatedAt"].stringValue
		isFav = json["isFav"].boolValue
		dist = Dist(json["dist"])
		totalRatingByUser = json["totalRatingByUser"].intValue
		image = json["image"].stringValue
		latitude = json["latitude"].stringValue
		address = json["address"].stringValue
		avgRating = json["avgRating"].floatValue
		createdAt = json["createdAt"].stringValue
		email = json["email"].stringValue
		storeType = json["storeType"].stringValue
		document = json["document"].stringValue
		location = Location(json["location"])
        categoryName = json["categoryName"].arrayValue.map { $0.stringValue }
		subCategoryName = json["subCategoryName"].arrayValue.map {  $0.stringValue }
		totalRating = json["totalRating"].intValue
		mobileNumber = json["mobileNumber"].stringValue
		cuisinesName = json["cuisinesName"].arrayValue.map {  $0.stringValue }
		longitude = json["longitude"].stringValue
	}

}
