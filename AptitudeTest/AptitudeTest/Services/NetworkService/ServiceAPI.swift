//
//  ServiceAPI.swift
//  AptitudeTest
//
//  Created by Hung Nguyen on 21/05/2022.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

protocol APITarget {
    
    /// The target's base `URL`.
    var baseURL: URL { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }
    
    /// The HTTP method used in the request.
    var method: HTTPMethod { get }
    
    var header: [String: String] { get }
    
    var parameters: [String: String]? { get }
    
}


enum ServiceAPI {
    
    case searchWithLocation(latitude: Double, longitude: Double)
    case businessDetail(id: String)
    
}

extension ServiceAPI: APITarget {
    
    var header: [String : String] {
        return ["Authorization": Constant.apiKey]
    }
    
    
    var baseURL: URL {
        return URL(string: Constant.endpointBaseURL)!
    }
    
    var path: String {
        switch self {
        case .searchWithLocation(_, _):
            return "/businesses/search"
        case .businessDetail(let id):
            return "/businesses/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchWithLocation(_, _): return .get
        case .businessDetail(_): return .get
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case .searchWithLocation(let latitude, let longitude):
            return ["latitude": "\(latitude)", "longitude": "\(longitude)"]
        default: return nil
        }
    }
    
}
