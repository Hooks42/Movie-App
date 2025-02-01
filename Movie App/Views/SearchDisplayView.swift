//
//  SearchDisplayView.swift
//  Movie App
//
//  Created by Hook on 31/01/2025.
//

import SwiftUI

struct SearchDisplayView: View {
    
    @EnvironmentObject var mainViewModel: MainViewModel
    
    @StateObject var viewModel: SearchDisplayViewModel = SearchDisplayViewModel()
    
    //    let testUI = [
    //        "https://m.media-amazon.com/images/M/MV5BODQ4YTAwZTItZGFjZi00YjNiLTllYzUtYWY3OWM2OTQzODVkXkEyXkFqcGc@._V1_SX300.jpg",
    //        "https://m.media-amazon.com/images/M/MV5BZTE5MzFlMTktMzBkOC00ZjMxLThmOTAtOGU3ZGEwZGRlNDdjXkEyXkFqcGc@._V1_SX300.jpg",
    //        "https://m.media-amazon.com/images/M/MV5BZGVlNjk3MmItZmUzNy00MzcyLWIzOTktZjllYWU5MDAyMjM1XkEyXkFqcGc@._V1_SX300.jpg",
    //        "https://m.media-amazon.com/images/M/MV5BYjE1MGJkMjUtY2VkNi00N2U1LWI2NWEtMDExNGYzYjRkZTM0XkEyXkFqcGc@._V1_SX300.jpg",
    //        "https://m.media-amazon.com/images/M/MV5BNjc0NjUyNzg3MF5BMl5BanBnXkFtZTYwODMxOTM3._V1_SX300.jpg"
    //    ]
    
    
    
    var body: some View {
        // Display a text if there is an error on search
        if mainViewModel.displaySearchResultsError {
            Text("Oops... we didn't find anything")
                .font(.custom("Quicksand-SemiBold", size: 20))
                .foregroundStyle(.white)
        } else {
            // Display every pictures in a scrollable HStack or Title if no pictures found
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<viewModel.imageTab.count, id: \.self) { index in
                        Button(action: {
                            mainViewModel.movieToSearch = viewModel.imageTab[index].id
                            Task {
                                mainViewModel.searchMovieInfosFromApi()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1 ) {
                                    guard mainViewModel.errorMessage == nil else {
                                        // gerer les erreur
                                        return
                                    }
                                    
                                    guard mainViewModel.movieInfos != nil else {
                                        return
                                    }
                                }
                            }
                            withAnimation(.easeInOut(duration: 1.2)) {
                                mainViewModel.showInfosView = true
                            }
                        }) {
                            if viewModel.imageTab[index].picture != nil {
                                viewModel.imageTab[index].picture!
                                    .resizable()
                                    .frame(width: 130, height: 200)
                            } else {
                                Text(viewModel.imageTab[index].title)
                                    .font(.custom("Quicksand-SemiBold", size: 15))
                                    .foregroundStyle(.white)
                                    .frame(width: 130, height: 200)
                            }
                            }
                        }
                    }
                    .onAppear() {
                        viewModel.animateMoviesPictures(mainViewModel: mainViewModel)
                    }
            }
        }
    }
}

#Preview {
    ZStack {
        ContentView()
        SearchDisplayView()
            .offset(y: 150)
    }
}
