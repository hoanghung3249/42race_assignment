//
//  MessagingModel.swift
//  AptitudeTest
//
//  Created by Hung Nguyen on 22/05/2022.
//

import Foundation

struct MessagingModel: Codable {
    var url: String?
    var useCaseText: String?
    
    enum CodingKeys: String, CodingKey {
        case url = "url"
        case useCaseText = "use_case_text"
    }
}
