//
//  ExclusiveOfferListModel.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 05, 2020
//
import Foundation
import SwiftyJSON

struct ExclusiveOfferListModel {

	let responseMessage: String?
	let Data: [ExclusiveOffer]?
	let status: String?

	init(_ json: JSON) {
		responseMessage = json["response_message"].stringValue
		Data = json["Data"].arrayValue.map { ExclusiveOffer($0) }
		status = json["status"].stringValue
	}

}
