//
//  WalletView.swift
//  Cryft Wallet
//
//  Created by Burhanuddin Jinwala on 12/14/23.
//

import SwiftUI
import SlidingTabView

struct WalletView: View {
    @StateObject var walletModel = WalletViewModel()
    @State private var selectedTabIndex = 0
    var body: some View {
        VStack(alignment: .leading) {
                    SlidingTabView(selection: self.$selectedTabIndex, tabs: ["History", "Deposit", "Withdraw"])
            if(selectedTabIndex == 0){
                TransactionHistoryView(viewModel: walletModel)
            }
            else if(selectedTabIndex == 1){
                DepositView()
            }
            else{
                WithdrawView()
            }
            Spacer()
        }
        .padding(.top, 20)
    }
}

#Preview {
    WalletView()
}
