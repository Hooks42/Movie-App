//
//  SearchBarView.swift
//  Movie App
//
//  Created by Hook on 30/01/2025.
//

import SwiftUI


// A view that displays a search bar for searching movies.

struct SearchBarView: View {
    
    // The view model for managing the state and logic of the search bar.
    @StateObject var viewModel = SearchBarViewModel()
    
    @EnvironmentObject var mainViewModel: MainViewModel
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Create a roundedRectangle for the search bar background.
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.myGray)
                    .stroke(Color.orange, lineWidth: 0.4)
                    .frame(width: geo.size.width * viewModel.textFieldFrameX, height: geo.size.height * viewModel.textFieldFrameY)
                    .shadow(radius: 20)
                ZStack {
                    // Display a placeholder text if the search bar is empty.
                    if viewModel.searchText.isEmpty {
                        Text("Find your film here")
                            .font(.custom("Quicksand-SemiBold", size: 18))
                            .foregroundStyle(.white)
                    }
                    // Display the search text field.
                    TextField("", text: $viewModel.searchText, onEditingChanged: { isEditing in
                        if isEditing {
                            mainViewModel.displaySearchResults = false
                        }
                        })
                        .font(.custom("Quicksand-SemiBold", size: 18))
                        .foregroundStyle(.white)
                        .frame(width: geo.size.width * viewModel.textFieldFrameX - 50, height: geo.size.height * viewModel.textFieldFrameY)
                        // Fetch on return key presssed
                        .onSubmit {
                            viewModel.fetchOnSubmit(mainViewModel: mainViewModel)
                        }
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

#Preview {
    ZStack {
        AppBackgroundView()
        SearchBarView()
    }
    .ignoresSafeArea(.keyboard, edges: .bottom)
    .onTapGesture {
        UIApplication.shared.endEditing(true)
    }
}
