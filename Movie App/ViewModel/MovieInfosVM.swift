//
//  MovieInfosVM.swift
//  Movie App
//
//  Created by Hook on 01/02/2025.
//

import SwiftUI

@MainActor
class MovieInfosViewModel : ObservableObject {
    
    @Published var viewElements : MovieDetails = MovieDetails(title: "", director: "", plot: "", poster: "")
    @Published var picture: Image? = nil
    
    func updateView (mainViewModel: MainViewModel) {
        Task {
            self.viewElements = mainViewModel.movieInfos ?? MovieDetails(title: "N/A", director: "N/A", plot: "N/A", poster: "N/A")
            if viewElements.poster == "N/A" {
                self.picture = nil
                return
            }
            if let newImage = await loadImage(by: self.viewElements.poster) {
                self.picture = newImage
            }
        }
    }
    
    
}
