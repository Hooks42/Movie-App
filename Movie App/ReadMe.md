# Movie App

Movie App is an iOS application built with SwiftUI that allows users to search for movies via the OMDb API and view detailed movie information. The app uses the MVVM architectural pattern for a clear separation of concerns and integrates Firebase for user authentication.

## Table of Contents
- [Features](#features)
- [Technical Stack](#technical-stack)
- [Setup and Configuration](#setup-and-configuration)
- [API Integration](#api-integration)
- [Authentication](#authentication)
- [Build and Run](#build-and-run)
- [Technical Decisions](#technical-decisions)
- [Future Enhancements](#future-enhancements)

## Features

- **Homepage:**
  - Displays the app name and the search bar.
  - Fetches movies from the OMDb API based on the search query.
  - Shows a horizontal list of movies matching the query or displays 'Oops we didn't find anything' message

- **Detail Page:**
  - Displays detailed information for a selected movie, including the title, poster, description, and producer information.
  with a smooth 3D animation to make it more pleasant to use.

- **User Authentication:**
  - Supports user registration and login using Firebase Authentication with GoogleSignIn.

## Technical Stack

- **Language & Framework:** Swift, SwiftUI, UIkit
- **Architecture:** MVVM (Model-View-ViewModel)
- **Networking:** 
    - Asynchronous Networking: We use URLSession combined with Combine publishers to perform network requests.
    - Error Handling: Errors are propagated through the Combine pipeline and handled in the ViewModel.
    - Main Thread Delivery: Results are delivered on the main thread to ensure the UI is updated safely.
- **Authentication:** Firebase Authentication and SignInWithGoogle
- **API:** [OMDb API](https://www.omdbapi.com)
- **Version Control:** Git

## Setup and Configuration

### Prerequisites:
- **Development Environment:**
    - Xcode (Version 16.2)
    - Swift
    - Firebase account and project setup.

1. **Clone the repository:**
```bash
git clone https://github.com/Hooks42/Movie-App.git
```

2. **Install Depedencies:**
    - Use Swift Package Manager to install: https://github.com/firebase/firebase-ios-sdk and https://github.com/google/GoogleSignIn-iOS
    
3. **Configure Firebase:**
    - Add your GoogleService-Info.plist to the project
    - Enable Google Sign-In in Firebase Console
    
4. **Add API key**:
    - Create a .env file and put your API key in using this pattern: **API_KEY=XXXXX**
    
## API integration

- The app uses the OMDb API with dynamic query parameters. Example request:
``` swift
    // function to fetch the movie data from the API takes a title as a parameter and returns a publisher that.
    func fetchMovieInfos(by id: String) -> AnyPublisher<MovieDetails, Error> {
        do {
            // Load the API key from the environment variables.
            let apiKey = try EnvLoader().load()["API_KEY"] ?? ""
            if apiKey == "" {
                return Empty().eraseToAnyPublisher()
            }
            // Create the URL for the API request.
            let urlString = "\(self.baseURL)?i=\(id)&apikey=\(apiKey)"
            print(urlString)
            // Create a URL object from the string.
            let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            // Create a publisher to fetch the data from the URL.
            return URLSession.shared.dataTaskPublisher(for: url)
                // Decode the data using the Movie object.
                .map { $0.data }
                // decode Json and convert it to Movie object
                .decode(type: MovieDetails.self, decoder: JSONDecoder())
                // deliver the result on the main thread because the UI needs to be updated.
                .receive(on: DispatchQueue.main)
                // hide how the publisher is implemented and only expose the result.
                .eraseToAnyPublisher()
        }
        catch {
            print("Error loading API key: \(error)")
        }
        
        // Return an empty publisher if there was an error.
        return Empty().eraseToAnyPublisher()
    }
    ```
    
## Authentification

**Firebase Authentification implementation:**
```swift
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
```

## Build And Run
    - Open MovieApp.xcworkspace
    - Select development team in Signing & Capabilities
    - Build (⌘ + B) and run (⌘ + R)


## Technical Decisions

1. **MVVM Architecture:**
    - Clear separation between UI (SwiftUI Views), business logic (ViewModels)
    - Easier testing and maintenance
    
2. **Combine Framework:**
    - Streamlined asynchronous operations
    - Reactive state management for search functionality
    
3. **Firebase Authentication:**
    - Rapid implementation of secure authentication flows
    - Built-in support for multiple providers
    - free 💰
    
4. **Single Page Application:**
    - Dynamic Content Loading: Seamless navigation without page reloads, thanks to client-side routing.
    - State Management: Efficient handling of application state
    - Interactive UI: Smooth animations and transitions for a modern user experience.
    

## Future Enhancements

- Add favoriting system with Firestore
- Implement offline caching using SwiftData
- Add movie trailer previews via YouTube API

