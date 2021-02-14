//
//  PodcastView.swift
//  MediaPocketIos
//
//  Created by Vlad Namashko on 25.12.2020.
//

import SwiftUI

struct PodcastView: View {
    var podcast: Podcast

    var body: some View {
        
        ZStack(alignment: .bottomLeading) {
            AsyncImage(
                url: URL(string: podcast.image)!,
                placeholder: { Text("Loading ...") }
            )
            .scaledToFit()
            
            HStack {
                Text(podcast.artistName)
                    .lineLimit(1)
                    .padding(4)
                    .foregroundColor(.black)
                Spacer()
            }.background(Color.white.opacity(0.75))
                
        }.cornerRadius(8.0)
    }
    
}

struct PodcastView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PodcastView(podcast: podcasts[0]).previewLayout(.fixed(width: 300, height: 300))
            PodcastView(podcast: podcasts[1]).previewLayout(.fixed(width: 300, height: 300))
        }
    }
}
