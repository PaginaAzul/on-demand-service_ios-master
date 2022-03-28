//
//  CartData.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 07, 2020
//
import Foundation
import SwiftyJSON

struct CartData {

	let Id: String?
	let status: String?
	let quantity: Int?
	let resAndStoreId: String?
	let userId: String?
	let productId: String?
	let createdAt: String?
	let updatedAt: String?
	let _v: Int?

	init(_ json: JSON) {
		Id = json["_id"].stringValue
		status = json["status"].stringValue
		quantity = json["quantity"].intValue
		resAndStoreId = json["resAndStoreId"].stringValue
		userId = json["userId"].stringValue
		productId = json["productId"].stringValue
		createdAt = json["createdAt"].stringValue
		updatedAt = json["updatedAt"].stringValue
		_v = json["__v"].intValue
	}

}