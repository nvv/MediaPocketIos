//
//  PodcastDetails.swift
//  MediaPocketIos
//
//  Created by Vlad Namashko on 27.12.2020.
//

import Foundation
import Combine
import SwiftUI
import CoreData
import URLImage

struct PodcastDetailsView: View {
    
    private let HEADER_HEIGHT: CGFloat = 320
    
    let podcast: Podcast
    
    var disposables = Set<AnyCancellable>()

    @ObservedObject var viewModel = PodcastDetailsViewModel()

    let coloredNavAppearance = UINavigationBarAppearance()
    
    @State private var scrollOffset: CGFloat = .zero
    
    @State private var logoImage: UIImage?
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(podcast: Podcast) {
        self.podcast = podcast

        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().tintColor = .clear
        UINavigationBar.appearance().backgroundColor = .clear
    }
    
    var body: some View {
      ZStack {
        scrollView
        statusBarView
      }
    }
    
    var btnBack : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
            Image("Back") // set image here
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
            }
        }
    }
    
    var logo : some View {
        GeometryReader { geometry in
            AsyncImage(
                url: URL(string: viewModel.podcastInfo?.artwork ?? podcast.image)!,
                placeholder: { Text("Loading ...") },
                logoImage: $logoImage
            ).aspectRatio(contentMode: .fill)
            .frame(width: geometry.size.width, height: geometry.size.height + (getScrollOffset(geometry) > 0 ? getScrollOffset(geometry) : 0))
            .offset(y: getScrollOffset(geometry) > 0 ? -getScrollOffset(geometry) : 0)
        }.frame(height: HEADER_HEIGHT, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
    
    var scrollView: some View {
        
            ScrollView {
                let gridItemLayout = [GridItem(.flexible())]
                
                offsetReader
                LazyVGrid(columns: gridItemLayout) {
                    logo
                    
                    if viewModel.isPodcastDataLoading {
                        PodcastEpisodeItemViewSkeleton()
                        PodcastEpisodeItemViewSkeleton()
                    }
                    
                    ForEach(viewModel.podcastItems, id: \.self) { podcast in
                        PodcastEpisodeItemView(item: podcast)
                    }
                }
            }
            .coordinateSpace(name: "frameLayer")
            .onAppear {
                viewModel.getPodcastInfo(podcast.id)
            }.edgesIgnoringSafeArea(.top)
            .onPreferenceChange(OffsetPreferenceKey.self, perform: {
                scrollOffset = $0
            })
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            
        
    }
    
    var offsetReader: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(
                    key: OffsetPreferenceKey.self,
                    value: proxy.frame(in: .named("frameLayer")).minY
                )
        }
        .frame(height: 0)
  }
    
    var statusBarView: some View {
      GeometryReader { geometry in
        ZStack {
            Color(logoImage?.averageColor ?? .blue)
                HStack {
                    Text(viewModel.podcastInfo?.artistName ?? "")
                        .lineLimit(1)
                }.padding(.top, 20)
            }
            .frame(width: geometry.frame(in: .global).width, height: geometry.safeAreaInsets.top, alignment: .center)
            .opacity(opacity(geometry.safeAreaInsets.top))
            .edgesIgnoringSafeArea(.top)
        }
    }

    func opacity(_ statusBarHeight: CGFloat) -> Double {
        let offset = -HEADER_HEIGHT + statusBarHeight
        switch scrollOffset {
          case offset...0:
            return min(Double(-scrollOffset) / Double(-offset), 0.75)
          case ...offset:
            return 0.75
          default:
            return 0
        }
    }
    
    private func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: .global).minY
    }
    
    
    
}

struct PodcastDetails_Previews: PreviewProvider {
    static var previews: some View {
        PodcastDetailsView(podcast: podcasts[0])
    }
}

