//
//  SearchBaseModel.swift
//  Joker
//
//  Created by SinhaAirBook on 08/12/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SearchBaseModel {

    let status: String?
    let Data: HomeData?
    let responseMessage: String?

    init(_ json: JSON) {
        status = json["status"].stringValue
        Data = HomeData(json["Data"])
        responseMessage = json["response_message"].stringValue
    }

}
