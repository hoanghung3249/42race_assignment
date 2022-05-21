//
//  LocationModel.swift
//  AptitudeTest
//
//  Created by Hung Nguyen on 21/05/2022.
//

import Foundation

struct LocationModel: Codable {
    var address1: String?
    var address2: String?
    var address3: String?
    var city: String?
    var zipCode: String?
    var country: String?
    var state: String?
    var displayAddress: [String]?
    
    enum CodingKeys: String, CodingKey {
        case address1 = "address1"
        case address2 = "address2"
        case address3 = "address3"
        case city = "city"
        case zipCode = "zip_code"
        case country = "country"
        case state = "state"
        case displayAddress = "display_address"
    }
    
}
