//
//  MainVM.swift
//  Movie App
//
//  Created by Hook on 31/01/2025.
//

import SwiftUI
import Combine

class MainViewModel : ObservableObject {
    
    @Published var moviesList: [Movie] = []
    @Published var movieInfos: MovieDetails?
    @Published var errorMessage: String?
    @Published var displaySearchResults: Bool = false
    @Published var displaySearchResultsError: Bool = false
    @Published var movieToSearch: String = ""
    @Published var showInfosView : Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private let baseURL: String = "https://www.omdbapi.com/"
    
    // function to fetch the movie data from the API takes a title as a parameter and returns a publisher that.
    func fetchMovieInfos(by id: String) -> AnyPublisher<MovieDetails, Error> {
        do {
            // Load the API key from the environment variables.
            let apiKey = try EnvLoader().load()["API_KEY"] ?? ""
            if apiKey == "" {
                return Empty().eraseToAnyPublisher()
            }
            // Create the URL for the API request.
            let urlString = "\(self.baseURL)?i=\(id)&apikey=\(apiKey)"
            print(urlString)
            // Create a URL object from the string.
            let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            // Create a publisher to fetch the data from the URL.
            return URLSession.shared.dataTaskPublisher(for: url)
                // Decode the data using the Movie object.
                .map { $0.data }
                // decode Json and convert it to Movie object
                .decode(type: MovieDetails.self, decoder: JSONDecoder())
                // deliver the result on the main thread because the UI needs to be updated.
                .receive(on: DispatchQueue.main)
                // hide how the publisher is implemented and only expose the result.
                .eraseToAnyPublisher()
        }
        catch {
            print("Error loading API key: \(error)")
        }
        
        // Return an empty publisher if there was an error.
        return Empty().eraseToAnyPublisher()
    }
    
    func searchMovieInfosFromApi() {
        DispatchQueue.main.async {
            self.movieInfos = nil
            self.errorMessage = nil
        }
        
        // Fetch the movie data from the API.
        fetchMovieInfos(by: self.movieToSearch)
            // is used to get the status of API call
            .sink(receiveCompletion: { [weak self] receiveCompletion in
                switch receiveCompletion {
                // if failure save the error
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print(error)
                case .finished:
                    break
                }
                // get the results of API call
            }, receiveValue: { [weak self] receivedMovies in
                // save the result
                self?.movieInfos = receivedMovies
                print(self?.movieInfos ?? [])
            })
            // stored in cancellable to be freed from the memory later
            .store(in: &cancellables)
    }
}
