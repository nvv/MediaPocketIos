//
//  AsyncImage.swift
//  MediaPocketIos
//
//  Created by Vlad Namashko on 25.12.2020.
//

import SwiftUI

struct AsyncImage<Placeholder: View>: View {
    
    @ObservedObject
    private var loader: ImageLoader = ImageLoader()
    private let placeholder: Placeholder
    
    private var image: Binding<UIImage?>?
    
    init(url: URL, @ViewBuilder placeholder: () -> Placeholder, logoImage: Binding<UIImage?>? = nil) {
        self.placeholder = placeholder()
        image = logoImage
        loader.up(url: url, cache: Environment(\.imageCache).wrappedValue)
    }

    var body: some View {
        content
    }

    private var content: some View {
        Group {
            if loader.image != nil {
                Image(uiImage: loader.image!)
                    .resizable()
                    .onAppear {
                        self.image?.wrappedValue = loader.image
                    }
            } else {
                placeholder
            }
        }
    }
    
    
}
