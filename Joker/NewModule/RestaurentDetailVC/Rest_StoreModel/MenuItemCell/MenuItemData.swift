//
//  Data.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 07, 2020
//
import Foundation
import SwiftyJSON

struct MenuItemData {

	let cuisine: String?
	let count: Int?

	init(_ json: JSON) {
		cuisine = json["cuisine"].stringValue
		count = json["count"].intValue
	}

}
