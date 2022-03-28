//
//  Data.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 07, 2020
//
import Foundation
import SwiftyJSON

struct MenuData {

	let menuList: [MenuList]?

	init(_ json: JSON) {
		menuList = json["menuList"].arrayValue.map { MenuList($0) }
	}

}
