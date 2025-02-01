//
//  APIModel.swift
//  Movie App
//
//  Created by Hook on 31/01/2025.
//

import Foundation

// Api model for the movie object.
// codable is used to serialize and deserialize the data.
struct MovieDetails: Codable, Equatable {
    let title: String
    let director: String
    let plot: String
    let poster: String
    
    // Coding keys for the movie object.
    // 
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case director = "Director"
        case plot = "Plot"
        case poster = "Poster"
    }
}

struct Movie: Codable {
    let imdbID: String
    let poster: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case imdbID = "imdbID"
        case poster = "Poster"
    }
}

struct MovieSearch: Codable {
    let search: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}
