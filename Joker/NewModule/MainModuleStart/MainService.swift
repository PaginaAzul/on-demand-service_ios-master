//
//  MainService.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 10, 2020
//
import Foundation
import SwiftyJSON

struct MainService {

	let status: String?
	let Id: String?
	let image: String?
	let englishName: String?
	let portName: String?
	let createdAt: String?
	let updatedAt: String?
	let _v: Int?

	init(_ json: JSON) {
		status = json["status"].stringValue
		Id = json["_id"].stringValue
		image = json["image"].stringValue
		englishName = json["englishName"].stringValue
		portName = json["portName"].stringValue
		createdAt = json["createdAt"].stringValue
		updatedAt = json["updatedAt"].stringValue
		_v = json["__v"].intValue
	}

}
