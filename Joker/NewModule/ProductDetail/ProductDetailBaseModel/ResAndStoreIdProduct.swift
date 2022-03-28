//
//  ResAndStoreId.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 25, 2020
//
import Foundation
import SwiftyJSON

struct ResAndStoreIdProduct {

	let Id: String?
	let name: String?
	let image: String?
	let address: String?

	init(_ json: JSON) {
		Id = json["_id"].stringValue
		name = json["name"].stringValue
		image = json["image"].stringValue
		address = json["address"].stringValue
	}

}
