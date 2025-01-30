//
//  AppBackgroundVM.swift
//  Movie App
//
//  Created by Hook on 30/01/2025.
//

import SwiftUI

class AppBackgroundViewModel: ObservableObject {
    
    @Published var topRightCircleX: CGFloat = 0.8
    @Published var topRightCircleY: CGFloat = -0.8
    
    @Published var bottomLeftCircleX: CGFloat = -1
    @Published var bottomLeftCircleY: CGFloat = 0.8
    
    func animateCircles() {
        withAnimation(.easeInOut(duration: 3)) {
            topRightCircleX = 0.6
            topRightCircleY = -0.6
            bottomLeftCircleX = -0.6
            bottomLeftCircleY = 0.55
        }
    }
}
