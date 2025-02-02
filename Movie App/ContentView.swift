//
//  ContentView.swift
//  Movie App
//
//  Created by Hook on 30/01/2025.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var mainViewModel: MainViewModel = MainViewModel()
    
    var body: some View {
        GoogleSignInView()
//        GeometryReader { geo in
//            ZStack {
//                MovieInfosView()
//                    .environmentObject(mainViewModel)
//                MainView()
//                    .environmentObject(mainViewModel)
//                    .disabled(mainViewModel.showInfosView)
//                    .cornerRadius(mainViewModel.showInfosView ? 25 : 0)
//                    .overlay(
//                        mainViewModel.showInfosView ?
//                            RoundedRectangle(cornerRadius: 25)
//                                .stroke(Color.orange, lineWidth: 5)
//                            : nil
//                    )
//                    .rotation3DEffect(.init(degrees: mainViewModel.showInfosView ? -35 : 0), axis: (x: 0, y: 1, z: 0), anchor: .trailing)
//                    .offset(x: mainViewModel.showInfosView ? getRect().width / 2 : 0)
//                    .ignoresSafeArea()
//                    .onTapGesture { location in
//                        let screenWidth = geo.size.width
//                        let thirdScreenPartStart = screenWidth * (2/3)
//                        let thirdScreenPartStop = screenWidth
//                        
//                        if location.x >= thirdScreenPartStart && location.x <= thirdScreenPartStop {
//                            withAnimation(.easeInOut(duration: 0.5)) {
//                                self.mainViewModel.showInfosView.toggle()
//                            }
//                        }
//                    }
//            }
//        }
    }
}

extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}

#Preview {
    ContentView()
}
