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

    var body: some View {
        VStack {
            if authVM.isAuthenticated {
                Text("Connecté avec succès !")
                    .font(.title)
                Button(action: {
                    do {
                        try Auth.auth().signOut()
                        authVM.isAuthenticated = false
                    } catch {
                        print(("tropnul"))
                    }
                }) {
                    Text("Deco toi !")
                }
            } else {
                Button(action: {
                    authVM.signIn()
                }) {
                    HStack {
                        Image(systemName: "g.circle.fill")
                            .font(.title)
                        Text("Continuer avec Google")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(radius: 2)
                    )
                }
                .padding()

                if let error = authVM.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .onAppear() {
            if Auth.auth().currentUser != nil {
                authVM.isAuthenticated = true
            } else {
                authVM.isAuthenticated = false
            }
        }
    }
}

#Preview {
    GoogleSignInView()
}
