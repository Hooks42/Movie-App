//
//  ContentView.swift
//  Movie App
//
//  Created by Hook on 30/01/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.myGray
                .ignoresSafeArea(.all)
            Circle()
                .fill(Color.myYellow)
                .offset(x: 250, y: -500)
            Circle()
                .fill(Color.myYellow)
                .offset(x: -250, y: 500)
        }
    }
}

#Preview {
    ContentView()
}
