//
//  OrderData.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 21, 2020
//
import Foundation
import SwiftyJSON

struct OrderData {

	let productId: String?
	let amountWithQuantuty: Int?
	let Id: String?
	let actualAmount: Int?
	let quantity: Int?
	let productData: ProductDataGetOrder?

	init(_ json: JSON) {
		productId = json["productId"].stringValue
		amountWithQuantuty = json["amountWithQuantuty"].intValue
		Id = json["_id"].stringValue
		actualAmount = json["actualAmount"].intValue
		quantity = json["quantity"].intValue
		productData = ProductDataGetOrder(json["productData"])
	}

}
