//
//  OfferListModel.swift
//  Joker
//
//  Created by cst on 21/10/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import Foundation
import UIKit

struct OfferListModel{
    
    var title : String?
    var shopName : String?
    var productDetail : String?
    var price : String?
    var lastPrice : String?
    var imageProduct : String
   
}


struct MyCartModel{
    
    var productName : String?
    var productDetail : String?
    var price : String?
    var imageProduct : String
    var currency: String
    var item_type : Int
   
}

struct MyOrderModel{
    
    var productName : String?
    var productDetail : String?
    var price : String?
    var imageProduct : String
    var currency: String
    var item_type : Int
    var isSelected:Bool
}


struct myOrderBaseModel {
   
    var isSelected:Bool
    var myOrders:[MyOrderModel]
}
