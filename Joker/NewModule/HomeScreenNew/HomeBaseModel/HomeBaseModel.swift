//
//  HomeBaseModel.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 05, 2020
//
import Foundation
import SwiftyJSON

struct HomeBaseModel {

	let status: String?
	let Data: HomeData?
	let responseMessage: String?

	init(_ json: JSON) {
		status = json["status"].stringValue
		Data = HomeData(json["Data"])
		responseMessage = json["response_message"].stringValue
	}

}
