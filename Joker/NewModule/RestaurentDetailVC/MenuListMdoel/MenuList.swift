//
//  MenuList.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 07, 2020
//
import Foundation
import SwiftyJSON

struct MenuList {

	let Id: String?
	let status: String?
	let currency: String?
	let offerStatus: Bool?
	let quantity: Int?
	let avgRating: Int?
	let totalRating: Int?
	let totalOrder: Int?
	let resAndStoreId: String?
	let type: String?
	let productName: String?
	let productType: String?
	let measurement: String?
	let price: Int?
	let cuisine: String?
	let productImage: String?
	let createdAt: String?
	let updatedAt: String?
	let description: String?
	let offerEndDate: String?
	let offerEndTime: Int?
	let offerPrice: Int?
	let cartData: CartData?
    let sellerData: SellerData?

	init(_ json: JSON) {
		Id = json["_id"].stringValue
		status = json["status"].stringValue
		currency = json["currency"].stringValue
		offerStatus = json["offerStatus"].boolValue
		quantity = json["quantity"].intValue
		avgRating = json["avgRating"].intValue
		totalRating = json["totalRating"].intValue
		totalOrder = json["totalOrder"].intValue
		resAndStoreId = json["resAndStoreId"].stringValue
		type = json["type"].stringValue
		productName = json["productName"].stringValue
		productType = json["productType"].stringValue
		measurement = json["measurement"].stringValue
		price = json["price"].intValue
		cuisine = json["cuisine"].stringValue
		productImage = json["productImage"].stringValue
		createdAt = json["createdAt"].stringValue
		updatedAt = json["updatedAt"].stringValue
		description = json["description"].stringValue
		offerEndDate = json["offerEndDate"].stringValue
		offerEndTime = json["offerEndTime"].intValue
		offerPrice = json["offerPrice"].intValue
		cartData = CartData(json["cartData"])
        sellerData = SellerData(json["sellerData"])
	}

}
