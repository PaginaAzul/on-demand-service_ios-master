//
//  ResAndStoreDetail.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 05, 2020
//
import Foundation
import SwiftyJSON

struct ResAndStoreDetail {

	let Id: String?
	let status: String?
	let adminVerifyStatus: String?
	let totalRating: Int?
	let avgRating: Float?
	let totalRatingByUser: Int?
	let emailVerificationStatus: Bool?
	let notificationStatus: Bool?
	let cuisinesName: [String]?
	let categoryName: [String]?
	let subCategoryName: [Any]?
	let deleteStatus: Bool?
	let name: String?
	let image: String?
	let document: String?
	let email: String?
	let mobileNumber: String?
	let address: String?
	let storeType: String?
	let longitude: String?
	let latitude: String?
	let cuisines: [Any]?
	let categoryIds: [Any]?
	let subCategoryId: [Any]?
	let createdAt: String?
	let updatedAt: String?
	let _v: Int?
	let jwtToken: String?
    let deliveryTime: String?
    let closingTime: String?
    let minimumValue: Int?
    let openingTime: String?
    let description: String?
    let isFav: Bool?
    let currency:String?
    
	init(_ json: JSON) {
        isFav = json["isFav"].boolValue
		Id = json["_id"].stringValue
		status = json["status"].stringValue
		adminVerifyStatus = json["adminVerifyStatus"].stringValue
		totalRating = json["totalRating"].intValue
		avgRating = json["avgRating"].floatValue
		totalRatingByUser = json["totalRatingByUser"].intValue
		emailVerificationStatus = json["emailVerificationStatus"].boolValue
		notificationStatus = json["notificationStatus"].boolValue
        cuisinesName = json["cuisinesName"].arrayValue.map { $0.stringValue }
		categoryName = json["categoryName"].arrayValue.map { $0.stringValue }
		subCategoryName = json["subCategoryName"].arrayValue.map { $0 }
		deleteStatus = json["deleteStatus"].boolValue
		name = json["name"].stringValue
		image = json["image"].stringValue
		document = json["document"].stringValue
		email = json["email"].stringValue
		mobileNumber = json["mobileNumber"].stringValue
		address = json["address"].stringValue
		storeType = json["storeType"].stringValue
		longitude = json["longitude"].stringValue
		latitude = json["latitude"].stringValue
		cuisines = json["cuisines"].arrayValue.map { $0 }
		categoryIds = json["categoryIds"].arrayValue.map { $0 }
		subCategoryId = json["subCategoryId"].arrayValue.map { $0 }
		createdAt = json["createdAt"].stringValue
		updatedAt = json["updatedAt"].stringValue
		_v = json["__v"].intValue
		jwtToken = json["jwtToken"].stringValue
        deliveryTime = (json["deliveryTime"].intValue).description
        closingTime = json["closingTime"].stringValue
        minimumValue = json["minimumValue"].intValue
        openingTime = json["openingTime"].stringValue
        description = json["description"].stringValue
        currency = json["currency"].stringValue
	}

}
