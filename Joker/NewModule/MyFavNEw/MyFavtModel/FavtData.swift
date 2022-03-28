//
//  Data.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 08, 2020
//
import Foundation
import SwiftyJSON

struct FavtData {

	let Id: String?
	let status: String?
	let resAndStoreId: String?
	let userId: String?
	let createdAt: String?
	let updatedAt: String?
	let sellerData: SellerFavtData?
	let distance: String?

	init(_ json: JSON) {
		Id = json["_id"].stringValue
		status = json["status"].stringValue
		resAndStoreId = json["resAndStoreId"].stringValue
		userId = json["userId"].stringValue
		createdAt = json["createdAt"].stringValue
		updatedAt = json["updatedAt"].stringValue
		sellerData = SellerFavtData(json["sellerData"])
		distance = json["distance"].stringValue
	}

}
