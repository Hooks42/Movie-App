//
//  SearchDisplayVM.swift
//  Movie App
//
//  Created by Hook on 01/02/2025.
//

import SwiftUI

@MainActor
class SearchDisplayViewModel : ObservableObject {
    
    @Published var imageTab: [(picture: Image?, id: String, title: String)] = []
    
    func animateMoviesPictures(mainViewModel: MainViewModel) {
        Task {
            for url in mainViewModel.moviesList {
                if url.poster == "N/A" {
                    self.imageTab.append((picture: nil, id: url.imdbID, title: url.title))
                }
                if let newImage = await loadImage(by: url.poster) {
                    withAnimation(.easeInOut(duration: 1)) {
                        self.imageTab.append((picture: newImage, id: url.imdbID, title: url.title))
                    }
                    do {
                        try await Task.sleep(nanoseconds: 950_000_000)
                    } catch {
                        return
                    }
                }
            }
        }
    }
}
