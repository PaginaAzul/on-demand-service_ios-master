//
//  ProductData.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 08, 2020
//
import Foundation
import SwiftyJSON

struct ProductData {
    
	let currency: String?
	let offerStatus: Bool?
	let quantity: Int?
	let type: String?
	let productName: String?
	let productType: String?
	let measurement: String?
	let price: Int?
	let cuisine: String?
	let productImage: String?
	let description: String?
	let offerEndDate: String?
	let offerPrice: Int?
    let endDate: String?
    let oStatus: String?
    let startDate: String?
    
	init(_ json: JSON) {
		currency = json["currency"].stringValue
		offerStatus = json["offerStatus"].boolValue
		quantity = json["quantity"].intValue
		type = json["type"].stringValue
		productName = json["productName"].stringValue
		productType = json["productType"].stringValue
		measurement = json["measurement"].stringValue
		price = json["price"].intValue
		cuisine = json["cuisine"].stringValue
		productImage = json["productImage"].stringValue
		description = json["description"].stringValue
		offerEndDate = json["offerEndDate"].stringValue
		offerPrice = json["offerPrice"].intValue
        endDate = json["endDate"].stringValue
        oStatus = json["oStatus"].stringValue
        startDate = json["startDate"].stringValue
	}

}
