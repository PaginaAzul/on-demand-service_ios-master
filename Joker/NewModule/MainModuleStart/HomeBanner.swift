//
//  HomeBanner.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 10, 2020
//
import Foundation
import SwiftyJSON

struct HomeBanner {

	let status: String?
	let Id: String?
	let image: String?
	let createdAt: String?
	let updatedAt: String?
	let _v: Int?

	init(_ json: JSON) {
		status = json["status"].stringValue
		Id = json["_id"].stringValue
		image = json["image"].stringValue
		createdAt = json["createdAt"].stringValue
		updatedAt = json["updatedAt"].stringValue
		_v = json["__v"].intValue
	}

}
