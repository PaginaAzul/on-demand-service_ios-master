//
//  Data.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 05, 2020
//

import Foundation
import SwiftyJSON

struct DataDetails {

	let resAndStoreDetail: ResAndStoreDetail?
	let rating: [RatingModel]?

	init(_ json: JSON) {
		resAndStoreDetail = ResAndStoreDetail(json["resAndStoreDetail"])
        rating = json["rating"].arrayValue.map { RatingModel($0) }
        //RatingModel(json["rating"]) //  json["rating"].arrayValue.map { $0 }
	}

}
