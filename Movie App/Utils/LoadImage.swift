//
//  LoadImage.swift
//  Movie App
//
//  Created by Hook on 01/02/2025.
//

import SwiftUI

func loadImage(by url: String) async -> Image? {
    guard let url = URL(string: url) else {
        return nil
    }
    
    do {
        // Utiliser URLSession pour charger les données de manière asynchrone
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Convertir les données en UIImage
        if let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        } else {
            return nil
        }
    } catch {
        return nil
    }
}
