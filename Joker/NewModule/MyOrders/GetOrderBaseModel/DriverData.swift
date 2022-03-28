//
//  DriverData.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 22, 2020
//
import Foundation
import SwiftyJSON

struct DriverData {

	let name: String?
	let email: String?
	let countryCode: String?
	let mobileNumber: String?

	init(_ json: JSON) {
		name = json["name"].stringValue
		email = json["email"].stringValue
		countryCode = json["countryCode"].stringValue
		mobileNumber = json["mobileNumber"].stringValue
	}

}