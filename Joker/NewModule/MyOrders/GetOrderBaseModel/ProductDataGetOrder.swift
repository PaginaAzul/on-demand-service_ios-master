//
//  ProductData.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 21, 2020
//
import Foundation
import SwiftyJSON

struct ProductDataGetOrder {

	let eatType: String?
	let updatedAt: String?
	let type: String?
	let description: String?
	let productType: String?
	let price: Int?
	let totalRating: Int?
	let resAndStoreId: String?
	let productImage: String?
	let productName: String?
	let offerStatus: Bool?
	let _v: Int?
	let cuisine: String?
	let quantity: Int?
	let tasteType: String?
	let currency: String?
	let createdAt: String?
	let Id: String?
	let measurement: String?
	let status: String?
	let avgRating: Int?
	let deleteStatus: Bool?
	let totalOrder: Int?

	init(_ json: JSON) {
		eatType = json["eatType"].stringValue
		updatedAt = json["updatedAt"].stringValue
		type = json["type"].stringValue
		description = json["description"].stringValue
		productType = json["productType"].stringValue
		price = json["price"].intValue
		totalRating = json["totalRating"].intValue
		resAndStoreId = json["resAndStoreId"].stringValue
		productImage = json["productImage"].stringValue
		productName = json["productName"].stringValue
		offerStatus = json["offerStatus"].boolValue
		_v = json["__v"].intValue
		cuisine = json["cuisine"].stringValue
		quantity = json["quantity"].intValue
		tasteType = json["tasteType"].stringValue
		currency = json["currency"].stringValue
		createdAt = json["createdAt"].stringValue
		Id = json["_id"].stringValue
		measurement = json["measurement"].stringValue
		status = json["status"].stringValue
		avgRating = json["avgRating"].intValue
		deleteStatus = json["deleteStatus"].boolValue
		totalOrder = json["totalOrder"].intValue
	}

}
