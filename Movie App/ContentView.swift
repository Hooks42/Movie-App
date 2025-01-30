//
//  ContentView.swift
//  Movie App
//
//  Created by Hook on 30/01/2025.
//

import SwiftUI

struct ContentView: View {
    
    @State var topRightCircleX: CGFloat = 0.8 // 0.6
    @State var topRightCircleY: CGFloat = -0.8 // -0.6
    
    @State var bottomLeftCircleX: CGFloat = -1 // -0.6
    @State var bottomLeftCircleY: CGFloat = 0.8 // 0.55
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.myGray
                    .ignoresSafeArea(.all)
                Circle()
                    .fill(Color.myYellow)
                    .offset(x: geo.size.width * self.topRightCircleX, y: geo.size.height * self.topRightCircleY)
                Circle()
                    .fill(Color.myYellow)
                    .offset(x: geo.size.width * bottomLeftCircleX, y: geo.size.height * bottomLeftCircleY)
            }
            .onAppear() {
                withAnimation(Animation.easeInOut(duration: 3)) {
                    self.topRightCircleX = 0.6
                    self.topRightCircleY = -0.6
                    self.bottomLeftCircleX = -0.6
                    self.bottomLeftCircleY = 0.55
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
