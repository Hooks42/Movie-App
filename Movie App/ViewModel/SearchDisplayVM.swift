//
//  SearchDisplayVM.swift
//  Movie App
//
//  Created by Hook on 01/02/2025.
//

import SwiftUI

@MainActor
// MARK: - SearchDisplayViewModel
class SearchDisplayViewModel: ObservableObject {
    
    @Published var imageTab: [(picture: Image?, id: String, title: String)] = [] // Array to hold movie images and metadata.
    
    // Animate the display of movie pictures based on the main view model's movie list.
    func animateMoviesPictures(mainViewModel: MainViewModel) {
        Task {
            for url in mainViewModel.moviesList {
                // Check if the poster URL is not available.
                if url.poster == "N/A" {
                    self.imageTab.append((picture: nil, id: url.imdbID, title: url.title)) // Add entry with nil picture.
                }
                
                // Load the image asynchronously.
                if let newImage = await loadImage(by: url.poster) {
                    // Animate the addition of the new image to the imageTab.
                    withAnimation(.easeInOut(duration: 1)) {
                        self.imageTab.append((picture: newImage, id: url.imdbID, title: url.title)) // Add entry with the loaded image.
                    }
                    
                    // Introduce a delay before loading the next image.
                    do {
                        try await Task.sleep(nanoseconds: 950_000_000) // Sleep for 950 milliseconds.
                    } catch {
                        return // Exit if there's an error during sleep.
                    }
                }
            }
        }
    }
}

