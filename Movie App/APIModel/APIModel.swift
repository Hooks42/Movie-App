//
//  APIModel.swift
//  Movie App
//
//  Created by Hook on 31/01/2025.
//

import Foundation

// MARK: - MovieDetails
// Api model for the detailed movie object.
// Codable is used to serialize and deserialize the data.
struct MovieDetails: Codable, Equatable {
    let title: String
    let director: String
    let plot: String
    let poster: String
    
    // MARK: CodingKeys
    // Coding keys for the movie object.
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case director = "Director"
        case plot = "Plot"
        case poster = "Poster"
    }
}

// MARK: - Movie
// Api model for a basic movie object.
struct Movie: Codable {
    let imdbID: String
    let poster: String
    let title: String
    
    // MARK: CodingKeys
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case imdbID = "imdbID"
        case poster = "Poster"
    }
}

// MARK: - MovieSearch
// Api model for searching movies.
struct MovieSearch: Codable {
    let search: [Movie]
    
    // MARK: CodingKeys
    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}

