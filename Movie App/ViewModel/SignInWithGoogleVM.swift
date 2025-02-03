//
//  SignInWithGoogleVM.swift
//  Movie App
//
//  Created by Hook on 02/02/2025.
//

import FirebaseCore
import FirebaseAuth
import SwiftUI
import GoogleSignIn

// MARK: - AuthViewModel
// ViewModel for managing user authentication.
class AuthViewModel: ObservableObject {
    @Published var errorMessage: String? // Error message to be displayed during authentication.
    
    // Sign in using Google authentication and connect to Firebase.
    func signIn(mainViewModel: MainViewModel) {
        
        // MARK: - Check if Firebase is Connected
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            errorMessage = "Firebase configuration error" // Handle Firebase config error.
            return
        }

        // MARK: - Configure Google Sign In
        let config = GIDConfiguration(clientID: clientID) // Set up Google sign-in configuration.
        GIDSignIn.sharedInstance.configuration = config // Assign the configuration.

        // MARK: - Get the root view controller for presenting the sign-in popup
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            errorMessage = "No root view controller" // Handle missing root view controller error.
            return
        }

        // MARK: - Start Google Sign In with presenting view
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription // Handle sign-in error.
                return
            }

            // MARK: - Get the authentication token to send to Firebase
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                self?.errorMessage = "Authentication error" // Handle authentication error.
                return
            }

            // MARK: - Create credentials using the ID token and access token
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

            // MARK: - Sign in to Firebase using Google credentials
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    self?.errorMessage = error.localizedDescription // Handle Firebase sign-in error.
                } else {
                    // Successful sign-in, update main view model state.
                    mainViewModel.isConnected = true
                    mainViewModel.startApp = false
                }
            }
        }
    }
}
