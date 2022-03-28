//
//  Data.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 21, 2020
//

import Foundation
import SwiftyJSON


struct DataGetOrder {

    let orderType:String?
    let deliveryTimeSlot:String?
    let driverData: DriverData?
	let orderNumber: String?
    let ratingData:RatingData?
	let landmark: String?
	let excepetdDeliveryTime: Int?
	let userId: String?
	let deliveryDate: String?
	let Id: String?
	let quantity: Int?
	let sellerData: SellerDataGetOrder?
	let createdAt: String?
	let latitude: String?
	let longitude: String?
	let updatedAt: String?
	let orderData: [OrderData]?
	let buildingAndApart: String?
	let price: Int?
	let address: String?
	let status: String?
	let totalPrice: Int?
	let offerApplicable: Bool?
	let deliveryCharge: Int?
	let resAndStoreId: String?
    var isSelected : Bool?
    
	init(_ json: JSON) {
        
        orderType = json["orderType"].stringValue
        deliveryTimeSlot = json["deliveryTimeSlot"].stringValue
        driverData = DriverData(json["driverData"])
		orderNumber = json["orderNumber"].stringValue
		landmark = json["landmark"].stringValue
		excepetdDeliveryTime = json["excepetdDeliveryTime"].intValue
		userId = json["userId"].stringValue
		deliveryDate = json["deliveryDate"].stringValue
		Id = json["_id"].stringValue
		quantity = json["quantity"].intValue
		sellerData = SellerDataGetOrder(json["sellerData"])
        
		createdAt = json["createdAt"].stringValue
		latitude = json["latitude"].stringValue
		longitude = json["longitude"].stringValue
		updatedAt = json["updatedAt"].stringValue
		orderData = json["orderData"].arrayValue.map { OrderData($0) }
		buildingAndApart = json["buildingAndApart"].stringValue
		price = json["price"].intValue
		address = json["address"].stringValue
		status = json["status"].stringValue
		totalPrice = json["totalPrice"].intValue
		offerApplicable = json["offerApplicable"].boolValue
		deliveryCharge = json["deliveryCharge"].intValue
		resAndStoreId = json["resAndStoreId"].stringValue
        ratingData = RatingData(json["ratingData"])
        
        isSelected = false
        
	}
    
    mutating func changeIsSelected(_ isSelected:Bool) {
        self.isSelected = isSelected
    }

    
}


