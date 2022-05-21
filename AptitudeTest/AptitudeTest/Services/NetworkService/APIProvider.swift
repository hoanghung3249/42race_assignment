//
//  APIProvider.swift
//  AptitudeTest
//
//  Created by Hung Nguyen on 21/05/2022.
//

import Foundation

typealias ResponseHandler<T> = ((Result<T, Error>) -> Void)?

final class APIProvider {
    static let shared = APIProvider()
    
    private var session: URLSession?
    
    private init() {
        session = URLSession(configuration: .default)
    }
    
    /// Request to the server
    /// - Parameters:
    ///   - target: The ServiceAPI
    ///   - mapObject: The object type
    ///   - completion: Return the Result
    func request<ResponseModel: Codable>(_ target: ServiceAPI, mapObject: ResponseModel.Type, completion: ResponseHandler<ResponseModel>) {
        
        var url = target.baseURL.appendingPathComponent(target.path)
        
        let param = target.parameters ?? [:]
        // Adding query values
        for (key,value) in param {
            url = url.appending(key, value: value)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = target.method.rawValue
        // Adding header values
        for (key, value) in target.header {
            request.addValue("Bearer \(value)", forHTTPHeaderField: key)
        }
        
        session?.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion?(.failure(error))
            }
            if let data = data {
                do {
//                    let jsonString = String(data: data, encoding: .utf8)
//                    print("Data String: \(jsonString)")
                    let resultObject = try JSONDecoder().decode(mapObject, from: data)
                    completion?(.success(resultObject))
                } catch let err {
                    completion?(.failure(err))
                }
            }
        })
        .resume()
    }
}


extension URL {
    
    func appending(_ queryItem: String, value: String?) -> URL {
        
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        
        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        
        // Create query item
        let queryItem = URLQueryItem(name: queryItem, value: value)
        
        // Append the new query item in the existing query items array
        queryItems.append(queryItem)
        
        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems
        
        // Returns the url from new url components
        return urlComponents.url!
    }
}
