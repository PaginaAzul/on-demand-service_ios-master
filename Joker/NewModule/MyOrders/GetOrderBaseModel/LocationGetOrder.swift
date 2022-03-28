//
//  Location.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 21, 2020
//
import Foundation
import SwiftyJSON

struct LocationGetOrder {

	let coordinates: [Double]?
	let type: String?

	init(_ json: JSON) {
		coordinates = json["coordinates"].arrayValue.map { $0.doubleValue }
		type = json["type"].stringValue
	}

}
