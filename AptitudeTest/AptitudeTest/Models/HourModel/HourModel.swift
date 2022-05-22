//
//  HourModel.swift
//  AptitudeTest
//
//  Created by Hung Nguyen on 22/05/2022.
//

import Foundation

struct HourModel: Codable {
    var open: [OpenHourModel]?
    var hoursType: String?
    var isOpenNow: Bool?
    
    enum CodingKeys: String, CodingKey {
        case open = "open"
        case hoursType = "hours_type"
        case isOpenNow = "is_open_now"
    }
}

struct OpenHourModel: Codable {
    var isOverNight: Bool?
    var start: String?
    var end: String?
    var day: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case isOverNight = "is_overnight"
        case start = "start"
        case end = "end"
        case day = "day"
    }
}
