//
//  ResAndStoreId.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 22, 2020
//
import Foundation
import SwiftyJSON

struct ResAndStoreId {

	let avgRating: Int?
	let Id: String?
	let name: String?
	let image: String?
	let address: String?

	init(_ json: JSON) {
		avgRating = json["avgRating"].intValue
		Id = json["_id"].stringValue
		name = json["name"].stringValue
		image = json["image"].stringValue
		address = json["address"].stringValue
	}

}