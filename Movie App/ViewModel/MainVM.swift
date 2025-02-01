//
//  MainVM.swift
//  Movie App
//
//  Created by Hook on 31/01/2025.
//

import Foundation

class MainViewModel : ObservableObject {
    
    @Published var moviesList: [Movie] = []
    @Published var movieInfos: MovieDetails? = nil
    @Published var displaySearchResults: Bool = false
    @Published var displaySearchResultsError: Bool = false
}
