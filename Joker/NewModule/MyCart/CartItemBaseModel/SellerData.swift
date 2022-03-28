//
//  SellerData.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 08, 2020
//
import Foundation
import SwiftyJSON


struct SellerData {

    let offerStatus: String?
    let avgRating: Int?
    let longitude: String?
    let location: Location?
    let openingTime: String?
    let description: String?
    let address: String?
    let minimumValue: Int?
    let closingTime: String?
    let totalRatingByUser: Int?
    let subCategoryName: [Any]?
    let totalRating: Int?
    let deliveryTime: Int?
    let name: String?
    let latitude: String?
    let image: String?
    let cuisinesName: [String]?
    let email: String?
    let mobileNumber: String?
    let categoryName: [Any]?

    init(_ json: JSON) {
        offerStatus = json["offerStatus"].stringValue
        avgRating = json["avgRating"].intValue
        longitude = json["longitude"].stringValue
        location = Location(json["location"])
        openingTime = json["openingTime"].stringValue
        description = json["description"].stringValue
        address = json["address"].stringValue
        minimumValue = json["minimumValue"].intValue
        closingTime = json["closingTime"].stringValue
        totalRatingByUser = json["totalRatingByUser"].intValue
        subCategoryName = json["subCategoryName"].arrayValue.map { $0 }
        totalRating = json["totalRating"].intValue
        deliveryTime = json["deliveryTime"].intValue
        name = json["name"].stringValue
        latitude = json["latitude"].stringValue
        image = json["image"].stringValue
        cuisinesName = json["cuisinesName"].arrayValue.map { $0.stringValue }
        email = json["email"].stringValue
        mobileNumber = json["mobileNumber"].stringValue
        categoryName = json["categoryName"].arrayValue.map { $0 }
    }

}
