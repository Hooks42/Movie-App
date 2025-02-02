//
//  Movie_AppApp.swift
//  Movie App
//
//  Created by Hook on 30/01/2025.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct Movie_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
