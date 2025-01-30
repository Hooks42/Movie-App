import SwiftUI

struct AppBackgroundView: View {
    @StateObject private var viewModel = AppBackgroundViewModel()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.myGray
                    .ignoresSafeArea(.all)
                Circle()
                    .fill(Color.myYellow)
                    .offset(x: geo.size.width * viewModel.topRightCircleX, y: geo.size.height * viewModel.topRightCircleY)
                Circle()
                    .fill(Color.myYellow)
                    .offset(x: geo.size.width * viewModel.bottomLeftCircleX, y: geo.size.height * viewModel.bottomLeftCircleY)
            }
            .onAppear {
                viewModel.animateCircles()
            }
        }
    }
}

#Preview {
    AppBackgroundView()
}
