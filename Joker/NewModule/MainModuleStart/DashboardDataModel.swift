//
//  DashboardDataModel.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 10, 2020
//
import Foundation
import SwiftyJSON

struct DashboardDataModel {

	let status: String?
	let responseMessage: String?
	let Data: DashBoardData?

	init(_ json: JSON) {
		status = json["status"].stringValue
		responseMessage = json["response_message"].stringValue
		Data = DashBoardData(json["Data"])
	}

}
