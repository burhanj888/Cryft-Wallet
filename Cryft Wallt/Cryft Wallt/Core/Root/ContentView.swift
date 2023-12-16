//
//  ContentView.swift
//  Cryft Wallt
//
//  Created by Burhanuddin Jinwala on 12/12/23.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case profile = "person.circle"
    case transaction = "arrow.left.arrow.right.circle"
    case history = "dollarsign.circle"
}

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var selectedTab: Tab = .profile
    var body: some View {
        
        Group {
            if viewModel.userSession != nil {
                VStack {
                    switch selectedTab {
                    case .profile:
                        ProfileView()
                    case .transaction:
                        TransactionView()
                    case .history:
                        WalletView()
                    }
                    
                    Spacer()
                    
                    TabBarView(selectedTab: $selectedTab)
                }
            }
            else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
