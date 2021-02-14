//
//  ItunesApi.swift
//  MediaPocketIos
//
//  Created by Vlad Namashko on 27.12.2020.
//

import Foundation
import Combine

enum ItunesApi {
    static let apiClient = ApiClient()
    static let baseUrl = URL(string: "https://itunes.apple.com/")!
}

enum APIPath: String {
    case lookup = "lookup"
}

extension ItunesApi {
    
    static func request(_ path: APIPath, _ id: String) -> AnyPublisher<PodcastInfo, Error> {
        
        guard var components = URLComponents(url: baseUrl.appendingPathComponent(path.rawValue), resolvingAgainstBaseURL: true)
            else { fatalError("Couldn't create URLComponents") }
        components.queryItems = [URLQueryItem(name: "id", value: id)]
        
        var request = URLRequest(url: components.url!)
        
        return apiClient.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    static func fetchFeed(_ path: String) -> AnyPublisher<XmlNode, Error> {
        
        guard var components = URLComponents(url: URL(string: path)!, resolvingAgainstBaseURL: true)
            else { fatalError("Couldn't create URLComponents") }
        
        return URLSession.shared
            .dataTaskPublisher(for: URLRequest(url: components.url!))
            .tryMap { result -> XmlNode in
                return XmlParser().parse(xml: result.data)!
            }
            .eraseToAnyPublisher()
        
    }
}
