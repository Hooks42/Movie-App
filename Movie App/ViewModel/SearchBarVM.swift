//
//  SearchBarVM.swift
//  Movie App
//
//  Created by Hook on 30/01/2025.
//

import SwiftUI
import Combine

// Extension to hide the keyboard
extension UIApplication {
    // Ends editing for the current application, effectively dismissing the keyboard.
    // Parameter force: A Boolean value indicating whether to force the end of editing.
    func endEditing(_ force: Bool) {
        self.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// ViewModel for SearchBarView
class SearchBarViewModel: ObservableObject {
    // The text entered in the search bar.
    @Published var searchText: String = ""
    
    // The list of infos we fetched from the API.
    @Published var movie: Movie?
    
    // The error message to display if the API request fails.
    @Published var errorMessage: String?
    
    // cancellables is a set of AnyCancellable objects that store the subscriptions to the publishers.
    private var cancellables = Set<AnyCancellable>()
    
    // The url for the API request.
    private let baseURL: String = "https://www.omdbapi.com/"
    
    // The width multiplier for the text field frame relative to the parent view.
    let textFieldFrameX: CGFloat = 0.6
    
    // The height multiplier for the text field frame relative to the parent view.
    let textFieldFrameY: CGFloat = 0.065
    
    
    // function to fetch the movie data from the API takes a title as a parameter and returns a publisher that.
    func fetchMovie(by title: String) -> AnyPublisher<Movie, Error> {
        print("i'm in fetch Movie")
        do {
            // Load the API key from the environment variables.
            let apiKey = try EnvLoader().load()["API_KEY"] ?? ""
            if apiKey == "" {
                return Empty().eraseToAnyPublisher()
            }
            // Create the URL for the API request.
            let urlString = "\(self.baseURL)?apikey=\(apiKey)&t=\(title)"
            // Create a URL object from the string.
            let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            // Create a publisher to fetch the data from the URL.
            return URLSession.shared.dataTaskPublisher(for: url)
                // Decode the data using the Movie object.
                .map { $0.data }
                // decode Json and convert it to Movie object
                .decode(type: Movie.self, decoder: JSONDecoder())
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
    
    
    func searchMovieFromApi(by title: String) {
        self.movie = nil
        self.errorMessage = nil
        
        // Fetch the movie data from the API.
        fetchMovie(by: title)
            // is used to get the status of API call
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                // if failure save the error
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("Error: \(error)")
                case .finished:
                    print("Finished !")
                    break
                }
                // get the results of API call
            }, receiveValue: { [weak self] movie in
                // save the result
                self?.movie = movie
                print("Movie: \(movie)")
            })
            // stored in cancellable to be freed from the memory later
            .store(in: &cancellables)
    }
    
    deinit {
        self.cancellables.removeAll()
    }
}


