//
//  AppBackgroundVM.swift
//  Movie App
//
//  Created by Hook on 30/01/2025.
//

import SwiftUI

// MARK: - AppBackgroundViewModel
// ViewModel for managing the state and logic of the AppBackgroundView.
class AppBackgroundViewModel: ObservableObject {
    
    // Indicates whether the circles should be displayed.
    @Published var displayCircles = false
    
    // Positions of the circles.
    @Published var topRightCircleX: CGFloat = 0.8
    @Published var topRightCircleY: CGFloat = -0.8
    @Published var bottomLeftCircleX: CGFloat = 1
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
