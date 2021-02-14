//
//  PodcastItem.swift
//  MediaPocketIos
//
//  Created by Vlad Namashko on 02.01.2021.
//

import Foundation

struct PodcastItem: Hashable {
    
    let uuid = UUID().uuidString
    let title: String
    let pubDate: Date
    let description: String
    let duration: Int
    let summary: String
    let image: String
    let author: String
    let subtitle: String
    
    private static let remoteDateFormatter = apply(DateFormatter()) {
        $0.locale = Locale(identifier: "en_US_POSIX")
        $0.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
    }
    
    private static let currentMonthDateFormatter = apply(DateFormatter()) {
        $0.locale = Locale(identifier: "en_US_POSIX")
        $0.dateFormat = "MMM\ndd"
    }
    
    private static let regularDateFormatter = apply(DateFormatter()) {
        $0.locale = Locale(identifier: "en_US_POSIX")
        $0.dateFormat = "dd/MM\nyyyy"
    }
    
    init() {
        title = "title"
        description = "description"
        pubDate = Date()
        duration = 0
        summary = "summary"
        image = "image"
        author = "author"
        subtitle = "subtitle"
    }
    
    init(node: XmlNode) {
        title = node.getChild("title")?.value ?? ""
        description = node.getChild("description")?.value ?? ""
        duration = Int(node.getChild("itunes:duration")?.value ?? "") ?? 0
        summary = node.getChild("itunes:summary")?.value ?? ""
        image = node.getChild("itunes:image")?.attributes?["href"] ?? ""
        author = node.getChild("itunes:author")?.value ?? ""
        subtitle = node.getChild("itunes:subtitle")?.value ?? ""
        pubDate = PodcastItem.remoteDateFormatter.date(from: node.getChild("pubDate")?.value ?? "") ?? Date()
    }
    
    func getPubDateFormatted() -> String {
        return Calendar.current.isDateInThisMonth(pubDate) ?
            PodcastItem.currentMonthDateFormatter.string(from: pubDate):
            PodcastItem.regularDateFormatter.string(from: pubDate)
    }


}
