//
//  ProfileView.swift
//  Movie App
//
//  Created by Hook on 02/02/2025.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    
    @EnvironmentObject private var mainViewModel : MainViewModel
    @State private var isPresented: Bool = false
    
    // MARK: - Closure to logOut if button pressed
    private var yesActionButton: () -> Void {
        return {
            do {
                try Auth.auth().signOut()
                withAnimation(.easeInOut(duration: 1)) {
                    mainViewModel.isConnected = false
                    mainViewModel.displaySearchResults = false
                    mainViewModel.startApp = false
                }
            } catch {}
        }
    }
    
    
    private var noActionButton: () -> Void {
        return {
            isPresented = false
        }
    }
    
    // MARK: - Profile Image as Button open sheet to manage logout
    var body: some View {
        
        ZStack {
            createProfileButton
        }
        .sheet(isPresented: $isPresented) {
            sheetView
                .presentationDetents([.height(300)])
                .presentationCornerRadius(30)
                .offset(y: -30)
        }
    }
    
    private var createProfileButton : some View {
        Button(action: {
            isPresented = true
        }) {
            Image(systemName: "person.circle")
                .resizable()
                .foregroundStyle(.orange)
                .frame(width: 40, height: 40)
        }
    }
    
    private var sheetView : some View {
        VStack (spacing: 80) {
            Text("Logout ?")
                .font(.custom("Quicksand-SemiBold", size: 40))
                .foregroundStyle(.white)
            HStack (spacing: 30) {
                choiceButton(title: "Yes", fontColor: .white, backgroundColor: .red, buttonAction: yesActionButton)
                choiceButton(title: "No", fontColor: .white, backgroundColor: .green, buttonAction: noActionButton)
            }
        }
    }
    
    // MARK: - Reusable func to create a round button freely
    private struct choiceButton : View {
        let title : String
        let fontColor : Color
        let backgroundColor : Color
        let buttonAction : () -> Void
        
        var body: some View {
            Button(action: buttonAction) {
                Text(self.title)
                    .font(.custom("Quicksand-SemiBold", size: 20))
                    .foregroundStyle(fontColor)
                    .padding()
                    .background(
                        Circle()
                            .foregroundStyle(backgroundColor)
                    )
            }
        }
    }
}

#Preview {
    ZStack {
        AppBackgroundView()
        ProfileView()
            .preferredColorScheme(.dark)
    }
}
