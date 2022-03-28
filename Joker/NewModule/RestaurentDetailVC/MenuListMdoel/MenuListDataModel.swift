//
//  MenuListDataModel.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 07, 2020
//
import Foundation
import SwiftyJSON

struct MenuListDataModel {

	let status: String?
	let responseMessage: String?
	let Data: MenuData?

	init(_ json: JSON) {
		status = json["status"].stringValue
		responseMessage = json["response_message"].stringValue
		Data = MenuData(json["Data"])
	}

}
