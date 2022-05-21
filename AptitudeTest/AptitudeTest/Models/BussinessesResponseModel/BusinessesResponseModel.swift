//
//  BusinessesResponseModel.swift
//  AptitudeTest
//
//  Created by Hung Nguyen on 21/05/2022.
//

import Foundation

struct BusinessesResponseModel: Codable {
    var total: Int
    var region: Region
    var businesses: [BusinessModel]
}

struct Region: Codable {
    var center: RegionCenter
}

struct RegionCenter: Codable {
    var latitude: Double
    var longitude: Double
}
