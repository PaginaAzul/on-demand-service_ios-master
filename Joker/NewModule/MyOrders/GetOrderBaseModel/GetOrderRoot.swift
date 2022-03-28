//
//  GetOrderRoot.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 21, 2020
//
import Foundation
import SwiftyJSON

struct GetOrderRoot {

	let status: String?
    var Data: [DataGetOrder]?
	let responseMessage: String?

	init(_ json: JSON) {
		status = json["status"].stringValue
		Data = json["Data"].arrayValue.map { DataGetOrder($0) }
		responseMessage = json["response_message"].stringValue
	}

}
