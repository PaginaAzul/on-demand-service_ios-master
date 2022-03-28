//
//  DataModel.swift
//  Joker
//
//  Created by User on 03/12/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import Foundation


import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let status, responseMessage: String
    let data: [Datum]

    enum CodingKeys: String, CodingKey {
        case status
        case responseMessage = "response_message"
        case data = "Data"
    }
}

// MARK: - Datum
struct Datum: Codable {
    let status, id: String
    let image: String
    let createdAt, updatedAt: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case status
        case id = "_id"
        case image, createdAt, updatedAt
        case v = "__v"
    }
}
