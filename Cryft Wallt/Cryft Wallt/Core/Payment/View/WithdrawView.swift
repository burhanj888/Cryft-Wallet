//
//  WithdrawView.swift
//  Cryft Wallet
//
//  Created by Burhanuddin Jinwala on 12/14/23.
//

import SwiftUI

struct WithdrawView: View {
    @StateObject var viewModel = WalletViewModel() // Assuming this is your view model
    @State private var withdrawAmount: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var transactionSuccess = false
    var body: some View {
        ZStack{
            VStack {
                VStack{
                    
                    Text("Current Balance: ")
                        .font(.title)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.white)
                    Text("$\(viewModel.balance, specifier: "%.2f")")
                        .font(.title)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.white)
                        
                        }
                .padding(.top)
                        .frame(maxWidth: .infinity, maxHeight: 150)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(15)
                
                Spacer()
            
                InputView(text: $withdrawAmount,
                          title: "Withdraw Amount",
                          placeholder: "Enter Amount"
                          )
                .keyboardType(.decimalPad)
                    .padding()
                
                Spacer()
                SlideToPayButton(amount: Double(withdrawAmount) ?? 0, message:"Withdraw") {
                    if let amount = Double(withdrawAmount) {
                        print("withdraw \(amount)")
                        let success = viewModel.withdraw(amount: amount)
                        transactionSuccess = success
                        withdrawAmount = ""
                        alertMessage = success ? "Withdrawal Successful" : "Insufficient funds for withdrawal."
                        showAlert = true
                    } else {
                        transactionSuccess = false
                        alertMessage = "Enter valid amount withdrawal."
                        showAlert = true
                    }
                    // Implement the payment logic here
                }
                
                
                
                
            }
            .padding()
            if showAlert {
                TransactionAlertView(isSuccess: transactionSuccess, message: alertMessage) {
                    showAlert = false
                }
            }
        }
                .padding()
                .onAppear {
                    viewModel.fetchWalletData()
                }
    }
}

#Preview {
    WithdrawView()
}
