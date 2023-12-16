//
//  Cryft_WalltApp.swift
//  Cryft Wallt
//
//  Created by Burhanuddin Jinwala on 12/12/23.
//

import SwiftUI
import Firebase

@main
struct Cryft_WalltApp: App {
    
    @StateObject var viewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
        
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
