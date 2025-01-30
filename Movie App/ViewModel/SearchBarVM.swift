//
//  SearchBarVM.swift
//  Movie App
//
//  Created by Hook on 30/01/2025.
//

import SwiftUI
import Combine

// Extension to hide the keyboard
extension UIApplication {
    /// Ends editing for the current application, effectively dismissing the keyboard.
    /// - Parameter force: A Boolean value indicating whether to force the end of editing.
    func endEditing(_ force: Bool) {
        self.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// ViewModel for SearchBarView
class SearchBarViewModel: ObservableObject {
    /// The text entered in the search bar.
    @Published var searchText: String = ""
    
    /// The width multiplier for the text field frame relative to the parent view.
    let textFieldFrameX: CGFloat = 0.6
    
    /// The height multiplier for the text field frame relative to the parent view.
    let textFieldFrameY: CGFloat = 0.065
}
