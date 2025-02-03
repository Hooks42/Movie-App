//
//  SearchBarVM.swift
//  Movie App
//
//  Created by Hook on 30/01/2025.
//

import SwiftUI
import Combine

// MARK: - UIApplication Extension
// Extension to hide the keyboard.
extension UIApplication {
    // Ends editing for the current application, effectively dismissing the keyboard.
    // Parameter force: A Boolean indicating whether to force the end of editing.
    func endEditing(_ force: Bool) {
        self.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - SearchBarViewModel
// ViewModel for managing the search bar's state and logic.
class SearchBarViewModel: ObservableObject {
    
    @Published var searchText: String = "" // Text entered in the search bar.
    @Published var movies: [Movie] = [] // Fetched movie list.
    @Published var errorMessage: String? // Error message for API request failures.
    
    private var cancellables = Set<AnyCancellable>() // Stores subscriptions to publishers.
    private let baseURL: String = "https://www.omdbapi.com/" // Base URL for API requests.
    
    // Frame size for the text field relative to the parent view.
    let textFieldFrameX: CGFloat = 0.6
    let textFieldFrameY: CGFloat = 0.065
    
    // Fetch movie data from the API using the movie title.
    func fetchMovie(by title: String) -> AnyPublisher<MovieSearch, Error> {
        do {
            // Load the API key from environment variables.
            let apiKey = try EnvLoader().load()["API_KEY"] ?? ""
            if apiKey.isEmpty {
                return Empty().eraseToAnyPublisher() // Return empty if no API key.
            }
            // Create the API request URL.
            let urlString = "\(self.baseURL)?s=\(title)&apikey=\(apiKey)"
            let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            // Create a publisher to fetch data from the URL.
            return URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data } // Extract data from the response.
                .decode(type: MovieSearch.self, decoder: JSONDecoder()) // Decode JSON to MovieSearch.
                .receive(on: DispatchQueue.main) // Update UI on the main thread.
                .eraseToAnyPublisher() // Hide publisher implementation details.
        } catch {
            print("Error loading API key: \(error)")
        }
        
        return Empty().eraseToAnyPublisher() // Return empty if there was an error.
    }
    
    // Search for movies using the API.
    func searchMoviesFromApi(mainViewModel: MainViewModel) {
        DispatchQueue.main.async {
            self.movies = [] // Clear previous results.
            self.errorMessage = nil // Clear previous error message.
        }
        
        // Fetch movie data from the API.
        fetchMovie(by: self.searchText)
            .sink(receiveCompletion: { [weak self] receiveCompletion in
                switch receiveCompletion {
                case .failure(let error): // Handle error case.
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] receivedMovies in
                // Save the fetched movies and update the main view model's movie list.
                self?.movies = receivedMovies.search
                mainViewModel.moviesList = self?.movies ?? []
            })
            // Store cancellable to manage memory.
            .store(in: &cancellables)
    }
    
    // Fetch movies on submit action.
    func fetchOnSubmit(mainViewModel: MainViewModel) {
        Task {
            self.searchMoviesFromApi(mainViewModel: mainViewModel)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                guard self.errorMessage == nil else {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        mainViewModel.displaySearchResults = true
                        mainViewModel.displaySearchResultsError = true
                    }
                    return
                }
                if !self.movies.isEmpty {
                    mainViewModel.displaySearchResultsError = false
                    mainViewModel.displaySearchResults = true
                }
            }
        }
    }
    
    // Clean up resources when the view model is deallocated.
    deinit {
        self.cancellables.removeAll()
    }
}


