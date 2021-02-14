//
//  NetworkAPI.swift
//  MediaPocketIos
//
//  Created by Vlad Namashko on 27.12.2020.
//

import Foundation
import Combine

class NetworkAPI {
    
    // MARK: - for each endpoind of backend
    case podcasts(queryParas: [String:String]?, bodyParas: [String:String]?)
    
    // MARK: - base URL
    var baseURL: String {
        switch self {
        default:
            return "https://itunes.apple.com"
        }
    }
    
    // MARK: - Request Method
    var method: RequestMethod {
        switch self {
        case .podcasts( _, _):
            return .get
        }
    }
    
    // MARK: - path string
    var path: String {
        switch self {
        case .podcasts( _, _):
            return "/search"
        }
    }
    
    // MARK: - query parameters like ...?key=value
    var queryItems: [URLQueryItem]? {
        switch self {
        case .podcasts(let queryParas, _):
            if let query = queryParas {
                return query.map({
                    URLQueryItem(name: $0.key, value: $0.value)
                })
            } else {
                return nil
            }
        }
    }
    
    // MARK: - body parameters
    var bodyParameters: [String:String]? {
        switch self {
        case .podcasts( _, let bodyParas):
            return bodyParas
        }
    }
    
    // MARK: - URLRequest creating
    func makeURLRequest() throws -> URLRequest {
        
        let fullPath = baseURL + path
        guard var urlComponent = URLComponents(string: fullPath) else { throw NetworkRequestError.invalidURL(description: "Wrong URL: \(fullPath)") }
        
        if let query = queryItems {
            urlComponent.queryItems = query
        }
        
        guard let url = urlComponent.url else { throw NetworkRequestError.invalidURL(description: "Wrong URL: \(fullPath)") }
        var urlRequest = URLRequest(url: url)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Headers
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // body parameters
        if let body = bodyParameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch let error {
                throw NetworkRequestError.bodyToJSON(description: "Body serialization error: \(error.localizedDescription)")
            }
        }
        return urlRequest
    }
    
    // MARK: - network by urlsession (Combine framework)
    func fetchData<T>(request: URLRequest) -> AnyPublisher<T, NetworkRequestError> where T: Decodable {
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { error in
                NetworkRequestError.netConnection(description: error.localizedDescription)
            }
            .flatMap(maxPublishers: .max(1)) { response in
                decode(response.data)
            }
            .eraseToAnyPublisher()
    }
    
    private func decode<T>(_ data: Data) -> AnyPublisher<T, NetworkRequestError> where T: Decodable {
        let decoder = JSONDecoder()
        return Just(data)
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                NetworkRequestError.parsingResponseData(description: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    
    enum RequestMethod: String {
        case get    = "GET"
        case post   = "POST"
    }
}

