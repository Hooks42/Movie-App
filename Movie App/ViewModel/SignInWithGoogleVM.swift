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

class AuthViewModel: ObservableObject {
    @Published var errorMessage: String?

    func signIn(mainViewModel: MainViewModel) {
        
        // MARK: - Check if Firebase is Connected
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            errorMessage = "Firebase configuration error"
            return
        }

        // MARK: - Configure Google sign in
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // MARK: - Get the view to create the popUp for SignIn
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            errorMessage = "No root view controller"
            return
        }

        // MARK: - Start Google Connexion --> withPresentig = the view in the Popup
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }

        // MARK: - Get the Connexion token to send it to firebase
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                self?.errorMessage = "Authentication error"
                return
            }
        
        // MARK: - Credentials are infos that Firebase need to know if it's us or not (IDToken + AccessToken)

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

            
        // MARK: - signIn to firebase using google credentials
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    mainViewModel.isConnected = true
                    mainViewModel.startApp = false
                }
            }
        }
    }
}
