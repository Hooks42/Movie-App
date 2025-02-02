//
//  MovieInfosView.swift
//  Movie App
//
//  Created by Hook on 01/02/2025.
//

import SwiftUI

@MainActor
struct MovieInfosView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @StateObject var viewModel = MovieInfosViewModel()
    
    var body: some View {
        ScrollView {
            content
                .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height)
                .background(Color.myGray)
        }
        .background(Color.myGray.ignoresSafeArea())
        .onChange(of: mainViewModel.movieInfos) {
            viewModel.updateView(mainViewModel: mainViewModel)
        }
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(viewModel.viewElements.title.safeValue)
                .movieTitleStyle()
            
            InfoSection(title: "Réalisateur", content: viewModel.viewElements.director)
            
            InfoSection(title: "Synopsis", content: viewModel.viewElements.plot)
    
            MoviePoster(picture: viewModel.picture)
                .padding(.vertical)
        }
        .padding(.horizontal)
    }
}

//MARK: - Reusable components

private struct InfoSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .sectionTitleStyle()
            
            Text(content.safeValue)
                .sectionContentStyle()
        }
        .frame(width: 280, alignment: .leading)
    }
}

private struct MoviePoster: View {
    let picture: Image?
    
    var body: some View {
        Group {
            if let picture {
                picture
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
            } else {
                Image(systemName: "film")
                    .placeholderStyle()
            }
        }
        .frame(maxWidth: 300, maxHeight: 400)
        .shadow(radius: 5)
    }
}

// MARK: - Extensions

extension String {
    var safeValue: String { self == "N/A" ? "Uninformed" : self }
}

// MARK: - Custom styles

extension View {
    func movieTitleStyle() -> some View {
        self
            .font(.custom("LeckerliOne-Regular", size: 40))
            .foregroundColor(.orange)
            .padding(.vertical)
            .frame(width: 280, alignment: .leading)
    }
    
    func sectionTitleStyle() -> some View {
        self
            .font(.custom("Quicksand-SemiBold", size: 20))
            .foregroundColor(.white.opacity(0.8))
    }
    
    func sectionContentStyle() -> some View {
        self
            .font(.custom("Quicksand-SemiBold", size: 16))
            .foregroundColor(.white)
            .lineSpacing(5)
            .fixedSize(horizontal: false, vertical: true)
    }
    
    func placeholderStyle() -> some View {
        self
            .font(.system(size: 60))
            .foregroundColor(.white.opacity(0.3))
            .frame(maxWidth: .infinity, minHeight: 200)
    }
}

#Preview {
    MovieInfosView()
}
