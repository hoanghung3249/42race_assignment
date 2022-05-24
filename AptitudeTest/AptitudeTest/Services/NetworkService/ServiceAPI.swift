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
    
    /// The header value for the request
    var header: [String: String] { get }
    
    // The query values for request
    var parameters: [String: String]? { get }
    
}


enum ServiceAPI {
    // Business Search
    case searchWithLocation(latitude: Double, longitude: Double)
    
    case searchBusiness(latitude: Double, longitude: Double, sortBy: String, searchBy: BusinessSearchType?, searchText: String)
    
    // Business Detail
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
        case .searchBusiness(_, _, _, _, _):
            return "/businesses/search"
        case .businessDetail(let id):
            return "/businesses/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchWithLocation(_, _): return .get
        case .businessDetail(_): return .get
        case .searchBusiness(_, _, _, _, _): return .get
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case .searchWithLocation(let latitude, let longitude):
            return ["latitude": "\(latitude)", "longitude": "\(longitude)"]
        case let .searchBusiness(latitude, longitude, sortBy, searchBy, searchText):
            if let searchBy = searchBy {
                switch searchBy {
                case .term:
                    var params = ["latitude": "\(latitude)", "longitude": "\(longitude)", "sort_by": sortBy]
                    if !searchText.isEmpty {
                        params["term"] = searchText
                    }
                    return params
                case .address:
                    var params = ["latitude": "\(latitude)", "longitude": "\(longitude)", "sort_by": sortBy]
                    if !searchText.isEmpty {
                        params["location"] = searchText
                    }
                    return params
                case .cuisine:
                    var params = ["latitude": "\(latitude)", "longitude": "\(longitude)", "sort_by": sortBy]
                    if !searchText.isEmpty {
                        params["categories"] = searchText
                    }
                    return params
                }
                
            } else {
                return ["latitude": "\(latitude)", "longitude": "\(longitude)", "sort_by": sortBy]
            }
        default: return nil
        }
    }
    
}
