//
//  PodcastInfo.swift
//  MediaPocketIos
//
//  Created by Vlad Namashko on 27.12.2020.
//

import Foundation

struct PodcastInfo: Codable {
    let artistName: String
    let trackName: String
    let collectionName: String
    let feedUrl: String
    let country: String
    let genre: String
    let artwork: String
    
    private enum CodingKeys : String, CodingKey {
        case artistName
        case trackName
        case collectionName
        case feedUrl
        case country
        case genre = "primaryGenreName"
        case artwork = "artworkUrl600"
    }
}

struct Result: Codable {
    
    let result: PodcastInfo?
    
    init(from decoder: Decoder) throws {
        let results = try decoder.container(keyedBy: CodingKeys.self)
        result = try results.decodeIfPresent([PodcastInfo].self, forKey: .result)?[0]
    }
    
    private enum CodingKeys : String, CodingKey {
        case result = "results"
    }
}
