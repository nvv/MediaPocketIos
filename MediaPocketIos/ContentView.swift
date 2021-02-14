//
//  ContentView.swift
//  MediaPocketIos
//
//  Created by Vlad Namashko on 24.12.2020.
//

import SwiftUI

struct ContentView: View {
    let podcasts: [Podcast] = load("data.json")
    
    var body: some View {
        let podcasts: [Podcast] = load("data.json")
        let gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
        
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridItemLayout) {
                    ForEach(podcasts, id: \.self) { podcast in
                        NavigationLink(destination: PodcastDetailsView(podcast: podcast)) {
                            PodcastView(podcast: podcast)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .padding(8)
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
