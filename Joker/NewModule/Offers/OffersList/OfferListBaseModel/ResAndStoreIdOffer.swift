//
//  ResAndStoreId.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 29, 2020
//
import Foundation
import SwiftyJSON

struct ResAndStoreIdOffer {

	let Id: String?
	let name: String?
	let image: String?
	let address: String?
	let description: String?

	init(_ json: JSON) {
		Id = json["_id"].stringValue
		name = json["name"].stringValue
		image = json["image"].stringValue
		address = json["address"].stringValue
		description = json["description"].stringValue
	}

}
