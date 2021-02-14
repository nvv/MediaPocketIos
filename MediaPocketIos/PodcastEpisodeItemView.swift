//
//  PodcastEpisodeItem.swift
//  MediaPocketIos
//
//  Created by Vlad Namashko on 02.01.2021.
//

import SwiftUI

struct PodcastEpisodeItemView: View {
    var item: PodcastItem

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.white)
                .shadow(radius: 4)
            
            VStack {
                HStack {
                    Text(item.getPubDateFormatted())
                        .font(.system(size: 14))
                        .foregroundColor(Color.gray)
                    
                    VStack(alignment: .leading) {
                        Text(item.title)
                            .lineLimit(1)
                            .font(.system(size: 14))
                        Text(item.summary)
                            .lineLimit(2)
                            .font(.system(size: 12))
                            .foregroundColor(Color.gray)
                    }
                    
                    Spacer()
                }
                HStack {
                    Image("Download")
                    Spacer()
                    Image("Star")
                    Spacer()
                    Image("Share")
                    Spacer()
                    Image("DotMenu")
                }
                .padding(.leading, 16)
                .padding(.trailing, 16)
            }
            .padding(12)
        }
    }    
    
}

struct PodcastEpisodeItemViewSkeleton: View {
    var body: some View {
        VStack {
            HStack {
            
                ShimmerView()
                    .frame(width: 30, height: 30, alignment: .center)
             
                VStack {
                    ShimmerView()
                        .frame(height: 16)
                    
                    ShimmerView()
                        .frame(height: 30)
                }
            }
            ShimmerView()
                .frame(height: 16)
        }
        .frame(height: 80)
        .padding(16)
    }
}

struct PodcastEpisodeItem_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PodcastEpisodeItemView(item: PodcastItem())
        }
    }
}
