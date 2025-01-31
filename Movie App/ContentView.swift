//
//  ContentView.swift
//  Movie App
//
//  Created by Hook on 30/01/2025.
//

import SwiftUI

struct ContentView: View {

    @State private var startApp = false
    @State private var searchBarY: CGFloat = 0.06
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                AppBackgroundView()
                TitleView()
                    .offset(y: geo.size.height * -0.25)
                if startApp {
                    SearchBarView()
                        .offset(y: geo.size.height * self.searchBarY)
                }
            }
            .onTapGesture {
                UIApplication.shared.endEditing(true)
            }
            .onAppear() {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeInOut(duration: 1.5)) {
                        self.startApp = true
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    withAnimation(.easeInOut(duration: 1.5)) {
                        self.searchBarY = 0
                    }
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

#Preview {
    ContentView()
}
