//
//  MainView.swift
//  Movie App
//
//  Created by Hook on 01/02/2025.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var mainViewModel : MainViewModel
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                AppBackgroundView()
                    .environmentObject(mainViewModel)
                if mainViewModel.isConnected == false {
                    withAnimation(.easeInOut(duration: 1)) {
                        GoogleSignInView()
                            .environmentObject(mainViewModel)
                    }
                } else {
                    if mainViewModel.startApp {
                        ProfileView()
                            .offset(x: -geo.size.width * 0.36, y: -geo.size.height * 0.42)
                            .environmentObject(mainViewModel)
                        SearchBarView()
                            .offset(y: geo.size.height * self.mainViewModel.searchBarY)
                            .environmentObject(mainViewModel)
                        if mainViewModel.displaySearchResults == true {
                            SearchDisplayView()
                                .environmentObject(mainViewModel)
                                .offset(y: geo.size.height * 0.2)
                        }
                    }
                }
            }
            .onTapGesture {
                DispatchQueue.main.async {
                    UIApplication.shared.endEditing(true)
                }
            }
            .onAppear() {
                mainViewModel.logInAnimation()
            }
            .onChange(of: mainViewModel.isConnected) {
                mainViewModel.logInAnimation()
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    MainView()
}
