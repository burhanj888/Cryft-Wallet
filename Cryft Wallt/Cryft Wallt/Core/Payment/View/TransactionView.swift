//
//  TransactionView.swift
//  Cryft Wallet
//
//  Created by Burhanuddin Jinwala on 12/13/23.
//

import SwiftUI
import SlidingTabView

struct TransactionView: View {
    @State private var selectedTabIndex = 0
    var body: some View {
        VStack(alignment: .leading) {
                    SlidingTabView(selection: self.$selectedTabIndex, tabs: ["Send", "Recieve"])
            if(selectedTabIndex == 0){
                PaymentInitiationView()
            }
            else{
                RecieveView()
            }
            Spacer()
        }
        .padding(.top, 20)
            
    }
}

#Preview {
    TransactionView()
}
