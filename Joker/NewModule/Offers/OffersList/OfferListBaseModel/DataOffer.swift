//
//  Data.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 29, 2020
//
import Foundation
import SwiftyJSON

var dateForSorting = String()

struct DataOffer {

    
    
	let status: String?
	let deleteStatus: Bool?
	let currency: String?
	let offerStatus: Bool?
	let quantity: Int?
	let avgRating: Int?
	let totalRating: Int?
	let totalOrder: Int?
	let oStatus: String?
	let Id: String?
	let resAndStoreId: ResAndStoreIdOffer?
	let productCategoryId: String?
	let type: String?
	let productName: String?
	let description: String?
	let measurement: String?
    let cartData: CartData

	let price: Int?
	let categoryName: String?
	let subCategoryName: String?
	let productImage: String?
	let createdAt: String?
	let updatedAt: String?
	let _v: Int?
	let endDate: String?
	let offerPrice: Int?
	let offerQuantity: Int?
	let startDate: String?
	let storeCategoryId: String?
	let storeId: String?
    let endDateForSorting:String
    var sortingDateFromFilter:String
    
	init(_ json: JSON) {
		status = json["status"].stringValue
		deleteStatus = json["deleteStatus"].boolValue
		currency = json["currency"].stringValue
		offerStatus = json["offerStatus"].boolValue
		quantity = json["quantity"].intValue
		avgRating = json["avgRating"].intValue
		totalRating = json["totalRating"].intValue
		totalOrder = json["totalOrder"].intValue
		oStatus = json["oStatus"].stringValue
		Id = json["_id"].stringValue
		resAndStoreId = ResAndStoreIdOffer(json["resAndStoreId"])
		productCategoryId = json["productCategoryId"].stringValue
		type = json["type"].stringValue
		productName = json["productName"].stringValue
		description = json["description"].stringValue
		measurement = json["measurement"].stringValue
        cartData = CartData(json["cartData"])
		price = json["price"].intValue
		categoryName = json["categoryName"].stringValue
		subCategoryName = json["subCategoryName"].stringValue
		productImage = json["productImage"].stringValue
		createdAt = json["createdAt"].stringValue
		updatedAt = json["updatedAt"].stringValue
		_v = json["__v"].intValue
		endDate = json["endDate"].stringValue
		offerPrice = json["offerPrice"].intValue
		offerQuantity = json["offerQuantity"].intValue
		startDate = json["startDate"].stringValue
		storeCategoryId = json["storeCategoryId"].stringValue
		storeId = json["storeId"].stringValue
        
        endDateForSorting = dateTimeConversion(createdAt: endDate ?? "")
        print("endDateForSorting On Offer",endDateForSorting)
        sortingDateFromFilter = dateForSorting
	}
   
    mutating func changeDate(_ date:String){
        sortingDateFromFilter = date
    }
    
}


