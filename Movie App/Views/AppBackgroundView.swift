import SwiftUI

// A view that displays a background with animated circles.
struct AppBackgroundView: View {
    // The ViewModel that manages the state and logic of the view.
    @StateObject private var viewModel = AppBackgroundViewModel()
    
    @EnvironmentObject private var mainViewModel : MainViewModel
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Set the background color and ignore safe area insets.
                Color.myGray
                    .ignoresSafeArea(.all)
                
                Text("Movie App")
                    .font(.custom("LeckerliOne-Regular", size: 70))
                    .foregroundStyle(.white)
                    .offset(y: geo.size.height * -0.25)
                
                // Draw the top right circle with dynamic offset based on ViewModel properties.
                Circle()
                    .fill(Color.orange)
                    .offset(x: geo.size.width * viewModel.topRightCircleX, y: geo.size.height * viewModel.topRightCircleY)
                
                // Draw the bottom left circle with dynamic offset based on ViewModel properties.
                Circle()
                    .fill(Color.orange)
                    .offset(x: geo.size.width * viewModel.bottomLeftCircleX, y: geo.size.height * viewModel.bottomLeftCircleY)
            }
            // Trigger the animation of the circles' positions when the view appears.
            .onChange(of: mainViewModel.isConnected) {
                if mainViewModel.isConnected == true {
                    viewModel.animateCircles()
                }
            }
        }
    }
}

#Preview {
    AppBackgroundView()
}
