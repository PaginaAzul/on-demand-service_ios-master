//
//  UserData.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on January 08, 2021
//
import Foundation
import SwiftyJSON

struct UserData {

	let profilePic: String?
	let email: String?
	let name: String?

	init(_ json: JSON) {
		profilePic = json["profilePic"].stringValue
		email = json["email"].stringValue
		name = json["name"].stringValue
	}

}