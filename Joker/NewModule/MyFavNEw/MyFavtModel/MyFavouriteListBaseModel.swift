//
//  MyFavouriteListBaseModel.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 08, 2020
//
import Foundation
import SwiftyJSON

struct MyFavouriteListBaseModel {

	let status: String?
	let responseMessage: String?
	var Data: [FavtData]?

	init(_ json: JSON) {
		status = json["status"].stringValue
		responseMessage = json["response_message"].stringValue
		Data = json["Data"].arrayValue.map { FavtData($0) }
	}

}
