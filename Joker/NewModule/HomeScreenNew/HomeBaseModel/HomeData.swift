//
//  Data.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 05, 2020
//
import Foundation
import SwiftyJSON

struct HomeData {

	let restaurantList: [RestaurantList]?
	let storeList: [StoreList]?

	init(_ json: JSON) {
		restaurantList = json["restaurantList"].arrayValue.map { RestaurantList($0) }
		storeList = json["storeList"].arrayValue.map { StoreList($0) }
	}

}
