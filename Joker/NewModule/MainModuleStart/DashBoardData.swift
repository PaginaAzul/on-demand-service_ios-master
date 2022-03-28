//
//  Data.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 10, 2020
//
import Foundation
import SwiftyJSON

struct DashBoardData {

	let homeBanner: HomeBanner?
	let mainService: [MainService]?

	init(_ json: JSON) {
		homeBanner = HomeBanner(json["homeBanner"])
		mainService = json["mainService"].arrayValue.map { MainService($0) }
	}

}
