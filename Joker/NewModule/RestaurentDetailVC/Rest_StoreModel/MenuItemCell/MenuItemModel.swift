//
//  MenuItemModel.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 07, 2020
//
import Foundation
import SwiftyJSON

struct MenuItemModel {

	let status: String?
	let responseMessage: String?
	let Data: [MenuItemData]?

	init(_ json: JSON) {
		status = json["status"].stringValue
		responseMessage = json["response_message"].stringValue
		Data = json["Data"].arrayValue.map { MenuItemData($0) }
	}

}
