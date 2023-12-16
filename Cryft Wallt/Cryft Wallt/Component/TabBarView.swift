//
//  TabBarView.swift
//  Cryft Wallet
//
//  Created by Burhanuddin Jinwala on 12/13/23.
//

import SwiftUI

//enum Tab: String, CaseIterable {
//    case profile = "person.circle"
//    case transaction = "arrow.left.arrow.right.circle"
//    case history = "clock"
//}

struct TabBarView: View {
    
    @Binding var selectedTab: Tab
        private var fillImage: String {
            selectedTab.rawValue + ".fill"
        }
    
    var body: some View {
        VStack {
            HStack {
                        ForEach(Tab.allCases, id: \.rawValue) { tab in
                            Spacer()
                            Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                                .scaleEffect(tab == selectedTab ? 1.25 : 1.0)
                                .foregroundColor(tab == selectedTab ? .blue : .gray)
                                .font(.system(size: 20))
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.1)) {
                                        selectedTab = tab
                                    }
                                }
                            Spacer()
                        }
                    }
                    .frame(height: 60)
                    .background(.thinMaterial)
                    .cornerRadius(20)
                    .padding()
                }
    }
}

#Preview {
    TabBarView(selectedTab: .constant(.profile))
    
}
