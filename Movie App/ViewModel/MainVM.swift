//
//  MainVM.swift
//  Movie App
//
//  Created by Hook on 31/01/2025.
//

import SwiftUI
import Combine

// MARK: - MainViewModel
class MainViewModel: ObservableObject {
    
    @Published var moviesList: [Movie] = []               // List of movies
    @Published var movieInfos: MovieDetails?               // Details of a selected movie
    @Published var errorMessage: String?                    // Error message for API calls
    @Published var displaySearchResults: Bool = false       // Controls search results display
    @Published var displaySearchResultsError: Bool = false  // Controls search results error display
    @Published var movieToSearch: String = ""               // Movie title to search
    @Published var showInfosView: Bool = false              // Controls info view display
    
    @Published var startApp = false                         // Indicates if the app has started
    @Published var searchBarY: CGFloat = 0.06               // Y position of the search bar
    
    @Published var isConnected: Bool = false                 // Connection status
    
    private var cancellables = Set<AnyCancellable>()        // Store cancellables for Combine
    private let baseURL: String = "https://www.omdbapi.com/" // Base URL for API requests
    
    // Fetch movie details from the API using the movie ID.
    func fetchMovieInfos(by id: String) -> AnyPublisher<MovieDetails, Error> {
        do {
            // Load the API key from the environment variables.
            let apiKey = try EnvLoader().load()["API_KEY"] ?? ""
            if apiKey.isEmpty {
                return Empty().eraseToAnyPublisher()
            }
            // Create the API request URL.
            let urlString = "\(self.baseURL)?i=\(id)&apikey=\(apiKey)"
            let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            // Create a publisher to fetch the data from the URL.
            return URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data } // Extract the data from the response
                .decode(type: MovieDetails.self, decoder: JSONDecoder()) // Decode JSON to MovieDetails
                .receive(on: DispatchQueue.main) // Update UI on the main thread
                .eraseToAnyPublisher() // Hide publisher implementation details
        } catch {
            print("Error loading API key: \(error)")
        }
        
        // Return an empty publisher if there was an error.
        return Empty().eraseToAnyPublisher()
    }
    
    // Search for movie information from the API.
    func searchMovieInfosFromApi() {
        DispatchQueue.main.async {
            self.movieInfos = nil
            self.errorMessage = nil
        }
        
        // Fetch the movie data from the API.
        fetchMovieInfos(by: self.movieToSearch)
            .sink(receiveCompletion: { [weak self] receiveCompletion in
                switch receiveCompletion {
                case .failure(let error): // Handle error
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] receivedMovies in
                // Save the result
                self?.movieInfos = receivedMovies
            })
            // Store cancellable to free memory later
            .store(in: &cancellables)
    }
    
    // Handle login animation.
    func logInAnimation() {
        if self.isConnected {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation(.easeInOut(duration: 1.5)) {
                    self.startApp = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.easeInOut(duration: 1.5)) {
                    self.searchBarY = 0
                }
            }
        }
    }
}
