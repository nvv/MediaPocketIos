//
//  Podcast.swift
//  MediaPocketIos
//
//  Created by Vlad Namashko on 25.12.2020.
//

import Foundation

struct Podcast: Hashable, Codable {
    let id: String
    let artistName: String
    let releaseDate: String
    let url: String
    let image: String
    
    private enum CodingKeys : String, CodingKey {
        case id
        case artistName
        case releaseDate
        case url
        case image = "artworkUrl100"
    }
    
}
