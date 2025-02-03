//
//  SignInWithGoogleView.swift
//  Movie App
//
//  Created by Hook on 02/02/2025.
//

import SwiftUI
import FirebaseAuth

struct GoogleSignInView: View {
    @StateObject private var authVM = AuthViewModel()
    
    @EnvironmentObject private var mainViewModel : MainViewModel

    var body: some View {
        VStack {
            Button(action: {
                authVM.signIn(mainViewModel: mainViewModel)
            }) {
                Image("SignInWithGoogleIMG")
                    .resizable()
                    .frame(width: 200, height: 50)
            }
        }
    }
}

#Preview {
    ZStack {
        AppBackgroundView()
        GoogleSignInView()
    }
}
