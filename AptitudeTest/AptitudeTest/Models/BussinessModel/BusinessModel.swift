//
//  BusinessModel.swift
//  AptitudeTest
//
//  Created by Hung Nguyen on 21/05/2022.
//

import Foundation

struct BusinessModel: Codable {
    
    var id: String?
    var alias: String?
    var name: String?
    var imageUrl: String?
    var url: String?
    var reviewCount: Int?
    var distance: Double?
    var phone: String?
    var displayPhone: String?
    var isClosed: Bool?
    var rating: Double?
    var categories: [CategoryModel]?
    var coordinates: CoordinateModel?
    var transactions: [String]?
    var price: String?
    var location: LocationModel?
    
    var isClaimed: Bool?
    var photos: [String]?
    var hours: [HourModel]?
    var messaging: MessagingModel?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case alias = "alias"
        case name = "name"
        case imageUrl = "image_url"
        case url = "url"
        case reviewCount = "review_count"
        case distance = "distance"
        case phone = "phone"
        case displayPhone = "display_phone"
        case isClosed = "is_closed"
        case rating = "rating"
        case categories = "categories"
        case coordinates = "coordinates"
        case transactions = "transactions"
        case price = "price"
        case location = "location"
        case isClaimed = "is_claimed"
        case photos = "photos"
        case hours = "hours"
        case messaging = "messaging"
    }
    
}
