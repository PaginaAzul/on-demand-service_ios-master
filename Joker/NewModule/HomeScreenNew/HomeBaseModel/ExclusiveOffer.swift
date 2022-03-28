//
//  Data.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 05, 2020
//
import Foundation
import SwiftyJSON

struct ExclusiveOffer {
    
    let status: String?
    let createdAt: String?
    let resAndStoreId: String?
    let image: String?
    let Id: String?
    let updatedAt: String?
    let sellerData: sellerDataOffer?

    init(_ json: JSON) {
        status = json["status"].stringValue
        createdAt = json["createdAt"].stringValue
        resAndStoreId = json["resAndStoreId"].stringValue
        image = json["image"].stringValue
        Id = json["_id"].stringValue
        updatedAt = json["updatedAt"].stringValue
        sellerData = sellerDataOffer(json["sellerData"])
    }

}

import Foundation
import SwiftyJSON

struct sellerDataOffer {

    let avgRating: Int?
    let totalRating: Int?
    let storeType: String?
    let address: String?
    let image: String?
    let Id: String?

    init(_ json: JSON) {
        avgRating = json["avgRating"].intValue
        totalRating = json["totalRating"].intValue
        storeType = json["storeType"].stringValue
        address = json["address"].stringValue
        image = json["image"].stringValue
        Id = json["_id"].stringValue
    }

}
