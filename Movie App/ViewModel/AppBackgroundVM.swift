//
//  AppBackgroundVM.swift
//  Movie App
//
//  Created by Hook on 30/01/2025.
//

import SwiftUI

// ViewModel for managing the state and logic of the AppBackgroundView.
class AppBackgroundViewModel: ObservableObject {
    
    // Indicates whether the circles should be displayed.
    @Published var displayCircles = false
    
    // X position of the top right circle.
    @Published var topRightCircleX: CGFloat = 0.8
    
    // Y position of the top right circle.
    @Published var topRightCircleY: CGFloat = -0.8
    
    // X position of the bottom left circle.
    @Published var bottomLeftCircleX: CGFloat = 1
    
    // Y position of the bottom left circle.
    @Published var bottomLeftCircleY: CGFloat = 0.8
    
    // Animates the circles to their new positions.
    func animateCircles() {
        withAnimation(.easeInOut(duration: 3)) {
            topRightCircleX = 0.6
            topRightCircleY = -0.6
            bottomLeftCircleX = 0.65
            bottomLeftCircleY = 0.6
        }
    }
}
