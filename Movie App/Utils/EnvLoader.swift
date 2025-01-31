//
//  EnvLoader.swift
//  Movie App
//
//  Created by Hook on 30/01/2025.
//

import Foundation


// A struct that loads the environment variables from a .env file.
struct EnvLoader {
    
    // Error enum for the EnvLoader
    enum EnvLoaderError: Error {
        case FileNotFound
        case ReadError(Error)
    }
    
    // Load the environment variables from the .env file.
    func load() throws -> [String: String] {
        // Get the path to the .env file.
        guard let path = Bundle.main.path(forResource: ".env", ofType: nil) else {
            throw EnvLoaderError.FileNotFound
        }
        
        do {
            let data = try String(contentsOfFile: path, encoding: .utf8)
            let lines = data.components(separatedBy: .newlines)
            var envDict = [String: String]()
            
            // Parse the lines of the .env file and add the key-value pairs to the dictionary.
            for line in lines {
                if line.isEmpty || line.starts(with: "#") {
                    continue
                }
                // Split the line into key and value parts
                let parts = line.components(separatedBy: "=")
                // Check that the line has the correct format (key=value) then add it to the dictionary
                if parts.count == 2 {
                    let key = parts[0]
                    let value = parts[1]
                    envDict[key] = value
                }
            }
            return envDict
        } catch {
            // Throw an error if there was a problem reading the .env file.
            throw EnvLoaderError.ReadError(error)
        }
    }
}
