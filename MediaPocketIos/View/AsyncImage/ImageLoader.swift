//
//  ImageLoader.swift
//  MediaPocketIos
//
//  Created by Vlad Namashko on 25.12.2020.
//

import SwiftUI
import Combine
import Foundation

class ImageLoader: ObservableObject {

    @Published var image: UIImage?
    private var cancellable: AnyCancellable?
    private var curUrl: URL?
    private var cache: ImageCache?
    
    init(url: URL?, cache: ImageCache? = nil) {
        self.curUrl = url
        self.cache = cache
        load()
    }
    
    init() {
    }
    
    func up(url: URL, cache: ImageCache? = nil) {
        if (url == curUrl) {
            return
        }
        
        self.curUrl = url
        self.cache = cache
        load()
    }
    
    deinit {
        cancel()
    }
    
    func load() {
        cancel()
        
        if let image = cache?[curUrl!] {
            self.image = image
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: curUrl!)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(receiveOutput: { [weak self] in self?.cache($0) })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func cache(_ image: UIImage?) {
        image.map { cache?[curUrl!] = $0 }
    }

}
