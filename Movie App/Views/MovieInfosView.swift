//
//  MovieInfosView.swift
//  Movie App
//
//  Created by Hook on 01/02/2025.
//

import SwiftUI

@MainActor
struct MovieInfosView: View {
    
    @EnvironmentObject var mainViewModel : MainViewModel
    @StateObject var viewModel : MovieInfosViewModel = MovieInfosViewModel()
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
//                LinearGradient(
//                    gradient: Gradient(colors: [.myYellow, .myGray]),
//                    startPoint: .topTrailing, // Le dégradé commence en haut
//                    endPoint: .bottomLeading // Le dégradé se termine en bas
//                )
                Color.myGray
                    .ignoresSafeArea()
                VStack (spacing: 70){
                    HStack {
                        Text(viewModel.viewElements.title == "N/A" ? "?" : viewModel.viewElements.title)
                            .font(.custom("LeckerliOne-Regular", size: 40))
                            .foregroundStyle(.orange)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: geo.size.width / 2, maxHeight: geo.size.height / 5, alignment: .topLeading)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
                    .padding(.leading, geo.size.width * 0.07)
                    HStack {
                        Text("\(viewModel.viewElements.director == "N/A" ? "?" : viewModel.viewElements.director)")
                            .font(.custom("Quicksand-SemiBold", size: 25))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: geo.size.width / 1.6, maxHeight: geo.size.height / 5, alignment: .topLeading)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
                    .padding(.leading, geo.size.width * 0.07)
                    .offset(y: geo.size.height * 0.05)
                    HStack {
                        Text("\(viewModel.viewElements.plot == "N/A" ? "?" : viewModel.viewElements.plot)")
                            .font(.custom("Quicksand-SemiBold", size: 20))
                            .minimumScaleFactor(0.5)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: geo.size.width / 1.6, maxHeight: geo.size.height / 4, alignment: .topLeading)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
                    .padding(.leading, geo.size.width * 0.07)
                    HStack {
                        if viewModel.picture == nil {
                            Text("?")
                                .font(.custom("Quicksand-SemiBold", size: 20))
                                .foregroundStyle(.white)
                                .frame(maxWidth: geo.size.width / 1.6, maxHeight: geo.size.height / 2, alignment: .topLeading)
                                .fixedSize(horizontal: false, vertical: true)
                        } else {
                            viewModel.picture!
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipped()
                        }
                    }
                    .padding(.trailing, geo.size.width * 0.3)
                    .offset(y: geo.size.height * 0.05)
                    Spacer()
                }
            }
            .onChange(of: mainViewModel.movieInfos) {
                viewModel.updateView(mainViewModel: mainViewModel)
            }
        }
        
    }
}

#Preview {
    MovieInfosView()
}
