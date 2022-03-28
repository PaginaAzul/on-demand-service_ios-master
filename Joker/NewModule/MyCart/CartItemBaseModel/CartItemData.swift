//
//  Data.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 08, 2020
//
import Foundation
import SwiftyJSON

struct CartItemData {

	let Id: String?
	let status: String?
	let quantity: Int?
	let resAndStoreId: String?
	let userId: String?
	let productId: String?
	let createdAt: String?
	let updatedAt: String?
	let sellerData: SellerData?
	let productData: ProductData?

	init(_ json: JSON) {
		Id = json["_id"].stringValue
		status = json["status"].stringValue
		quantity = json["quantity"].intValue
		resAndStoreId = json["resAndStoreId"].stringValue
		userId = json["userId"].stringValue
		productId = json["productId"].stringValue
		createdAt = json["createdAt"].stringValue
		updatedAt = json["updatedAt"].stringValue
		sellerData = SellerData(json["sellerData"])
		productData = ProductData(json["productData"])
	}

}
