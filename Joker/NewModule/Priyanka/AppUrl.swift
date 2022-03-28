//
//  AppUrl.swift
//  E-RX
//
//  Created by SinhaAirBook on 29/06/20.
//  Copyright © 2020 macbook. All rights reserved.
//

import UIKit

struct Domain {
    
    static let development = "http://3.129.47.202:3000/api/v1/user/"
    static let socketUrl = "http://3.22.227.41:2020"
    static let chatHistory = "http://3.22.227.41:2020/api/v1/user/"
    static let production = "http://3.129.47.202:3000/api/v1/user/"
    static let socketUrlProduction = "https://e-rx.cc:2021"
    
//    http://3.129.47.202:3021/api/v1/user/

}
extension Domain {
    static func baseUrl() -> String {
        return Domain.production
    }
    static func socketURL() -> String{
        return Domain.socketUrlProduction
    }
    static func chatHistoryUrl() ->String{
        return Domain.production
    }
}

struct APIEndpoint {
    
    static let ExclusiveOfferList                       = "getExclusiveOfferList"
    static let getRestaurantAndStoreData                = "getRestaurantAndStoreData"
    static let addToFavourite                           = "addToFavourite"
    static let resAndStoreDetail                        = "resAndStoreDetail"
    static let getMenuData                              = "getMenuData"
    static let addToCart                                = "addToCart"
    static let updateCart                               = "updateCart"
    static let getRestaurantMenuList                    = "getRestaurantMenuList"
    static let getRestaurantAndStoreDataForSearch       = "getRestaurantAndStoreDataForSearch"
    static let getCartItem                              = "getCartItem"
    static let getFavouriteList                         = "getFavouriteList"
    static let getDashboardData                         = "getDashboardData"
    static let getplaceOrder                            = "placeOrder"
    static let getUserOrder                             = "getUserOrder"
    static let getCartCount                             = "getCartCount"
    static let getDeliveryCharge                        = "getDeliveryCharge"
    static let getClearCart                             = "clearCart"
    static let cancelOrderByUser                        = "cancelOrderByUser"
    static let getCustomerStory                         = "getCustomerStory"
    static let updateCancelStatus                       = "updateCancelStatus"
    static let resAndStoreRating                        = "resAndStoreRating"
    static let reOrder                                  = "reOrder"
    static let getCategoryList                          = "getCategoryList"
    static let getSubCategoryList                       = "getSubCategoryList"
    static let getProductData                           = "getProductData"
    static let productDetail                            = "productDetail"
    static let getDeliverySlotList                      = "getDeliverySlotList"
    static let getOfferCategory                         = "getOfferCategory"
    static let getOfferProductList                      = "getOfferProductList"
    static let getCuisineListForUser                    = "getCuisineListForUser"

}


enum HTTPHeaderField: String {
    
    case authentication  = "Authorization"
    case contentType     = "Content-Type"
    case acceptType      = "Accept"
    case acceptEncoding  = "Accept-Encoding"
    case acceptLangauge  = "Accept-Language"
    
    var header:String{
        
        switch self {
        case .authentication:
            return "Authorization"
        case .contentType:
            return "Content-Type"
        case .acceptType:
            return "Accept"
        case .acceptEncoding:
            return "Accept-Encoding"
        case .acceptLangauge:
            return "Accept-Language"
        
        }
        
    }
    
}

enum ContentType: String {
    case json            = "application/json"
    case multipart       = "multipart/form-data"
    case ENUS            = "en-us"
}

enum MultipartType: String {
    case image = "Image"
    case csv = "CSV"
}

enum MimeType: String {
    case image = "image/png"
    case csvText = "text/csv"
}

enum UploadType: String {
    case avatar
    case file
}



