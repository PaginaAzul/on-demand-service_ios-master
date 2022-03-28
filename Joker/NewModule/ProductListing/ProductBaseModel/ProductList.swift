//
//  ProductList.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 24, 2020
//
import Foundation
import SwiftyJSON

struct ProductList {
    
    let offerPrice:Int?
	let Id: String?
	let status: String?
	let currency: String?
	let offerStatus: Bool?
	let quantity: Int?
	let avgRating: Int?
	let totalRating: Int?
	let totalOrder: Int?
	let resAndStoreId: String?
	let type: String?
	let productName: String?
	let description: String?
	let measurement: String?
	let price: Int?
	let categoryName: String?
	let subCategoryName: String?
	let productImage: String?
	let createdAt: String?
	let updatedAt: String?
    let cartData: CartDataModel?
    let endDate : String?
    let startDate : String?
    let oStatus : String?
    let sellerData : NewSellerData?
    
	init(_ json: JSON) {
        
        offerPrice = json["offerPrice"].intValue
		Id = json["_id"].stringValue
		status = json["status"].stringValue
		currency = json["currency"].stringValue
		offerStatus = json["offerStatus"].boolValue
		quantity = json["quantity"].intValue
		avgRating = json["avgRating"].intValue
		totalRating = json["totalRating"].intValue
		totalOrder = json["totalOrder"].intValue
		resAndStoreId = json["resAndStoreId"].stringValue
		type = json["type"].stringValue
		productName = json["productName"].stringValue
		description = json["description"].stringValue
		measurement = json["measurement"].stringValue
		price = json["price"].intValue
		categoryName = json["categoryName"].stringValue
		subCategoryName = json["subCategoryName"].stringValue
		productImage = json["productImage"].stringValue
		createdAt = json["createdAt"].stringValue
		updatedAt = json["updatedAt"].stringValue
        cartData = CartDataModel(json["cartData"])
        endDate = json["endDate"].stringValue
        startDate = json["startDate"].stringValue
        oStatus = json["oStatus"].stringValue
        sellerData = NewSellerData(json["sellerData"])
        
	}
    
}


//
//  RestaurantList.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on June 10, 2021
//
import Foundation
import SwiftyJSON

struct NewRestaurantList {

    let productName: String?
    let createdAt: String?
    let productImage: String?
    let totalOrder: Int?
    let quantity: Int?
    let price: Int?
    let cuisine: String?
    let cartData: CartData?
    let updatedAt: String?
    let sellerData: NewSellerData?
    let status: String?
    let oStatus: String?
    let offerPrice: Int?
    let Id: String?
    let resAndStoreId: String?
    let measurement: String?
    let type: String?
    let avgRating: Int?
    let currency: String?
    let endDate: String?
    let productType: String?
    let startDate: String?
    let offerStatus: Bool?
    let totalRating: Int?
    let description: String?

    init(_ json: JSON) {
        productName = json["productName"].stringValue
        createdAt = json["createdAt"].stringValue
        productImage = json["productImage"].stringValue
        totalOrder = json["totalOrder"].intValue
        quantity = json["quantity"].intValue
        price = json["price"].intValue
        cuisine = json["cuisine"].stringValue
        cartData = CartData(json["cartData"])
        updatedAt = json["updatedAt"].stringValue
        sellerData = NewSellerData(json["sellerData"])
        status = json["status"].stringValue
        oStatus = json["oStatus"].stringValue
        offerPrice = json["offerPrice"].intValue
        Id = json["_id"].stringValue
        resAndStoreId = json["resAndStoreId"].stringValue
        measurement = json["measurement"].stringValue
        type = json["type"].stringValue
        avgRating = json["avgRating"].intValue
        currency = json["currency"].stringValue
        endDate = json["endDate"].stringValue
        productType = json["productType"].stringValue
        startDate = json["startDate"].stringValue
        offerStatus = json["offerStatus"].boolValue
        totalRating = json["totalRating"].intValue
        description = json["description"].stringValue
    }

}





import Foundation
import SwiftyJSON

struct NewSellerData {

    let offerStatus: String?

    init(_ json: JSON) {
        offerStatus = json["offerStatus"].stringValue
    }

}
