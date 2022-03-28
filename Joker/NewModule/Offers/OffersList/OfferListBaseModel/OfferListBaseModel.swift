//
//  OfferListBaseModel.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 29, 2020
//
import Foundation
import SwiftyJSON

struct OfferListBaseModel {

	let status: String?
	let responseMessage: String?
	var Data: [DataOffer]?

	init(_ json: JSON) {
		status = json["status"].stringValue
		responseMessage = json["response_message"].stringValue
		Data = json["Data"].arrayValue.map { DataOffer($0) }
	}

}
