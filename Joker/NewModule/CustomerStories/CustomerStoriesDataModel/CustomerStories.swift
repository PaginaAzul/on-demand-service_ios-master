//
//  CustomerStories.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 22, 2020
//
import Foundation
import SwiftyJSON

struct CustomerStories {

	let status: String?
	let responseMessage: String?
	let Data: [DataStory]?

	init(_ json: JSON) {
		status = json["status"].stringValue
		responseMessage = json["response_message"].stringValue
		Data = json["Data"].arrayValue.map { DataStory($0) }
	}

}
