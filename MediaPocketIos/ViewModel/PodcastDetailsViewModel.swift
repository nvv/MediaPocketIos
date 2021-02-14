//
//  PodcastDetailsViewModel.swift
//  MediaPocketIos
//
//  Created by Vlad Namashko on 27.12.2020.
//

import Foundation
import Combine

class PodcastDetailsViewModel: ObservableObject {

    @Published var podcastInfo: PodcastInfo?
    @Published var podcastItems: [PodcastItem] = []
    @Published var isPodcastDataLoading = false
    
    var disposables = Set<AnyCancellable>()
    
    func getPodcastInfo(_ id: String) {
        isPodcastDataLoading = true
        ItunesApi.request(APIPath.lookup, id)
            .mapError({ (error) -> Error in
                print(error)
                return error
            })
            .receive(on: DispatchQueue.main)
            .flatMap({ (info) -> AnyPublisher<XmlNode, Error> in
                self.podcastInfo = info
                return ItunesApi.fetchFeed(info.feedUrl)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                    let nodes = value.getChild("channel")?.getChildren("item")
                    let items = nodes?.map { PodcastItem(node: $0) } ?? []
                    self.podcastItems = items
                    self.isPodcastDataLoading = false
            })
            .store(in: &disposables)

        
    }
    
}
