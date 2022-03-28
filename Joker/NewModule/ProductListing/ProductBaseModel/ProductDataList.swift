//
//  Data.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 24, 2020
//
import Foundation
import SwiftyJSON

struct ProductDataList {

	let productList: [ProductList]?

	init(_ json: JSON) {
		productList = json["productList"].arrayValue.map { ProductList($0) }
        print("productList............\(productList)")
	}

}

import Foundation
import SwiftyJSON

struct RestaurantDataList {

    let restaurantList: [NewRestaurantList]?

    init(_ json: JSON) {
        restaurantList = json["menuList"].arrayValue.map { NewRestaurantList($0) }
    }

}
