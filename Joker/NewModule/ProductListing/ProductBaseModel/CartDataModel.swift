//
//  CartData.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 25, 2020
//
import Foundation
import SwiftyJSON

struct CartDataModel {

	let productId: String?
	let Id: String?
	let quantity: Int?
	let resAndStoreId: String?
	let createdAt: String?
	let status: String?
	let userId: String?
	let updatedAt: String?
	let _v: Int?

	init(_ json: JSON) {
		productId = json["productId"].stringValue
		Id = json["_id"].stringValue
		quantity = json["quantity"].intValue
		resAndStoreId = json["resAndStoreId"].stringValue
		createdAt = json["createdAt"].stringValue
		status = json["status"].stringValue
		userId = json["userId"].stringValue
		updatedAt = json["updatedAt"].stringValue
		_v = json["__v"].intValue
	}

}
