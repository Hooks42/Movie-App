//
//  MovieInfosVM.swift
//  Movie App
//
//  Created by Hook on 01/02/2025.
//

import SwiftUI

class MovieInfosViewModel : ObservableObject {
    
    @Published var viewElements : MovieDetails = MovieDetails(title: "", director: "", plot: "", poster: "")
    @Published var picture: Image? = nil
    
    func updateView (mainViewModel: MainViewModel) {
        Task {
            print("\n\n🔥movieToSearch vient de changer --> \(mainViewModel.movieToSearch)")
            self.viewElements = mainViewModel.movieInfos ?? MovieDetails(title: "N/A", director: "N/A", plot: "N/A", poster: "N/A")
            print("\n\n🌿view Elements vaut maintenant --> \(viewElements)")
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
