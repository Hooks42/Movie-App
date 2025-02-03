//
//  MovieInfosVM.swift
//  Movie App
//
//  Created by Hook on 01/02/2025.
//

import SwiftUI

@MainActor
// MARK: - MovieInfosViewModel
class MovieInfosViewModel: ObservableObject {
    
    @Published var viewElements: MovieDetails = MovieDetails(title: "", director: "", plot: "", poster: "") // Movie details for the view
    @Published var picture: Image? = nil // Image of the movie poster
    
    // Update the view with movie details from the main view model.
    func updateView(mainViewModel: MainViewModel) {
        Task {
            // Set view elements to the movie details or default values if nil.
            self.viewElements = mainViewModel.movieInfos ?? MovieDetails(title: "N/A", director: "N/A", plot: "N/A", poster: "N/A")
            
            // Check if the poster is available.
            if viewElements.poster == "N/A" {
                self.picture = nil // No image if poster is not available
                return
            }
            
            // Load the image asynchronously.
            if let newImage = await loadImage(by: self.viewElements.poster) {
                self.picture = newImage // Set the loaded image
            }
        }
    }
}
