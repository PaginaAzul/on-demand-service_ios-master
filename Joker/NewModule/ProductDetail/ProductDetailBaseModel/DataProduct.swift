//
//  Data.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 25, 2020
//
import Foundation
import SwiftyJSON

struct DataProduct {

	let status: String?
	let deleteStatus: Bool?
	let currency: String?
	let offerStatus: Bool?
	let quantity: Int?
	let avgRating: Int?
	let totalRating: Int?
	let totalOrder: Int?
	let Id: String?
	let resAndStoreId: ResAndStoreIdProduct?
	let productCategoryId: String?
	let type: String?
	let productName: String?
	let description: String?
	let measurement: String?
	let price: Int?
	let categoryName: String?
	let subCategoryName: String?
	let productImage: String?
	let createdAt: String?
	let updatedAt: String?
	let _v: Int?

	init(_ json: JSON) {
		status = json["status"].stringValue
		deleteStatus = json["deleteStatus"].boolValue
		currency = json["currency"].stringValue
		offerStatus = json["offerStatus"].boolValue
		quantity = json["quantity"].intValue
		avgRating = json["avgRating"].intValue
		totalRating = json["totalRating"].intValue
		totalOrder = json["totalOrder"].intValue
		Id = json["_id"].stringValue
		resAndStoreId = ResAndStoreIdProduct(json["resAndStoreId"])
		productCategoryId = json["productCategoryId"].stringValue
		type = json["type"].stringValue
		productName = json["productName"].stringValue
		description = json["description"].stringValue
		measurement = json["measurement"].stringValue
		price = json["price"].intValue
		categoryName = json["categoryName"].stringValue
		subCategoryName = json["subCategoryName"].stringValue
		productImage = json["productImage"].stringValue
		createdAt = json["createdAt"].stringValue
        
		updatedAt = json["updatedAt"].stringValue
		_v = json["__v"].intValue
	}

}
