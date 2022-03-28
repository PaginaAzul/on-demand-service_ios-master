//
//  Dist.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 05, 2020
//
import Foundation
import SwiftyJSON

struct Dist {

	let calculated: Double?

	init(_ json: JSON) {
		calculated = json["calculated"].doubleValue
	}

}