//
//  ProductBaseModel.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 24, 2020
//
import Foundation
import SwiftyJSON

struct ProductBaseModel {

	let status: String?
	let responseMessage: String?
	let Data: ProductDataList?

	init(_ json: JSON) {
		status = json["status"].stringValue
		responseMessage = json["response_message"].stringValue
		Data = ProductDataList(json["Data"])
	}

}

import Foundation
import SwiftyJSON

struct RestaurantBaseModel {

    let status: String?
    let Data: RestaurantDataList?
    let responseMessage: String?

    init(_ json: JSON) {
        status = json["status"].stringValue
        Data = RestaurantDataList(json["Data"])
        responseMessage = json["response_message"].stringValue
    }

}
